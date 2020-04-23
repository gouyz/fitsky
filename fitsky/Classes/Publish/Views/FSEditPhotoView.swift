//
//  FSEditPhotoView.swift
//  fitsky
//  单个视频编辑view
//  Created by gouyz on 2020/4/23.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSEditPhotoView: UIView {
    
    //初始输出分辨率，此值切换画幅的时候用到
    var outputSize: CGSize = CGSize.init(width: kScreenWidth, height: kScreenWidth * 16.0 / 9.0)//CGSize.init(width: 720, height: 1280)
    /// 视频配置参数
    var quVideo: AliyunMediaConfig = AliyunMediaConfig.default()
    /// 多个资源的本地存放文件夹路径 - 从相册选择界面进入传这个值
    var taskPath: String = ""
    /// 图片路径
    var imgPath: String = ""
    var editor: AliyunEditor?
    var player: AliyunIPlayer?
    var exporter: AliyunIExporter?
    var clipConstructor: AliyunIClipConstructor?
    var importor: AliyunImporter?
    
    /// 当前滤镜model
    var currFilterModel: AliyunEffectFilterInfo?

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        outputSize = quVideo.fixedSize()
        quVideo.outputSize = outputSize
        quVideo.videoQuality = .medium
        quVideo.encodeMode = .hardH264
        
        setupUI()
        setImgData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        let factor: CGFloat = outputSize.height / outputSize.width
        movieView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * factor)
        
        self.addSubview(movieView)
    }
    var movieView: UIView = UIView()
    
    func setImgData(){
        //视频存储路径
        let videoSavePath: String = AliyunPathManager.compositionRootDir() + AliyunPathManager.randomString() + ".mp4"
        taskPath = videoSavePath
        importor = AliyunImporter.init(path: videoSavePath, outputSize: outputSize)
        let clip: AliyunClip = AliyunClip.init(imagePath: imgPath, duration: 1, animDuration: 0)
        self.importor?.addMediaClip(clip)
        let param: AliyunVideoParam = AliyunVideoParam.default()
        param.codecType = .hardware
        param.scaleMode = .fill
        
        self.importor?.setVideoParam(param)
        self.importor?.generateProjectConfigure()
        self.initSDKAbout(path: videoSavePath)
    }
    func initSDKAbout(path: String){
        editor = AliyunEditor.init(path: path, preview: movieView)
//        editor?.delegate = (self as! AliyunIExporterCallback & AliyunIPlayerCallback & AliyunIRenderCallback)
        
        player = editor?.getPlayer()
        exporter = editor?.getExporter()
        clipConstructor = editor?.getClipConstructor()
        
//        editor?.startEdit()
//        if !(player?.isPlaying())! {
//            player?.play()
//        }
    }
    func startEdit(){
        editor?.startEdit()
        if !(player?.isPlaying())! {
            player?.play()
        }
    }
}
