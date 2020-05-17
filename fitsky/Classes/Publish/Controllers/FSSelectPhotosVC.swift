//
//  FSSelectPhotosVC.swift
//  fitsky
//  图片和视频
//  Created by gouyz on 2019/9/2.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import DKImagePickerController

class FSSelectPhotosVC: GYZWhiteNavBaseVC {
    
    var maxImgCount = kMaxSelectCount
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    var photoPathArr: [String] = [String]()
    /// 是否返回上一页
    var isBack:Bool = false
    /// 是否发布作品
    var isWork:Bool = false
    /// 是否作品集封面
    var isWorkCollection:Bool = false
    /// 是否作品集封面
    var isUserHeader:Bool = false
    
    var pickerController: DKImagePickerController = {
        let pickerController = DKImagePickerController()
        pickerController.sourceType = .photo
        pickerController.inline = true
        pickerController.UIDelegate = FSCustomUIDelegate()
        pickerController.allowMultipleTypes = false
        
        return pickerController
    }()
    ///
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_next_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "app_next_disnable"), for: .disabled)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "图片和视频"
        
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        rightBtn.isEnabled = false
        
        pickerController.maxSelectableCount = maxImgCount
        if selectImgs.count > 0 {
            pickerController.select(assets: selectImgs)
            rightBtn.isEnabled = true
        }
        let pickerView = pickerController.view!
        self.view.addSubview(pickerView)
        pickerView.snp.makeConstraints({ (make) in
            make.top.equalTo(kTitleAndStateHeight)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        
        pickerController.selectedChanged = { [unowned self] () in
            if self.pickerController.selectedAssets.count > 0 {
                if self.pickerController.selectedAssets[0].type == .video{
                    self.goPublishDynamic(isVideo:true)
                    return
                }
            }
            self.rightBtn.isEnabled = self.pickerController.selectedAssets.count > 0 ? true : false
        }
        /// 清除视频合成目录
        AliyunPathManager.clearDir(AliyunPathManager.compositionRootDir())
    }
    /// 下一步
    @objc func onClickRightBtn(){
        if isWorkCollection || isUserHeader{
            goPublishDynamic(isVideo:false)
        }else{
            savePhoto()
        }
    }
    
    func savePhoto(){
        self.photoPathArr.removeAll()
        createHUD(message: "处理中...")
        for item in self.pickerController.selectedAssets {
            let tmpPhotoPath: String = AliyunPathManager.compositionRootDir() + AliyunPathManager.randomString() + ".jpg"
            AliyunPhotoLibraryManager.shared()?.savePhoto(with: item.originalAsset, maxSize: CGSize.init(width: item.originalAsset?.pixelWidth ?? 1080, height: item.originalAsset?.pixelHeight ?? 1920), outputPath: tmpPhotoPath, completion: { [unowned self](error, image) in
                self.photoPathArr.append(tmpPhotoPath)
                if self.photoPathArr.count == self.pickerController.selectedAssets.count{
                    self.hud?.hide(animated: true)
                    self.goPublishDynamic(isVideo: false)
                }
            })
        }
    }
    
    func goPublishDynamic(isVideo: Bool){
        if isBack {
            if isVideo {
                for i in 0..<(navigationController?.viewControllers.count)!{
                    
                    if isWork {// 发布作品
                        if navigationController?.viewControllers[i].isKind(of: FSPublishWorkVC.self) == true {
                            
                            let vc = navigationController?.viewControllers[i] as! FSPublishWorkVC
                            vc.selectImgs = self.pickerController.selectedAssets
                            vc.isVideo = isVideo
                            vc.setImgData()
                            _ = navigationController?.popToViewController(vc, animated: true)
                            
                            break
                        }
                    }else if isWorkCollection { // 作品集
                        if navigationController?.viewControllers[i].isKind(of: FSWorkCollectionVC.self) == true {
                            
                            let vc = navigationController?.viewControllers[i] as! FSWorkCollectionVC
                            vc.selectImgs = self.pickerController.selectedAssets
                            vc.setImgData()
                            _ = navigationController?.popToViewController(vc, animated: true)
                            
                            break
                        }
                    }else if isUserHeader { // 修改用户头像
                        if navigationController?.viewControllers[i].isKind(of: FSMyProfileVC.self) == true {
                            
                            let vc = navigationController?.viewControllers[i] as! FSMyProfileVC
                            vc.selectImgs = self.pickerController.selectedAssets
                            vc.setImgData()
                            _ = navigationController?.popToViewController(vc, animated: true)
                            
                            break
                        }
                    }else{
                        if navigationController?.viewControllers[i].isKind(of: FSPublishDynamicVC.self) == true {
                            
                            let vc = navigationController?.viewControllers[i] as! FSPublishDynamicVC
                            vc.selectImgs = self.pickerController.selectedAssets
                            vc.isVideo = isVideo
                            vc.setImgData()
                            _ = navigationController?.popToViewController(vc, animated: true)
                            
                            break
                        }
                    }
                }
            }else{
                if isWorkCollection || isUserHeader {
                    for i in 0..<(navigationController?.viewControllers.count)!{
                        
                        if isWorkCollection { // 作品集
                            if navigationController?.viewControllers[i].isKind(of: FSWorkCollectionVC.self) == true {
                                
                                let vc = navigationController?.viewControllers[i] as! FSWorkCollectionVC
                                vc.selectImgs = self.pickerController.selectedAssets
                                vc.setImgData()
                                _ = navigationController?.popToViewController(vc, animated: true)
                                
                                break
                            }
                        }else if isUserHeader { // 修改用户头像
                            if navigationController?.viewControllers[i].isKind(of: FSMyProfileVC.self) == true {
                                
                                let vc = navigationController?.viewControllers[i] as! FSMyProfileVC
                                vc.selectImgs = self.pickerController.selectedAssets
                                vc.setImgData()
                                _ = navigationController?.popToViewController(vc, animated: true)
                                
                                break
                            }
                        }
                    }
                }else{
                    goEditVC()
                }
            }
        }else{
            if isWorkCollection || isUserHeader {
                if isWorkCollection { // 作品集
                    let vc = FSWorkCollectionVC()
                    vc.selectImgs = self.pickerController.selectedAssets
                    navigationController?.pushViewController(vc, animated: true)
                }else if isUserHeader { // 修改用户头像
                    let vc = FSMyProfileVC()
                    vc.selectImgs = self.pickerController.selectedAssets
                    navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if isVideo {
                    if isWork {
                        let vc = FSPublishWorkVC()
                        vc.selectImgs = self.pickerController.selectedAssets
                        vc.isVideo = isVideo
                        navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = FSPublishDynamicVC()
                        vc.selectImgs = self.pickerController.selectedAssets
                        vc.isVideo = isVideo
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    goEditVC()
                }
            }
            
        }
        
    }
    func goEditVC(){
        let vc = FSEditPhotoVC()
        vc.selectImgs = self.pickerController.selectedAssets
        vc.sourcePathArr = self.photoPathArr
        vc.isBack = self.isBack
        vc.isWork = self.isWork
        navigationController?.pushViewController(vc, animated: true)
    }
}
