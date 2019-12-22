//
//  FSMyProfileVC.swift
//  fitsky
//  编辑资料
//  Created by gouyz on 2019/10/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

private let myProfileCell = "myProfileCell"

class FSMyProfileVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isModify: Bool) -> Void)?
    
    let titleArr: [String] = ["更换头像","昵称","*ID","性别","生日","所在城市","个人简介","邮箱"]
    
    var selectSexIndex: Int = 0
    let sexNameArr:[String] = ["女","男","保密"]
    var dataModel: FSMyProfileModel?
    
    var isModify: Bool = false
    /// 选择的图片
    var selectImgs: [DKAsset] = [DKAsset]()
    /// 最大选择图片数量
    var maxImgCount: Int = 1
    var selectImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "编辑资料"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestMineProfileInfo()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        table.backgroundColor = kWhiteColor
        
        
        table.register(GYZMyProfileCell.classForCoder(), forCellReuseIdentifier: myProfileCell)
        
        return table
    }()
    
    override func clickedBackBtn() {
        if resultBlock != nil {
            resultBlock!(isModify)
        }
        super.clickedBackBtn()
    }
    
    //我的 资料
    func requestMineProfileInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/info", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMyProfileModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 修改昵称
    func goModifyNickname(){
        let vc = FSModifyNickNameVC()
        if dataModel != nil {
            vc.nickName = (dataModel?.infoData?.nick_name)!
            vc.contentMaxCount = (dataModel?.nick_name_limit)!
        }
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.infoData?.nick_name = name
            self.isModify = true
            self.tableView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改邮箱
    func goModifyEmail(){
        let vc = FSModifyEmailVC()
        if dataModel != nil {
            vc.email = (dataModel?.infoData?.email)!
        }
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.infoData?.email = name
            self.isModify = true
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 个人简介
    func goModifyIntroduction(){
        let vc = FSModifyIntroductionVC()
        if dataModel != nil {
            vc.content = (dataModel?.infoData?.brief)!
            vc.contentMaxCount = (dataModel?.brief_limit)!
        }
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.infoData?.brief = name
            self.isModify = true
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 选择性别
    func showSelectSex(){
        if dataModel == nil  {
            return
        }
        UsefulPickerView.showSingleColPicker("选择性别", data: sexNameArr, defaultSelectedIndex: selectSexIndex) {[unowned self] (index, value) in
            
            self.selectSexIndex = index
            self.requestModifySex()
        }
    }
    //修改性别
    func requestModifySex(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/sex", parameters: ["sex":selectSexIndex],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                var sexTxt: String = "保密"
                if weakSelf?.selectSexIndex == 0 {
                    sexTxt = "女"
                }else if weakSelf?.selectSexIndex == 1 {
                    sexTxt = "男"
                }
                weakSelf?.dataModel?.infoData?.sex_text = sexTxt
                weakSelf?.dataModel?.infoData?.sex = "\((weakSelf?.selectSexIndex)!)"
                
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 选择生日
    func showSelectBirthday(){
        if dataModel == nil  {
            return
        }
        UsefulPickerView.showDatePicker("选择生日") { [unowned self](date) in
            
            self.requestModifyBirthdy(birthDay: date.dateToStringWithFormat(format: "yyyy-MM-dd"))
        }
    }
    //修改生日
    func requestModifyBirthdy(birthDay: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/birthday", parameters: ["birthday":birthDay],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.isModify = true
                weakSelf?.dataModel?.infoData?.birthday = birthDay
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 选择所在城市
    func showSelectCity(){
        UsefulPickerView.showCitiesPicker("选择所在城市", defaultSelectedValues: ["江苏", "常州", "天宁区"]) {[unowned self] (selectedIndexs, selectedValues) in
            // 处理数据
            //            let combinedString = selectedValues.reduce("", { (result, value) -> String in
            //                result + " " + value
            //            })
            //            GYZLog(combinedString)
            
            self.requestModifyCity(province: selectedValues[0], city: selectedValues[1])
        }
    }
    //修改城市
    func requestModifyCity(province: String,city: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/city", parameters: ["province":province,"city":city],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                //                weakSelf?.isModify = true
                weakSelf?.dataModel?.infoData?.province = province
                weakSelf?.dataModel?.infoData?.city = city
                weakSelf?.tableView.reloadData()
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
        vc.isUserHeader = true
        vc.maxImgCount = maxImgCount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改头像
    func goModifyHeader(){
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
    func setImgData(){
        for item in selectImgs{
            item.fetchFullScreenImage {[unowned self] (image, info) in
                self.selectImg = image
                self.uploadImgFiles()
            }
        }
    }
    
    /// 上传头像
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
        imgParam.fileName = "avatar0.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImage.jpegData(self.selectImg!)(compressionQuality: 0.5)!
        
        imgsParam.append(imgParam)
        
        GYZNetWork.uploadImageRequest("Member/Member/avatar", parameters: nil, uploadParam: imgsParam, success: { (response) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.isModify = true
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension FSMyProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myProfileCell) as! GYZMyProfileCell
        
        cell.userImgView.isHidden = true
        cell.rightIconView.isHidden = false
        cell.nameLab.text = titleArr[indexPath.row]
        cell.desLab.textAlignment = .left
        cell.desLab.font = UIFont.boldSystemFont(ofSize: 14)
        cell.desLab.snp.updateConstraints { (make) in
            make.width.equalTo(kScreenWidth * 0.6)
        }
        
        if let model = dataModel {
            if indexPath.row == 0 {
                cell.userImgView.isHidden = false
                if selectImg != nil {
                    cell.userImgView.image = selectImg
                }else if model.infoData?.avatar?.count > 0 {
                    cell.userImgView.kf.setImage(with: URL.init(string: (model.infoData?.avatar)!)!, placeholder: UIImage.init(named: "app_img_avatar_def"))
                }
            }else if indexPath.row == 1{
                cell.desLab.text = model.infoData?.nick_name
            }else if indexPath.row == 2{
                cell.rightIconView.isHidden = true
                cell.desLab.text = model.infoData?.unique_id
            }else if indexPath.row == 3{
                cell.desLab.text = model.infoData?.sex_text
            }else if indexPath.row == 4{
                cell.desLab.text = model.infoData?.birthday
            }else if indexPath.row == 5{
                cell.desLab.text = (model.infoData?.province)! + (model.infoData?.city)!
            }else if indexPath.row == 6{
                cell.desLab.text = model.infoData?.brief
            }else if indexPath.row == 7{
                cell.desLab.text = model.infoData?.email
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {// 修改昵称
            goModifyNickname()
        }else if indexPath.row == 3 {// 选择性别
            showSelectSex()
        }else if indexPath.row == 4 {// 选择生日
            showSelectBirthday()
        }else if indexPath.row == 5 {// 选择城市
            showSelectCity()
        }else if indexPath.row == 6 {// 个人简介
            goModifyIntroduction()
        }else if indexPath.row == 7 {// 邮箱
            goModifyEmail()
        }else if indexPath.row == 0 {// 头像
            goModifyHeader()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
}
extension FSMyProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [unowned self] in
            self.selectImg = image
            self.uploadImgFiles()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
}
