//
//  FSWorkCollectionVC.swift
//  fitsky
//  添加作品集
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

class FSWorkCollectionVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isModify: Bool) -> Void)?
    
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    /// 最大选择图片数量
    var maxImgCount: Int = 1
    var selectImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加作品集"
        self.view.backgroundColor = kWhiteColor
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(lineView)
        view.addSubview(nameView)
        view.addSubview(lineView1)
        view.addSubview(desLab)
        view.addSubview(photoView)
        view.addSubview(lineView2)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(5)
        }
        nameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(50)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineDoubleWidth)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.top.equalTo(lineView1.snp.bottom).offset(20)
        }
        photoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 170, height: 170))
            make.top.equalTo(desLab)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(photoView.snp.bottom).offset(20)
        }
    }
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "作品集名称", placeHolder: "请输入作品集名称")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    
    /// 封面图
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "封面图"
        
        return lab
    }()
    
    lazy var photoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_upload_img"))
        imgView.contentMode = .scaleAspectFill
        /// 超出部分裁剪
        imgView.clipsToBounds = true
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectPhoto))
        return imgView
    }()
    
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    /// 选择照片
    @objc func onClickedSelectPhoto(){
        nameView.textFiled.resignFirstResponder()
        
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
    /// 完成
    @objc func onClickRightBtn(){
        if nameView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入作品集名称")
            return
        }
        if self.selectImg != nil {
            uploadImgFiles()
        }else{
            requestAddWorks(urls: "")
        }
    }
    func setImgData(){
        for item in selectImgs{
            item.fetchFullScreenImage {[unowned self] (image, info) in
                self.selectImg = image
                self.photoView.image = image
            }
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
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "files[]"
        imgParam.fileName = "dynamic0.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImage.jpegData(self.selectImg!)(compressionQuality: 0.5)!
        
        imgsParam.append(imgParam)
        
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
                weakSelf?.requestAddWorks(urls: urls)
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///作品集添加
    func requestAddWorks(urls: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        if urls == "" {
            createHUD(message: "加载中...")
        }
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Dynamic/Opus/add", parameters: ["name":nameView.textFiled.text!,"material":urls],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                if weakSelf?.resultBlock != nil {
                    weakSelf?.resultBlock!(true)
                }
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///打开相机
    func openCamera(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        GYZOpenCameraPhotosTool.shareTool.checkCameraPermission { (granted) in
            if granted{
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .camera
                photo.allowsEditing = true
                photo.modalPresentationStyle = .fullScreen
                self.present(photo, animated: true, completion: nil)
            }else{
                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头",controller : self)
            }
        }
        
    }
    
    /// 手机相册
    func goSelectPhotoVC(){
        let vc = FSSelectPhotosVC()
        vc.isBack = true
        vc.isWorkCollection = true
        vc.maxImgCount = maxImgCount
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSWorkCollectionVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [unowned self] in
            self.selectImg = image
            self.photoView.image = image
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
}
