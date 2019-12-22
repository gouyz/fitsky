//
//  FSMyVenueProfileVC.swift
//  fitsky
//  场馆资料修改
//  Created by gouyz on 2019/10/31.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

private let myVenueProfileCell = "myVenueProfileCell"

class FSMyVenueProfileVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isModify: Bool) -> Void)?
    
    let titleArr: [String] = ["场馆","*ID","场馆规模","建馆时间","所在地区","简介","邮箱"]
    
    var selectSexIndex: Int = 0
    let sexNameArr:[String] = ["保密","男","女"]
    var dataModel: FSMineVenueModel?
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
        
        
        table.register(GYZMyProfileCell.classForCoder(), forCellReuseIdentifier: myVenueProfileCell)
        
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
        
        GYZNetWork.requestNetwork("Admin/Store/info", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSMineVenueModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 修改名称
    func goModifyNickname(){
        let vc = FSModifyNickNameVC()
        if dataModel != nil {
            vc.nickName = (dataModel?.storeData?.store_name)!
            vc.contentMaxCount = (dataModel?.store_name_limit)!
        }
        vc.isVenue = true
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.storeData?.store_name = name
            self.isModify = true
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 显示填写场馆规模
    func showInputData(title: String,placeholder: String,content:String,unit: String){
        let alertView = FSCustomInputBodyDataAlert.init(title: title, placeholder: placeholder,content: content, unit: unit)
        alertView.inputTxtFiled.keyboardType = .decimalPad
        alertView.show()
        alertView.action = {[unowned self] (alert,index) in
            if index == 2 {// 确定
                self.requestModifyVueneProfileInfo(paramDic: ["area":alert.inputTxtFiled.text!])
            }
        }
    }
    //修改场馆信息
    func requestModifyVueneProfileInfo(paramDic : [String : Any]){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/Store/edit", parameters: paramDic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.requestMineProfileInfo()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 修改邮箱
    func goModifyEmail(){
        let vc = FSModifyEmailVC()
        if dataModel != nil {
            vc.email = (dataModel?.storeData?.email)!
        }
        vc.isVenue = true
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.storeData?.email = name
//            self.isModify = true
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 个人简介
    func goModifyIntroduction(){
        let vc = FSModifyIntroductionVC()
        if dataModel != nil {
            vc.content = (dataModel?.storeData?.brief)!
            vc.contentMaxCount = (dataModel?.store_brief_limit)!
        }
        vc.isVenue = true
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.storeData?.brief = name
//            self.isModify = true
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 选择建馆时间
    func showSelectBuliding(){
        UsefulPickerView.showDatePicker("选择建馆时间") { [unowned self](date) in
            self.requestModifyVueneProfileInfo(paramDic: ["building_time":date.dateToStringWithFormat(format: "yyyy-MM-dd")])
        }
    }
    /// 选择所在城市
    func showSelectCity(){
        UsefulPickerView.showCitiesPicker("选择所在城市", defaultSelectedValues: ["江苏", "常州", "天宁区"]) {[unowned self] (selectedIndexs, selectedValues) in
            // 处理数据
            //            let combinedString = selectedValues.reduce("", { (result, value) -> String in
            //                result + " " + value
            //            })
            //            GYZLog(combinedString)
            self.requestModifyVueneProfileInfo(paramDic: ["province":selectedValues[0],"city":selectedValues[1]])
        }
    }
}

extension FSMyVenueProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myVenueProfileCell) as! GYZMyProfileCell
        
        cell.userImgView.isHidden = true
        cell.nameLab.text = titleArr[indexPath.row]
        
        if let model = dataModel {
            if indexPath.row == 0{
                cell.desLab.text = model.storeData?.store_name
            }else if indexPath.row == 1{
                cell.rightIconView.isHidden = true
                cell.desLab.text = model.storeData?.unique_id
            }else if indexPath.row == 2{
                cell.desLab.text = model.storeData?.area_text
            }else if indexPath.row == 3{
                cell.desLab.text = model.storeData?.building_time
            }else if indexPath.row == 4{
                cell.desLab.text = (model.storeData?.province)! + (model.storeData?.city)!
            }else if indexPath.row == 5{
                cell.desLab.text = model.storeData?.brief
            }else if indexPath.row == 6{
                cell.desLab.text = model.storeData?.email
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
        if dataModel == nil  {
            return
        }
        if indexPath.row == 0 {// 修改昵称
            goModifyNickname()
        }else if indexPath.row == 2 {// 场馆规模
            showInputData(title: "场馆规模", placeholder: "请输入场馆规模", content: (dataModel?.storeData?.area)!, unit: "㎡")
        }else if indexPath.row == 3 {// 选择建馆时间
            showSelectBuliding()
        }else if indexPath.row == 4 {// 选择城市
            showSelectCity()
        }else if indexPath.row == 5 {// 个人简介
            goModifyIntroduction()
        }else if indexPath.row == 6 {// 邮箱
            goModifyEmail()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 64
//        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
}
