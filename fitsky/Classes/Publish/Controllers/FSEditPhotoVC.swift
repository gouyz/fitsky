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
    /// 合成的索引
    var currIndex: Int = 0
    var currPage: Int = 0
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    var sourcePathArr: [String] = [String]()
    // 选择的图片UIImage
    var selectCameraImgs: [UIImage] = [UIImage]()
    var editViews: [FSEditPhotoView] = [FSEditPhotoView]()
    // 选择的滤镜
    var selectFilterDic: [Int:AliyunEffectFilter] = [:]
    // 选择的滤镜信息
    var selectFilterInfoDic: [Int:AliyunEffectFilterInfo] = [:]
    /// 是否返回上一页
    var isBack:Bool = false
    /// 是否发布作品
    var isWork:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"app_next_normal")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedNextBtn))
        self.view.backgroundColor = kBlackColor
        //初始化动图资源
        AliyunEffectPrestoreManager.init().insertInitialData()
        self.navigationItem.title = "\((currPage + 1))/\(sourcePathArr.count)"
        
        addSubviews()
    }
    
    func addSubviews(){
        for index in 0..<sourcePathArr.count {
            let editPhotoView: FSEditPhotoView = FSEditPhotoView.init(frame:CGRect(x: self.view.frame.size.width * CGFloat(index), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            editPhotoView.imgPath = self.sourcePathArr[index]
            editPhotoView.editor?.delegate = (self as AliyunIExporterCallback & AliyunIPlayerCallback & AliyunIRenderCallback)
            editViews.append(editPhotoView)
            scrollView.addSubview(editPhotoView)
        }
        ///放到最底层
        self.view.insertSubview(scrollView, at: 0)
        self.view.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo((kStateHeight > 20 ? 220 : 200))
        }
        filterView.didSelectItemBlock = {[unowned self] (filterModel) in
            self.selectFilterInfoDic[self.currPage] = filterModel
            let effectFilter: AliyunEffectFilter = AliyunEffectFilter.init(file: filterModel.localFilterResourcePath())
            self.selectFilterDic[self.currPage] = effectFilter
            //            GYZLog(effectFilter.path)
            self.editViews[self.currPage].editor?.apply(effectFilter)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for index in 0..<editViews.count {
            self.editViews[index].startEdit()
            if !(self.editViews[index].player?.isPlaying())! {
                self.editViews[index].player?.play()
            }
        }
    }
    var filterView: FSFilterView = FSFilterView()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init(frame: self.view.bounds)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = false
        scroll.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.sourcePathArr.count), height: self.view.frame.size.height)
        
        scroll.delegate = self
        
        return scroll
    }()
    
    /// 下一步
    @objc func clickedNextBtn(){
        self.selectCameraImgs.removeAll()
        createHUD(message: "合成中...")
        self.currIndex = 0
        self.stratDeal()
    }
    func stratDeal(){
        let videoSavePath: String = AliyunPathManager.compositionRootDir() + AliyunPathManager.randomString() + ".mp4"
        self.editViews[currIndex].exporter?.startExport(videoSavePath)
    }
    /// 获取视频封面
    func featchFirstFrame(path: String){
        let clip:AliyunClip = AliyunClip.init(videoPath: path, animDuration: 0)
        
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
        
        let image: UIImage = info.captureImage(atTime: 0, outputSize: self.editViews[self.currPage].quVideo.outputSize)
        self.selectCameraImgs.append(image)
        //保存到相册中
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.savePhoto(image:didFinishSavingWithError:contextInfo:)), nil)
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
    func goNext(){// 下一步
        let vc = FSEditPhotoPasterTagVC()
        vc.selectCameraImgs = self.selectCameraImgs
        vc.isBack = self.isBack
        vc.isWork = self.isWork
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UIScrollViewDelegate
extension FSEditPhotoVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        currPage = Int(offset.x / view.bounds.width)
        if self.selectFilterDic.keys.contains(self.currPage) {
            self.filterView.currFilterModel = self.selectFilterInfoDic[self.currPage]
            self.filterView.collectionView.reloadData()
        }else{
            self.filterView.currFilterModel = nil
            self.filterView.collectionView.reloadData()
        }
        self.navigationItem.title = "\((currPage + 1))/\(sourcePathArr.count)"
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
        self.featchFirstFrame(path: outputPath)
        if self.currIndex < self.sourcePathArr.count - 1{
            self.currIndex += 1
            self.stratDeal()
        }else{
            self.hud?.hide(animated: true)
            self.goNext()
        }
//        ALAssetsLibrary.init().writeVideoAtPath(toSavedPhotosAlbum: URL.init(fileURLWithPath: outputPath)) {[unowned self] (assetURL, error) in
//            self.featchFirstFrame(path: outputPath)
//            if self.currIndex < self.sourcePathArr.count - 1{
//                self.currIndex += 1
//                self.stratDeal()
//            }else{
//                self.hud?.hide(animated: true)
//            }
//        }
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
