//
//  FSEditPhotoVC.swift
//  fitsky
//  编辑图片
//  Created by gouyz on 2020/1/3.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import DKImagePickerController
import MBProgressHUD
import AssetsLibrary

class FSEditPhotoVC: GYZBaseVC {
    
    var numOfPages: Int = 4
    var currPage: Int = 0
    //初始输出分辨率，此值切换画幅的时候用到
    var outputSize: CGSize = CGSize.init(width: kScreenWidth, height: kScreenWidth * 16.0 / 9.0)//CGSize.init(width: 720, height: 1280)
    /// 视频配置参数
    var quVideo: AliyunMediaConfig = AliyunMediaConfig.default()
    /// 多个资源的本地存放文件夹路径 - 从相册选择界面进入传这个值
    var taskPath: String = ""
    var editor: AliyunEditor?
    var player: AliyunIPlayer?
    var exporter: AliyunIExporter?
    var clipConstructor: AliyunIClipConstructor?
    var importor: AliyunImporter?
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    var sourcePathArr: [String] = [String]()
    
    /// 当前滤镜model
    var currFilterModel: AliyunEffectFilterInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"app_next_normal")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedNextBtn))
        self.view.backgroundColor = kBlackColor
        outputSize = quVideo.fixedSize()
        quVideo.outputSize = outputSize
        quVideo.videoQuality = .medium
        quVideo.encodeMode = .hardH264
        //初始化动图资源
        AliyunEffectPrestoreManager.init().insertInitialData()
        ///放到最底层
        //        self.view.insertSubview(scrollView, at: 0)
        //        setImgData()
        
        addSubviews()
        setImgData()
    }
    
    func addSubviews(){
        let factor: CGFloat = outputSize.height / outputSize.width
        movieView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * factor)
        
        self.view.addSubview(movieView)
        self.view.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo((kStateHeight > 20 ? 220 : 200))
        }
        filterView.didSelectItemBlock = {[unowned self] (filterModel) in
            self.currFilterModel = filterModel
            let effectFilter: AliyunEffectFilter = AliyunEffectFilter.init(file: filterModel.localFilterResourcePath())
            //            GYZLog(filterModel.localFilterResourcePath())
            //            GYZLog(effectFilter.path)
            self.editor?.apply(effectFilter)
        }
    }
    func initSDKAbout(path: String){
        editor = AliyunEditor.init(path: path, preview: movieView)
        editor?.delegate = (self as! AliyunIExporterCallback & AliyunIPlayerCallback & AliyunIRenderCallback)
        
        player = editor?.getPlayer()
        exporter = editor?.getExporter()
        clipConstructor = editor?.getClipConstructor()
        
        editor?.startEdit()
        if !(player?.isPlaying())! {
            player?.play()
        }
    }
    func setImgData(){
        //        var count:Int = 0
        //视频存储路径
        let videoSavePath: String = AliyunPathManager.compositionRootDir() + AliyunPathManager.randomString() + ".mp4"
        taskPath = videoSavePath
        importor = AliyunImporter.init(path: videoSavePath, outputSize: outputSize)
        let clip: AliyunClip = AliyunClip.init(imagePath: self.sourcePathArr[0], duration: 1, animDuration: 0)
        self.importor?.addMediaClip(clip)
        let param: AliyunVideoParam = AliyunVideoParam.default()
        param.codecType = .hardware
        param.scaleMode = .fill
        
        self.importor?.setVideoParam(param)
        self.importor?.generateProjectConfigure()
        self.initSDKAbout(path: videoSavePath)
    }
    var movieView: UIView = UIView()
    var filterView: FSFilterView = FSFilterView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //        editor?.startEdit()
        //        if !(player?.isPlaying())! {
        //            player?.play()
        //        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: self.view.bounds)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = false
        scroll.contentOffset = CGPoint.zero
        
        scroll.delegate = self
        
        return scroll
    }()
    
    /// 下一步
    @objc func clickedNextBtn(){
        self.player?.stop()
        self.editor?.stopEdit()
        let videoSavePath: String = AliyunPathManager.compositionRootDir() + AliyunPathManager.randomString() + ".mp4"
        self.exporter?.startExport(videoSavePath)
//        featchFirstFrame(path: <#T##String#>)
    }
    /// 获取视频封面
    func featchFirstFrame(path: String){
        let clip:AliyunClip = AliyunClip.init(videoPath: path, animDuration: 0)
//        let clip:AliyunClip = (self.clipConstructor?.mediaClips()?.first)!
        
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
        
        let image: UIImage = info.captureImage(atTime: 0, outputSize: self.quVideo.outputSize)
        //保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.savePhoto(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //保存到相册中
    @objc func savePhoto(image:UIImage,didFinishSavingWithError:NSError?,contextInfo:Any){
        if didFinishSavingWithError != nil {
            MBProgressHUD.showAutoDismissHUD(message: "保存失败")
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "保存成功")
//            self.goPublishDynamic(isVideo: false, img: image)
        }
    }
}
// MARK: - UIScrollViewDelegate
extension FSEditPhotoVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        //        pageControl.currentPage = Int(offset.x / view.bounds.width)
        currPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
                if currPage == numOfPages - 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.startButton.alpha = 1.0
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.startButton.alpha = 0.0
                    })
                }
    }
}
// MARK: - UIScrollViewDelegate
extension FSEditPhotoVC: AliyunIExporterCallback,AliyunIPlayerCallback,AliyunIRenderCallback{
    func playerDidEnd() {
        
    }
    
    func playProgress(_ playSec: Double, streamProgress streamSec: Double) {
        
    }
    
    func playError(_ errorCode: Int32) {
        
    }
    
    func seekDidEnd() {
        
    }
    
    func playerDidStart() {
        
    }
    
    func exporterDidEnd(_ outputPath: String!) {
//        featchFirstFrame(path: outputPath)
//        let outputPathURL: URL = URL.init(fileURLWithPath: quVideo.outputPath)
        ALAssetsLibrary.init().writeVideoAtPath(toSavedPhotosAlbum: URL.init(fileURLWithPath: outputPath)) {[unowned self] (assetURL, error) in
            self.featchFirstFrame(path: outputPath)
            /// 视频已保存到相册
//            self.goPublishDynamic(isVideo: true, img: self.featchFirstFrame()!)
        }
    }
    
    func exporterDidCancel() {
//        self.player?.resume()
    }
    
    func exportProgress(_ progress: Float) {
        GYZLog(progress)
    }
    
    func exportError(_ errorCode: Int32) {
        GYZLog(errorCode)
    }
    
    func exporterDidStart() {
        
    }
    
    
}
