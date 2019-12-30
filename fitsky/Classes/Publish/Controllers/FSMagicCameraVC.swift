//
//  FSMagicCameraVC.swift
//  fitsky
//  拍照、录制视频
//  Created by gouyz on 2019/12/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import CoreMotion
import MBProgressHUD
import AssetsLibrary


class FSMagicCameraVC: GYZBaseVC {
    //相机旋转角度
    var cameraRotate: NSInteger = 0
    //本地记录的视频录制时长
    var recorderDuration: CGFloat = 0
    //初始输出分辨率，此值切换画幅的时候用到
    var outputSize: CGSize = CGSize.init(width: kScreenWidth, height: kScreenWidth)
    //陀螺仪
    var motionManager: CMMotionManager?
    var queue: OperationQueue = OperationQueue.init()
    var quVideo: AliyunMediaConfig = AliyunMediaConfig.invert()
    //跳转其他页面停止预览，返回开始预览，退后台进入前台则一直在预览。这2种情况通过此变量区别。
    var shouldStartPreviewWhenActive: Bool = false
    /// 拍照还是视频
    var isTakePhoto: Bool = true
    /// 当前滤镜model
    var currFilterModel: AliyunEffectFilterInfo?
    /// 美颜值
    var beautyValue: Int32 = 80
    /// 保存视频
    var library: ALAssetsLibrary = ALAssetsLibrary.init()
    
    /// 是否返回上一页
    var isBack:Bool = false
    /// 是否发布作品
    var isWork:Bool = false
    /// 是否作品集封面
    var isWorkCollection:Bool = false
    /// 是否作品集封面
    var isUserHeader:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kBlackColor
        
        quVideo.outputSize = outputSize
        quVideo.videoQuality = .medium
        quVideo.gop = 250
        quVideo.fps = 30
        quVideo.maxDuration = 10
        quVideo.minDuration = 2
        quVideo.encodeMode = .hardH264
        //初始化动图资源
        AliyunEffectPrestoreManager.init().insertInitialData()
        
//        AliyunVideoSDKInfo.setLogLevel(.debug)
        
        self.setupSubviews()
        self.setSelectDotView()
        addNotification()
        
        updateViewsStatus()
        
        bottomView.startImgView.addOnClickListener(target: self, action: #selector(onClickedStartRecord))
        bottomView.deleteImgView.addOnClickListener(target: self, action: #selector(onClickedDelete))
        bottomView.photoView.addOnClickListener(target: self, action: #selector(onClickedTakePhoto))
        bottomView.videoView.addOnClickListener(target: self, action: #selector(onClickedTakeVideo))
        bottomView.finishImgView.addOnClickListener(target: self, action: #selector(onClickedFinishedRecord))
        
        /// 点击手势
        self.recorder.preview.addOnClickListener(target: self, action: #selector(tapToFocusPoint(sender:)))
        /// 捏合手势
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGesture(sender:)))
        self.recorder.preview.addGestureRecognizer(pinchGesture)
        //开始预览
        self.recorder.startPreview(withPositon: .front)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //开启陀螺仪获取手机旋转角度
        startRetainCameraRotate()
        self.updateNavigationBarTorchModeStatus()
        //录制模块禁止自动熄屏
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.shouldStartPreviewWhenActive {
            self.recorder.startPreview()
            self.shouldStartPreviewWhenActive = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.motionManager?.stopDeviceMotionUpdates()
        //录制模块禁止自动熄屏
        UIApplication.shared.isIdleTimerDisabled = false
        self.recorder.switchTorch(with: .off)
        self.updateNavigationBarTorchModeStatus()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.recorder.stopRecording()
        self.recorder.destroy()
    }
    func setupSubviews(){
        self.view.addSubview(self.recorder.preview)
        self.view.addSubview(self.progressView)
        
        self.view.addSubview(cancleBtn)
        self.view.addSubview(changeSizeBtn)
        self.view.addSubview(changeCameraBtn)
        
        self.view.addSubview(lightBtn)
        self.view.addSubview(filterBtn)
        self.view.addSubview(beautyBtn)
        self.view.addSubview(pasterBtn)
        
        self.view.addSubview(bottomView)
        
        cancleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(progressView.snp.bottom)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        changeSizeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(cancleBtn)
            make.size.equalTo(CGSize.init(width: 36, height: 50))
        }
        changeCameraBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.size.equalTo(cancleBtn)
        }
        
        lightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(changeCameraBtn)
            make.top.equalTo(changeCameraBtn.snp.bottom).offset(40)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: 60))
        }
        filterBtn.snp.makeConstraints { (make) in
            make.right.size.equalTo(lightBtn)
            make.top.equalTo(lightBtn.snp.bottom)
        }
        beautyBtn.snp.makeConstraints { (make) in
            make.right.size.equalTo(filterBtn)
            make.top.equalTo(filterBtn.snp.bottom)
        }
        pasterBtn.snp.makeConstraints { (make) in
            make.right.size.equalTo(filterBtn)
            make.top.equalTo(beautyBtn.snp.bottom)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(150)
        }
        
