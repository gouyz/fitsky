//
//  FSPublishWorkVC.swift
//  fitsky
//  发布作品
//  Created by gouyz on 2019/10/21.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController
import SKPhotoBrowser
import AVKit

class FSPublishWorkVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "这里输入内容"
    //// 最大字数
    let contentMaxCount: Int = 1500
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    // 拍照
    var selectCameraImgs: [UIImage] = [UIImage]()
    /// 录制视频、拍照图片
    var recordImg:UIImage = UIImage.init()
    /// 最大选择图片数量
    var maxImgCount: Int = kMaxSelectCount
    /// 已选择图片数量
    var selectImgCount: Int = 0
    // 公开类型（1-公开 2-好友圈 3-仅限自己）
    var openType: Int = 1
    /// 是否是视频
    var isVideo: Bool = false
    /// 视频
    var avAsset: AVURLAsset?
    /// 视频转码后的地址
    var videoOutPutUrl: URL = URL.init(fileURLWithPath: "/")
    /// 话题model
    var topicModel: FSTalkModel?
    /// 地点
    var currAddress: AMapPOI?
    /// 作品分类
    var currWorkCategoryModel:FSWorksCategoryModel?
    /// 作品集
    var currWorkCollectModel:FSWorksCategoryModel?
    
    /// 视频时长
    var videoDuration: Double = 0
    /// 封面图宽
    var imgWidth:Int = 0
    /// 封面图高
    var imgHeight:Int = 0
    /// 是否录制视频
    var isRecord: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "发布作品"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("发表", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        if isRecord {
            GYZLog(videoOutPutUrl)
            setCaramRecord()
        }else{
            setImgData()
        }
        contentTxtView.delegate = self
        contentTxtView.text = placeHolder
        
        addPhotosView.onClickedImgDetailsBlock  = {[unowned self] (index) in
            self.goBigPhotos(index: index)
        }
        
        if let model = topicModel {
            topicView.contentLab.text = model.title
        }
    }
    func setUpUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bgTitleView)
        bgTitleView.addSubview(titleTxtFiled)
        contentView.addSubview(bgView)
        bgView.addSubview(contentTxtView)
        bgView.addSubview(fontCountLab)
        bgView.addSubview(addPhotosView)
        contentView.addSubview(topicView)
        contentView.addSubview(seePowerView)
        contentView.addSubview(addressView)
        contentView.addSubview(categoryView)
        contentView.addSubview(uploadView)
        
        addPhotosView.delegate = self
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        bgTitleView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        titleTxtFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgTitleView)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(bgTitleView.snp.bottom).offset(1)
            //            make.height.equalTo(140)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(100)
        }
        fontCountLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentTxtView)
            make.top.equalTo(contentTxtView.snp.bottom)
            make.height.equalTo(20)
        }
        addPhotosView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentTxtView)
            make.top.equalTo(fontCountLab.snp.bottom).offset(kMargin)
            make.height.equalTo(kPhotosImgHeight3)
            make.bottom.equalTo(-kMargin)
        }
        topicView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(bgView.snp.bottom).offset(5)
            make.height.equalTo(kTitleHeight)
        }
        categoryView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(topicView)
            make.top.equalTo(topicView.snp.bottom).offset(1)
        }
        seePowerView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(topicView)
            make.top.equalTo(categoryView.snp.bottom).offset(1)
        }
        addressView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(topicView)
            make.top.equalTo(seePowerView.snp.bottom).offset(1)
        }
        uploadView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(topicView)
            make.top.equalTo(addressView.snp.bottom).offset(1)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 背景View
    lazy var bgTitleView: UIView = {
        let v = UIView()
        v.backgroundColor = kWhiteColor
        
        return v
    }()
    /// 标题
    lazy var titleTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kGaryFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "这里输入标题"
        
        return textFiled
    }()
    
    /// 背景View
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = kWhiteColor
        
        return v
    }()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        
        return txtView
    }()
    /// 限制字数
    lazy var fontCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "0/\(contentMaxCount)"
        
        return lab
    }()
    /// 添加照片View
    lazy var addPhotosView: LHSAddPhotoView = LHSAddPhotoView.init(frame: CGRect.zero, maxCount: maxImgCount)
    
    /// 选择话题
    lazy var topicView: GYZIconLabArrowView = {
        let selectView = GYZIconLabArrowView()
        selectView.iconView.image = UIImage.init(named: "icon_gambit_tag")
        selectView.nameLab.text = "参与话题"
        selectView.tag = 101
        selectView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return selectView
    }()
    /// 作品分类
    lazy var categoryView: GYZIconLabArrowView = {
        let selectView = GYZIconLabArrowView()
        selectView.iconView.image = UIImage.init(named: "app_icon_classify_no")
        selectView.nameLab.text = "作品分类"
        selectView.tag = 104
        selectView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return selectView
    }()
    /// 谁可以看
    lazy var seePowerView: GYZIconLabArrowView = {
        let selectView = GYZIconLabArrowView()
        selectView.iconView.image = UIImage.init(named: "icon_see_power_tag")
        selectView.nameLab.text = "谁可以看"
        selectView.contentLab.text = "公开"
        selectView.tag = 102
        selectView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return selectView
    }()
    /// 选择地点
    lazy var addressView: GYZIconLabArrowView = {
        let selectView = GYZIconLabArrowView()
        selectView.iconView.image = UIImage.init(named: "app_square_location")
        selectView.nameLab.text = "地点"
        selectView.contentLab.text = "不显示位置"
        selectView.tag = 103
        selectView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return selectView
    }()
    /// 上传至
    lazy var uploadView: GYZIconLabArrowView = {
        let selectView = GYZIconLabArrowView()
        selectView.iconView.image = UIImage.init(named: "app_icon_uploading_no")
        selectView.nameLab.text = "上传至"
        selectView.tag = 105
        selectView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return selectView
    }()
    
    func setImgData(){
        avAsset = nil
        if isVideo {
            self.selectCameraImgs.removeAll()
            maxImgCount = 1
            addPhotosView.maxImgCount = maxImgCount
            videoDuration = selectImgs[0].duration
            imgWidth = selectImgs[0].pixelWidth
            imgHeight = selectImgs[0].pixelHeight
            selectImgs[0].fetchAVAsset { [unowned self] (avAsset, info) in
                self.avAsset = avAsset as? AVURLAsset
                
                self.transformMoive()
            }
        }
        var count:Int = 0
        for item in selectImgs{
            item.fetchFullScreenImage {[unowned self] (image, info) in
                
                self.selectCameraImgs.append(image!)
                count += 1
                if count == self.selectImgs.count{
                    self.selectImgCount = self.selectCameraImgs.count
                    self.resetAddImgView()
                }
            }
        }
    }
    /// 从录制视频跳转过来
    func setCaramRecord(){
        if isVideo {
            self.selectCameraImgs.removeAll()
            maxImgCount = 1
            addPhotosView.maxImgCount = maxImgCount
        }
        self.selectCameraImgs.append(recordImg)
        self.selectImgCount = self.selectCameraImgs.count
        self.resetAddImgView()
    }
    // 发布
    @objc func onClickRightBtn(){
        if titleTxtFiled.text!.isEmpty{
            MBProgressHUD.showAutoDismissHUD(message: "请输入标题")
            return
        }
        if contentTxtView.text.isEmpty || contentTxtView.text == placeHolder{
            MBProgressHUD.showAutoDismissHUD(message: "请输入动态内容")
            return
        }
        if selectCameraImgs.count > 0 {
            if isVideo {
                uploadVideoFiles()
            }else{
                uploadImgFiles()
            }
            
        }else{
            requestPublishDynamic(urls: "", videoUrl: "")
        }
    }
    
    /// 上传图片
    ///
    /// - Parameter params: 参数
    func uploadImgFiles(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        createHUD(message: "加载中...")
        weak var weakSelf = self
        
        var imgsParam: [ImageFileUploadParam] = [ImageFileUploadParam]()
        for (index,imgItem) in selectCameraImgs.enumerated() {
            let imgParam: ImageFileUploadParam = ImageFileUploadParam()
            imgParam.name = "files[]"
            imgParam.fileName = "dynamic\(index).jpg"
            imgParam.mimeType = "image/jpg"
            imgParam.data = UIImage.jpegData(imgItem)(compressionQuality: 0.5)!
            
            imgsParam.append(imgParam)
        }
        
        GYZNetWork.uploadImageRequest("Dynamic/Publish/addMaterial", parameters: nil, uploadParam: imgsParam, success: { (response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["files"].array else { return }
                var urls: String = ""
                for item in data{
                    urls += item["material"].stringValue + ","
                }
                if urls.count > 0{
                    urls = urls.subString(start: 0, length: urls.count - 1)
                }
                weakSelf?.requestPublishDynamic(urls: urls, videoUrl: "")
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 上传视频
    ///
    /// - Parameter params: 参数
    func uploadVideoFiles(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        createHUD(message: "加载中...")
        weak var weakSelf = self
        
        let imgData = UIImage.jpegData(selectCameraImgs[0])(compressionQuality: 0.5)!
        //将图片转为base64编码
        
        let base64 = imgData.base64EncodedString(options: .endLineWithLineFeed)
        
        //        .addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let paramDic: [String: Any] = ["width":"\(imgWidth)","height":"\(imgHeight)","video_poster":"data:image/jpg;base64," + base64,"duration":"\(videoDuration)"]
        
        GYZNetWork.uploadVideoRequest("Dynamic/Publish/addVideo", parameters:paramDic ,fileUrl: videoOutPutUrl, keyName: "files[]", success: { (response) in
            
            GYZLog(response)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["files"].array else { return }
                var urls: String = ""
                var videoUrls: String = ""
                for item in data{
                    urls += item["material"].stringValue + ","
                    videoUrls += item["video"].stringValue + ","
                }
                if urls.count > 0{
                    urls = urls.subString(start: 0, length: urls.count - 1)
                }
                if videoUrls.count > 0{
                    videoUrls = videoUrls.subString(start: 0, length: videoUrls.count - 1)
                }
                weakSelf?.requestPublishDynamic(urls: urls,videoUrl:videoUrls)
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
        
    }
    
    /// - Parameters:
    ///   转换视频
    func transformMoive(){
        
        let outputPath:String = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
        
        let assetTime = self.avAsset?.duration
        
        let duration = CMTimeGetSeconds(assetTime!)
        print("视频时长 \(duration)");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: self.avAsset!)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: self.avAsset!, presetName: AVAssetExportPresetMediumQuality)!
            let existBool = FileManager.default.fileExists(atPath: outputPath)
            if existBool {
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
            
            
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    print("转码成功")
                    //转码成功后获取视频视频地址
                    self.videoOutPutUrl = URL.init(fileURLWithPath: outputPath)
                    //上传
                    //                    self.uploadVideoFiles(mp4Path: mp4Path)
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }
    ///发布动态-提交
    func requestPublishDynamic(urls: String,videoUrl: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        if urls == "" {
            createHUD(message: "加载中...")
        }
        weak var weakSelf = self
        
        var paramDic: [String:Any] = ["content":titleTxtFiled.text!,"material":urls,"open_type":openType,"opus_content": contentTxtView.text!]
        if topicModel != nil {
            paramDic["topic_id"] = (topicModel?.id)!
        }
        if currAddress != nil {
            paramDic["position"] = currAddress?.name
            paramDic["lng"] = currAddress?.location.longitude
            paramDic["lat"] = currAddress?.location.latitude
            paramDic["address"] = currAddress?.address
        }
        if currWorkCategoryModel != nil  {
            paramDic["category_id"] = (currWorkCategoryModel?.id)!
        }
        if currWorkCollectModel != nil  {
            paramDic["opus_category_id"] = (currWorkCollectModel?.id)!
        }
        if !videoUrl.isEmpty {
            paramDic["video"] = videoUrl
            paramDic["video_duration"] = "\(videoDuration)"
        }
        
        GYZNetWork.requestNetwork("Dynamic/Opus/opus", parameters: paramDic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if tag == 101 { //选择话题
            goSelectTopicVC()
        }else if tag == 102 { //谁可以看
            goSeePower()
        }else if tag == 103 { //选择地点
            goSelectAddressVC()
        }else if tag == 104 { //作品分类
            goWorkCategoryVC()
        }else if tag == 105 { //上传至 作品集分类
            goUploadWorkVC()
        }
    }
    // 谁可以看
    func goSeePower(){
        let vc = FSSelectSeePowerVC()
        vc.resultBlock = {[unowned self] (type,name) in
            self.openType = type
            self.seePowerView.contentLab.text = name
        }
        let seeNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(seeNav, animated: true, completion: nil)
    }
    // 选择地址
    func goSelectAddressVC(){
        let vc = FSSelectAddressVC()
        vc.selectPoi = self.currAddress
        vc.resultBlock = {[unowned self] (address) in
            self.currAddress = address
            if  address != nil {
                self.addressView.contentLab.text = address?.name
            }else{
                self.addressView.contentLab.text = "不显示位置"
            }
        }
        let seeNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(seeNav, animated: true, completion: nil)
    }
    // 选择话题
    func goSelectTopicVC(){
        let vc = FSSelectTopicVC()
        vc.resultBlock = {[unowned self] (model) in
            self.topicModel = model
            self.topicView.contentLab.text = model.title
        }
        let seeNav = GYZBaseNavigationVC(rootViewController:vc)
        self.present(seeNav, animated: true, completion: nil)
    }
    //作品分类
    func goWorkCategoryVC(){
        let vc = FSWorkCategoryVC()
        vc.resultBlock = {[unowned self] (model) in
            self.currWorkCategoryModel = model
            self.categoryView.contentLab.text = model.name
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //上传至 作品集分类
    func goUploadWorkVC(){
        let vc = FSUploadWorkVC()
        vc.resultBlock = {[unowned self] (model) in
            self.currWorkCollectModel = model
            self.uploadView.contentLab.text = model.name
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    ///打开相机
    func openCamera(){
        if selectImgCount == kMaxSelectCount{
            MBProgressHUD.showAutoDismissHUD(message: "最多只能上传\(kMaxSelectCount)张图片")
            return
        }
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
//            return
//        }
//
//        GYZOpenCameraPhotosTool.shareTool.checkCameraPermission { (granted) in
//            if granted{
//                let photo = UIImagePickerController()
//                photo.delegate = self
//                photo.sourceType = .camera
//                photo.allowsEditing = true
//                photo.modalPresentationStyle = .fullScreen
//                self.present(photo, animated: true, completion: nil)
//            }else{
//                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头",controller : self)
//            }
//        }
        let vc = FSMagicCameraVC()
        vc.isBack = true
        vc.isWork = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 手机相册
    func goSelectPhotoVC(){
        let vc = FSSelectPhotosVC()
        vc.isBack = true
        vc.isWork = true
        vc.maxImgCount = self.maxImgCount - self.selectImgCount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cleanImg(){
        self.selectImgs.removeAll()
        self.selectCameraImgs.removeAll()
        self.selectImgCount = 0
    }
}
extension FSPublishWorkVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [unowned self] in
            
            //            self.cleanImg()
            self.selectCameraImgs.append(image)
            self.selectImgCount += 1
            self.resetAddImgView()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    /// 选择图片后重新设置图片显示
    func resetAddImgView(){
        var rowIndex = ceil(CGFloat.init(selectImgCount) / 3.0)//向上取整
        /// 预留出增加按钮位置
        if selectImgCount < maxImgCount && selectImgCount % 3 == 0 {
            rowIndex += 1
        }
        let height = kPhotosImgHeight3 * rowIndex + kMargin * (rowIndex - 1)
        
        addPhotosView.snp.updateConstraints({ (make) in
            make.height.equalTo(height)
        })
        addPhotosView.selectImgs = selectCameraImgs
    }
}
extension FSPublishWorkVC : UITextViewDelegate,LHSAddPhotoViewDelegate
{
    ///MARK LHSAddPhotoViewDelegate
    ///添加图片
    func didClickAddImage(photoView: LHSAddPhotoView) {
        
        contentTxtView.resignFirstResponder()
        
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["拍照","来自手机相册"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0{//拍照
                self?.openCamera()
            }else if index == 1 {//从相册选取
                self?.goSelectPhotoVC()
            }
        }
    }
    
    func didClickDeleteImage(index: Int, photoView: LHSAddPhotoView) {
        if isVideo {
            maxImgCount = kMaxSelectCount
            addPhotosView.maxImgCount = maxImgCount
        }
        selectCameraImgs.remove(at: index)
        selectImgCount -= 1
        resetAddImgView()
    }
    /// 查看大图
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotosWithImgs(imgs: selectCameraImgs))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kGaryFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kHeightGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > contentMaxCount - 20 {
            
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            
            //获取高亮部分 － 如果有联想词则解包成功
            if let selectRange =   selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.count
            
            //截取500个字
            if textNum! > contentMaxCount {
                //                let index = textContent?.index((textContent?.startIndex)!, offsetBy: contentMaxCount)
                let str = textContent?.subString(start: 0, length: contentMaxCount)
                textView.text = str
            }
        }
        
        self.fontCountLab.text =  "\(textView.text.count)/\(contentMaxCount)"
    }
}
