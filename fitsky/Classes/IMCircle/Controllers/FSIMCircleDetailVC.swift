//
//  FSIMCircleDetailVC.swift
//  fitsky
//  社圈 详情
//  Created by gouyz on 2020/3/23.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let IMCircleMemberIconCell = "IMCircleMemberIconCell"
private let IMCircleDetailCell = "IMCircleDetailCell"
private let IMCircleDetailSwitchCell = "IMCircleDetailSwitchCell"
private let IMCircleDetailOperatorCell = "IMCircleDetailOperatorCell"

class FSIMCircleDetailVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    var managerTitles:[String] = ["圈内昵称","*ID账号","*二维码","置顶消息","消息免打扰","地址","清空聊天内容","删除并退出"]
    var circleId: String = ""
    
    var dataModel: FSIMCircleDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "社圈"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestCircleData()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSIMCircleMemberCell.classForCoder(), forCellReuseIdentifier: IMCircleMemberIconCell)
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: IMCircleDetailCell)
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: IMCircleDetailSwitchCell)
        table.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: IMCircleDetailOperatorCell)
        
        
        return table
    }()
    ///获取社圈数据
    func requestCircleData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中")
        
        GYZNetWork.requestNetwork("Circle/Circle/info",parameters: ["id":circleId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSIMCircleDetailModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    /// 全部成员
    func goAllMembers(){
        let vc = FSIMCircleAllMemberVC()
        vc.circleId = circleId
        vc.isAdmin = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 昵称
    func goEditNickName(){
        let vc = FSEditIMCircleNameVC()
        vc.circleId = circleId
        vc.contentMaxCount = dataModel == nil ? 10 : (dataModel?.circle_nick_name_limit)!
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.myCircleMemberModel?.circle_nick_name = name
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 二维码
    func goQRCodeVC(){
        let vc = FSIMCircleQrcodeVC()
        vc.qrcode = dataModel?.circleModel?.qrcode ?? ""
        vc.circleName = dataModel?.circleModel?.name ?? ""
        vc.headerImgUrl = dataModel?.circleModel?.thumb ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    ///清空聊天内容
    func showCleanRecordMsgAlert(){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认清空聊天内容吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { [unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestCleanRecord()
            }
        }
    }
    ///清空聊天内容
    func requestCleanRecord(){
        let isClear: Bool = (RCIMClient.shared()?.clearMessages(.ConversationType_GROUP, targetId: circleId))!
        if isClear {
            if self.resultBlock != nil {
                self.resultBlock!()
            }
            MBProgressHUD.showAutoDismissHUD(message: "清除成功")
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "清除失败")
        }
    }
    /// 退出社圈
    func showLoginOutAlert(){
        if dataModel == nil {
            return
        }
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认删除并退出吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { [unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestLoginOutData()
            }
        }
    }
    ///删除并退出
    func requestLoginOutData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中")
        
        GYZNetWork.requestNetwork("Circle/Circle/quit",parameters: ["id":(dataModel?.myCircleMemberModel?.id)!],  success: { (response) in
            
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
}
extension FSIMCircleDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerTitles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMemberIconCell) as! FSIMCircleMemberCell
            
            cell.dataModels = dataModel?.memberList
            cell.didSelectItemBlock = {[unowned self](index) in
                if index == self.dataModel?.memberList.count {
                    self.goAllMembers()
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 4 || indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleDetailSwitchCell) as! GYZCommonSwitchCell
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 7 || indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleDetailOperatorCell) as! GYZLabelCenterCell
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleDetailCell) as! GYZCommonArrowCell
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            if indexPath.row == 2 || indexPath.row == 6 {
                cell.rightIconView.isHidden = true
            }else{
                cell.rightIconView.isHidden = false
            }
            cell.contentLab.text = ""
            if let model = dataModel {
                if indexPath.row == 1 {
                    cell.contentLab.text = model.myCircleMemberModel?.circle_nick_name
                }else if indexPath.row == 2 {
                    cell.contentLab.text = model.circleModel?.unique_id
                }else if indexPath.row == 6 {
                    cell.contentLab.text = (model.circleModel?.province)! + (model.circleModel?.city)!
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { //昵称
            goEditNickName()
        }else if indexPath.row == 3 { //二维码
            goQRCodeVC()
        }else if indexPath.row == 7 { //清空聊天内容
            showCleanRecordMsgAlert()
        }else if indexPath.row == 8 { //退出
            showLoginOutAlert()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let model = dataModel {
                if model.memberList.count > 4 {
                    return 130
                }
                return 65
            }
            return 0.00001
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