        lightBtn.set(image: UIImage.init(named: "app_icon_camera_light_no"), title: "闪光灯", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
        filterBtn.set(image: UIImage.init(named: "app_icon_camera_filter"), title: "滤镜", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
        beautyBtn.set(image: UIImage.init(named: "app_icon_camera_beauty"), title: "美颜", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
        pasterBtn.set(image: UIImage.init(named: "app_icon_camera_paster"), title: "贴纸", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
    }
    /// 进度条
    lazy var progressView: QUProgressView = {
        let proView = QUProgressView.init(frame: CGRect.init(x: 0, y: kStateHeight + 5, width: kScreenWidth, height: 6))
        proView.showBlink = false
        proView.showNoticePoint = true
        proView.backgroundColor = UIColor.ColorHex("#f6f6f6")
        proView.colorProgress = kOrangeFontColor
        proView.maxDuration = self.quVideo.maxDuration
        proView.minDuration = self.quVideo.minDuration
        
        return proView
    }()
    /// 取消
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.tag = 101
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 切换视频比例
    lazy var changeSizeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_camera_9_16"), for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 切换相机
    lazy var changeCameraBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_camera_rotation_btn"), for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    //录制
    lazy var recorder: AliyunIRecorder = {
        //清除之前生成的录制路径
        let recordDir: String = AliyunPathManager.createRecrodDir()
        AliyunPathManager.clearDir(recordDir)
        //生成这次的存储路径
        let taskPath: String = recordDir + AliyunPathManager.randomString()
        //视频存储路径
        let videoSavePath: String = taskPath + AliyunPathManager.randomString() + ".mp4"
        let record: AliyunIRecorder = AliyunIRecorder.init(delegate: self, videoSize: self.quVideo.outputSize)
        record.preview = UIView.init(frame: self.previewFrame())
        //SDK自带人脸识别只支持YUV格式
        record.outputType = .type420f
        record.useFaceDetect = true
        record.faceDetectCount = 2
        record.frontCaptureSessionPreset = AVCaptureSession.Preset.hd1280x720.rawValue
        record.encodeMode = (self.quVideo.encodeMode == .softFFmpeg) ? 0 : 1
        record.gop = self.quVideo.gop
        record.videoQuality = AliyunVideoQuality(rawValue: self.quVideo.videoQuality.rawValue)!
        record.recordFps = self.quVideo.fps
        record.outputPath = videoSavePath
        self.quVideo.outputPath = record.outputPath
        record.taskPath = taskPath
        record.beautifyStatus = true
        record.clipManager.maxDuration = self.quVideo.maxDuration
        record.clipManager.minDuration = self.quVideo.minDuration
        
        
        return record
    }()
    lazy var bottomView: FSCameraBottomView = FSCameraBottomView()
    //聚焦框
    lazy var focusView: AlivcRecordFocusView = {
        let focus = AlivcRecordFocusView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150))
        focus.animation = true
        self.recorder.preview.addSubview(focus)
        
        return focus
    }()
    /// 闪光灯
    lazy var lightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.tag = 104
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 滤镜
    lazy var filterBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.tag = 105
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 美颜
    lazy var beautyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.tag = 106
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 贴纸
    lazy var pasterBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.tag = 107
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 操作
    @objc func onClickedOperator(sender:UIButton){
        let tag = sender.tag
        switch tag {
        case 101:// 取消
            self.recorder.stopPreview()
            self.clickedBackBtn()
        case 102:// 切换视频比例
            switchRatio()
        case 103:// 切换相机
            changeCamera()
        case 104:// 切换闪光灯
            changeFlash()
        case 105:// 滤镜
            showBeautyView(isFilter: true)
        case 106:// 美颜
            showBeautyView(isFilter: false)
        case 107: // 贴纸
//            self.showPasterView()
            break
        default:
            break
        }
    }
    /// 显示美颜
    func showBeautyView(isFilter: Bool){
        let beautyView:FSBeautyView = FSBeautyView.init()
        if currFilterModel != nil {
            beautyView.currFilterModel = currFilterModel
        }
        beautyView.sliderView.setValue(Float(beautyValue), animated: true)
        if isFilter {
            beautyView.collectionView.isHidden = false
            beautyView.sliderView.isHidden = true
            beautyView.filterDotView.isHidden = false
            beautyView.beautyDotView.isHidden = true
        }else{
            beautyView.collectionView.isHidden = true
            beautyView.sliderView.isHidden = false
            beautyView.filterDotView.isHidden = true
            beautyView.beautyDotView.isHidden = false
        }
        beautyView.sliderView.valueChanged = {[unowned self] (slider) in
            self.beautyValue = Int32(ceil((slider?.value)!))
            self.recorder.beautifyStatus = true
            self.recorder.beautifyValue = self.beautyValue
        }
        beautyView.didSelectItemBlock = {[unowned self] (filterModel) in
            self.currFilterModel = filterModel
            let effectFilter: AliyunEffectFilter = AliyunEffectFilter.init(file: filterModel.localFilterResourcePath())
//            GYZLog(filterModel.localFilterResourcePath())
//            GYZLog(effectFilter.path)
            self.recorder.apply(effectFilter)
        }
        beautyView.onClickedOperatorBlock = {[unowned self] (tag,sender) in
            if tag == 101 {// 滤镜
                sender.collectionView.isHidden = false
                sender.sliderView.isHidden = true
                sender.filterDotView.isHidden = false
                sender.beautyDotView.isHidden = true
            }else if tag == 102 {// 美颜
                sender.collectionView.isHidden = true
                sender.sliderView.isHidden = false
                sender.filterDotView.isHidden = true
                sender.beautyDotView.isHidden = false
            }else{// 贴纸
//                self.showPasterView()
            }
        }
        beautyView.show()
    }
    /// 贴纸View
    func showPasterView(){
        let pasterView = FSPasterImgView.init()
        pasterView.show()
    }
    //切换画幅
    func switchRatio(){
        //关闭闪光灯
        self.recorder.switchTorch(with: .off)
        self.updateNavigationBarTorchModeStatus()
        quVideo.videoRotate = 0
        var sizeImgName: String = ""
        switch quVideo.mediaRatio() {
        case .ratio9To16:
            quVideo.outputSize = CGSize.init(width: outputSize.width, height: outputSize.width * 4.0 / 3.0)
            sizeImgName = "app_icon_take_photo_size_3_4"
        case .ratio3To4:
            quVideo.outputSize = CGSize.init(width: outputSize.width, height: outputSize.width)
            sizeImgName = "app_icon_take_photo_size_1_1"
        case .ratio1To1:
            quVideo.outputSize = CGSize.init(width: outputSize.width, height: outputSize.width * 16.0 / 9.0)
            sizeImgName = "app_icon_camera_9_16"
        default:
            break
        }
        changeSizeBtn.setImage(UIImage.init(named: sizeImgName), for: .normal)
        self.changePreviewSize()
    }
    
    func changePreviewSize(){
        self.recorder.reStartPreview(withVideoSize: quVideo.fixedSize())
        UIView.animate(withDuration: 0.3, animations: {
            self.recorder.preview.frame = self.previewFrame()
        }) { (finished) in
            
        }
    }
    //切换摄像头
    func changeCamera(){
        if !self.checkAVAuthorizationStatus() {
            return
        }
        self.recorder.switchCameraPosition()
        self.updateNavigationBarTorchModeStatus()
    }
    //闪光灯
    func changeFlash(){
        if self.recorder.torchMode == .off {
            self.recorder.switchTorch(with: .on)
        }else{
            self.recorder.switchTorch(with: .off)
        }
        self.updateNavigationBarTorchModeStatus()
    }
    /// 开始录制
    @objc func onClickedStartRecord(){
        if isTakePhoto {// 拍照
            takePhotos()
        }else{// 录制视频
            if self.recorder.isRecording {
                self.recorder.stopRecording()
                self.updateViewsStatus()
            }else{
                if !self.checkAVAuthorizationStatus() {
                    return
                }
                
                if self.recorder.clipManager.partCount <= 0 {
                    self.recorder.cameraRotate = Int32(self.cameraRotate)
                    self.quVideo.videoRotate = self.recorder.cameraRotate
                }
                if self.recorder.startRecording() == 0 {
                    self.updateViewsStatus()
                }
            }
        }
    }
    // 拍照
    func takePhotos(){
        self.recorder.takePhoto { [unowned self](image, originImage) in
            //保存到相册中
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.savePhoto(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    //保存到相册中
    @objc func savePhoto(image:UIImage,didFinishSavingWithError:NSError?,contextInfo:Any){
        if didFinishSavingWithError != nil {
            MBProgressHUD.showAutoDismissHUD(message: "保存失败")
        }else{
//            MBProgressHUD.showAutoDismissHUD(message: "保存成功")
            self.goPublishDynamic(isVideo: false, img: image)
        }
    }
    /// 删除
    @objc func onClickedDelete(){
        self.recorder.clipManager.deletePart()
        self.progressView.videoCount = self.recorder.clipManager.partCount
        self.recorderDuration = self.recorder.clipManager.duration
        self.progressView.updateProgress(self.recorder.clipManager.duration)
        self.updateViewsStatus()
    }
    /// 完成
    @objc func onClickedFinishedRecord(){
        if self.recorder.clipManager.partCount > 0 {
            self.recorder.finishRecording()
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请先录制视频")
        }
    }
    /// 拍照
    @objc func onClickedTakePhoto(){
        isTakePhoto = true
        setSelectDotView()
    }
    /// 拍视频
    @objc func onClickedTakeVideo(){
        isTakePhoto = false
        setSelectDotView()
    }
    func setSelectDotView(){
        bottomView.startImgView.image = UIImage.init(named: (isTakePhoto ? "app_icon_take_photo_btn_white" : "app_icon_take_video_btn_no"))
        bottomView.photoDotView.isHidden = !isTakePhoto
        bottomView.videoDotView.isHidden = isTakePhoto
        progressView.isHidden = isTakePhoto
        if isTakePhoto {
            quVideo.outputSize = CGSize.init(width: outputSize.width, height: outputSize.width)
            changeSizeBtn.setImage(UIImage.init(named: "app_icon_take_photo_size_1_1"), for: .normal)
        }else{
            quVideo.outputSize = CGSize.init(width: outputSize.width, height: outputSize.width * 16.0 / 9.0)
            changeSizeBtn.setImage(UIImage.init(named: "app_icon_camera_9_16"), for: .normal)
        }
        self.changePreviewSize()
    }
    //更新UI状态
    func updateViewsStatus(){
        /// 删除按钮状态
        bottomView.deleteImgView.isHidden = !(self.recorder.clipManager.partCount > 0)
        bottomView.startImgView.isHighlighted = self.recorder.isRecording
    }
    //更新闪光灯按钮状态
    func updateNavigationBarTorchModeStatus(){
        if self.recorder.cameraPosition == .front {//前置摄像头禁用闪光灯
            lightBtn.isEnabled = false
            lightBtn.set(image: UIImage.init(named: "app_icon_camera_light_no"), title: "闪光灯", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
        }else{//后置摄像头
            lightBtn.isEnabled = true
            if self.recorder.torchMode == .on {
                lightBtn.set(image: UIImage.init(named: "app_icon_camera_light_yes"), title: "闪光灯", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
            }else{
                lightBtn.set(image: UIImage.init(named: "app_icon_camera_light_no"), title: "闪光灯", titlePosition: .bottom, additionalSpacing: 10, state: .normal)
            }
        }
    }
    //点按手势的触发方法
    @objc func tapToFocusPoint(sender:UITapGestureRecognizer){
        let point: CGPoint = sender.location(in: sender.view)
        self.recorder.focusPoint = point
        self.focusView.center = point
        self.recorder.preview.bringSubviewToFront(self.focusView)
    }
    //捏合手势的触发方法
    @objc func pinchGesture(sender:UIPinchGestureRecognizer){
        if sender.velocity.isNaN || sender.numberOfTouches != 2 {
            return
        }
        self.recorder.videoZoomFactor = sender.velocity
        sender.scale = 1
        return
    }
    //开启陀螺仪获取手机旋转角度
    func startRetainCameraRotate(){
        if motionManager == nil {
            motionManager = CMMotionManager.init()
        }
        if motionManager!.isDeviceMotionActive {
            motionManager?.deviceMotionUpdateInterval = 1
            motionManager?.startDeviceMotionUpdates(to: self.queue, withHandler: { [unowned self](motion, error) in
                // Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
                
                let gravityX: Double = (motion?.gravity.x)!
                let gravityY: Double = (motion?.gravity.y)!
                //手机旋转角度
                let xyTheta: Double = atan2(gravityX, gravityY) / .pi * 180.0
                
                if xyTheta >= -45 && xyTheta <= 45{//down
                    self.cameraRotate = 180
                }else if xyTheta > 45 && xyTheta < 135{//left
                    self.cameraRotate = 90
                }else if (xyTheta >= 135 && xyTheta < 180) || (xyTheta >= -180 && xyTheta < -135) {//up
                    self.cameraRotate = 0
                }else if xyTheta >= -135 && xyTheta < -45 {//right
                    self.cameraRotate = 270;
                }
            })
        }
    }
    //预览view的坐标大小计算
    func previewFrame()->CGRect{
        let ratio: CGFloat = quVideo.outputSize.width / quVideo.outputSize.height
        var finalFrame: CGRect = CGRect.init(x: 0, y: kNoStatusBarSafeTop + 44 + 10, width: kScreenWidth, height: kScreenWidth / ratio)
        if quVideo.mediaRatio() == .ratio9To16 {
            finalFrame = CGRect.init(x: (kScreenWidth - kScreenHeight * ratio) / 2.0, y: 0, width: kScreenHeight * ratio, height: kScreenHeight)
        }
        
        return finalFrame
    }
    //检测权限
    func checkAVAuthorizationStatus()->Bool{
        for mediaType in [AVMediaType.video,AVMediaType.audio] {
            if AVCaptureDevice.authorizationStatus(for: mediaType) != .authorized {
                self.showAVAuthorizationAlertWithMediaType(mediaType: mediaType)
                return false
            }
        }
        return true
    }
    //显示一个权限弹窗
    func showAVAuthorizationAlertWithMediaType(mediaType: AVMediaType){
        var title: String = "打开相机失败"
        var msg: String = "摄像头无权限"
        if mediaType == .audio {
            title = "获取麦克风权限失败"
            msg = "麦克风无权限"
        }
        GYZAlertViewTools.alertViewTools.showAlert(title: title, message: msg, cancleTitle: "取消", viewController: self, buttonTitles: "设置") { [unowned self](tag) in
            
            if tag != cancelIndex{
                self.goSetting()
            }
        }
    }
    /// 去设置
    func goSetting(){
        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
    }
    /// 监听通知
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive(noti:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(noti:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive(noti:Notification){
        self.recorder.switchTorch(with: .off)
        if self.recorder.isRecording {
            self.recorder.stopRecording()
        }
        self.updateViewsStatus()
    }
    
    @objc func appDidBecomeActive(noti:Notification){
        //刷新闪光灯按钮状态
        self.updateNavigationBarTorchModeStatus()
    }
}

extension FSMagicCameraVC: AliyunIRecorderDelegate{
    func recorderDeviceAuthorization(_ status: AliyunIRecorderDeviceAuthor) {
        DispatchQueue.main.async {
            if status == .audioDenied{
                self.showAVAuthorizationAlertWithMediaType(mediaType: .audio)
            }else if status == .videoDenied{
                self.showAVAuthorizationAlertWithMediaType(mediaType: .video)
            }
            //当权限有问题的时候，不会走startPreview，所以这里需要更新下UI
        }
    }
    // 录制进度
    func recorderVideoDuration(_ duration: CGFloat) {
        self.progressView.updateProgress(duration)
        self.recorderDuration = duration
    }
    /// 停止录制
    func recorderDidStopRecording() {
        /// 停止录制
        self.progressView.videoCount = self.recorder.clipManager.partCount
        /// 删除按钮状态
        bottomView.deleteImgView.isHidden = !(self.recorder.clipManager.partCount > 0)
    }
    /// 完成录制
    func recorderDidFinishRecording() {
        //停止预览
        self.recorder.stopPreview()
        self.shouldStartPreviewWhenActive = true
        
        library.writeVideoAtPath(toSavedPhotosAlbum: URL.init(fileURLWithPath: self.recorder.outputPath)) {[unowned self] (assetURL, error) in
            /// 视频已保存到相册
            self.goPublishDynamic(isVideo: true, img: self.featchFirstFrame()!)
        }
        
        
    }
    //当录至最大时长时回调
    func recorderDidStopWithMaxDuration() {
        self.recorder.finishRecording()
    }
    /// 开始预览
    func recorderDidStartPreview() {
        
    }
    // 录制异常
    func recoderError(_ error: Error!) {
        self.updateViewsStatus()
    }
    
    /// 获取视频封面
    func featchFirstFrame()->UIImage?{
        let clip:AliyunClip = AliyunClip.init(videoPath: self.recorder.outputPath, animDuration: 0)
        
        let info: AliAssetInfo = AliAssetInfo.init()
        info.path = clip.src
        info.duration = clip.duration
        info.animDuration = 0
        info.startTime = clip.startTime
        if clip.mediaType == .video {
            info.type = .video
        }else{
            info.type = .image
        }
        
        return info.captureImage(atTime: 0, outputSize: self.quVideo.outputSize)
    }
    func goPublishVC(isVideo: Bool,img:UIImage){
        let vc = FSPublishDynamicVC()
        vc.recordImg = img
        vc.isVideo = isVideo
        vc.isRecord = true
        if isVideo {
            vc.videoOutPutUrl = URL.init(fileURLWithPath: self.recorder.outputPath)
            vc.imgWidth = Int(self.quVideo.outputSize.width)
            vc.imgHeight = Int(self.quVideo.outputSize.height)
            vc.videoDuration = Double(self.recorder.clipManager.duration)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
   
    func goPublishDynamic(isVideo: Bool,img:UIImage){
        if isBack {
            for i in 0..<(navigationController?.viewControllers.count)!{
                
                if isWork {// 发布作品
                    if navigationController?.viewControllers[i].isKind(of: FSPublishWorkVC.self) == true {

                        let vc = navigationController?.viewControllers[i] as! FSPublishWorkVC
                        vc.recordImg = img
                        vc.isVideo = isVideo
                        vc.isRecord = true
                        if isVideo {
                            vc.videoOutPutUrl = URL.init(fileURLWithPath: self.recorder.outputPath)
                            vc.imgWidth = Int(self.quVideo.outputSize.width)
                            vc.imgHeight = Int(self.quVideo.outputSize.height)
                            vc.videoDuration = Double(self.recorder.clipManager.duration)
                        }
                        vc.setCaramRecord()
                        _ = navigationController?.popToViewController(vc, animated: true)

                        break
                    }
                }else if isWorkCollection { // 作品集
//                    if navigationController?.viewControllers[i].isKind(of: FSWorkCollectionVC.self) == true {
//
//                        let vc = navigationController?.viewControllers[i] as! FSWorkCollectionVC
//                        vc.selectImgs = self.pickerController.selectedAssets
//                        vc.setImgData()
//                        _ = navigationController?.popToViewController(vc, animated: true)
//
//                        break
//                    }
                }else if isUserHeader { // 修改用户头像
//                    if navigationController?.viewControllers[i].isKind(of: FSMyProfileVC.self) == true {
//
//                        let vc = navigationController?.viewControllers[i] as! FSMyProfileVC
//                        vc.selectImgs = self.pickerController.selectedAssets
//                        vc.setImgData()
//                        _ = navigationController?.popToViewController(vc, animated: true)
//
//                        break
//                    }
                }else{
                    if navigationController?.viewControllers[i].isKind(of: FSPublishDynamicVC.self) == true {
                        
                        let vc = navigationController?.viewControllers[i] as! FSPublishDynamicVC
                        vc.recordImg = img
                        vc.isVideo = isVideo
                        vc.isRecord = true
                        if isVideo {
                            vc.videoOutPutUrl = URL.init(fileURLWithPath: self.recorder.outputPath)
                            vc.imgWidth = Int(self.quVideo.outputSize.width)
                            vc.imgHeight = Int(self.quVideo.outputSize.height)
                            vc.videoDuration = Double(self.recorder.clipManager.duration)
                        }
                        vc.setCaramRecord()
                        _ = navigationController?.popToViewController(vc, animated: true)
                        
                        break
                    }
                }
            }
        }else{
            if isWork {
                let vc = FSPublishWorkVC()
                vc.recordImg = img
                vc.isVideo = isVideo
                vc.isRecord = true
                if isVideo {
                    vc.videoOutPutUrl = URL.init(fileURLWithPath: self.recorder.outputPath)
                    vc.imgWidth = Int(self.quVideo.outputSize.width)
                    vc.imgHeight = Int(self.quVideo.outputSize.height)
                    vc.videoDuration = Double(self.recorder.clipManager.duration)
                }
                navigationController?.pushViewController(vc, animated: true)
            }else if isWorkCollection { // 作品集
//                let vc = FSWorkCollectionVC()
//                vc.selectImgs = self.pickerController.selectedAssets
//                navigationController?.pushViewController(vc, animated: true)
            }else if isUserHeader { // 修改用户头像
//                let vc = FSMyProfileVC()
//                vc.selectImgs = self.pickerController.selectedAssets
//                navigationController?.pushViewController(vc, animated: true)
            }else{
                goPublishVC(isVideo: isVideo, img: img)
            }
            
        }
        
    }
}
