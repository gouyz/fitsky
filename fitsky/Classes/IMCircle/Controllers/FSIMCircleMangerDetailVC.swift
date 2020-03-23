//
//  FSIMCircleMangerDetailVC.swift
//  fitsky
//  社圈 管理员详情
//  Created by gouyz on 2020/3/4.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let IMCircleMangerMemberIconCell = "IMCircleMangerMemberIconCell"
private let IMCircleMangerCell = "IMCircleMangerCell"
private let IMCircleMangerSwitchCell = "IMCircleMangerSwitchCell"
private let IMCircleMangerOperatorCell = "IMCircleMangerOperatorCell"

class FSIMCircleMangerDetailVC: GYZWhiteNavBaseVC {
    
    var managerTitles:[String] = ["管理社圈","圈内昵称","*ID账号","*二维码","公告","简介","置顶消息","消息免打扰","查找聊天内容","地址","清空聊天内容","删除并退出"]
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
        
        table.register(FSIMCircleMemberCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerMemberIconCell)
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerCell)
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerSwitchCell)
        table.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: IMCircleMangerOperatorCell)
        
        
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
    /// 管理社圈
    func goManageCircle(){
        let vc = FSManageIMCircleVC()
        vc.dataModel = self.dataModel
        vc.circleId = circleId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 简介
    func goEditIntroduction(){
        let vc = FSEditIntroductionVC()
        vc.circleId = circleId
        vc.contentMaxCount = dataModel == nil ? 10 : (dataModel?.circle_brief_limit)!
        vc.content = dataModel == nil ? "" : (dataModel?.circleModel?.brief)!
        vc.resultBlock = {[unowned self] (name) in
            self.dataModel?.circleModel?.brief = name
        }
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
    /// 公告
    func goNoticeVC(){
        let vc = FSIMCircleNoticeVC()
        vc.circleId = circleId
        vc.contentMaxCount = dataModel == nil ? 120 : (dataModel?.circle_notice_limit)!
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
        RCDIMService.shared().clearHistoryMessage(.ConversationType_GROUP, targetId: circleId, successBlock: {
            MBProgressHUD.showAutoDismissHUD(message: "清除成功")
        }) { (error) in
            GYZLog(error)
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
        var method: String = "Circle/Circle/quit"
        if dataModel?.myCircleMemberModel?.is_group == "1" {
            method = "Circle/Circle/dismiss"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["id":(dataModel?.myCircleMemberModel?.id)!],  success: { (response) in
            
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
    
    /// 消息置顶、免打扰
    @objc func onSwitchViewChange(sender: UISwitch){
        let tag = sender.tag
        let status: String = sender.isOn ? "1" : "0"
        
        if tag == 7 {//消息置顶
            RCIMClient.shared()?.setConversationToTop(.ConversationType_GROUP, targetId: circleId, isTop: sender.isOn)
            requestConversationToTop(status: status)

        }else{//免打扰
            RCIMClient.shared()?.setConversationNotificationStatus(.ConversationType_GROUP, targetId: circleId, isBlocked: sender.isOn, success: { [unowned self](nStatus) in
                
                self.requestConversationNotificationStatus(status: status)
            }, error: { (error) in
                GYZLog(error)
            })
        }
    }
    //消息置顶
    func requestConversationToTop(status: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/editIsTopMessage", parameters: ["is_top_message":status,"id":dataModel?.myCircleMemberModel?.id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataModel?.myCircleMemberModel?.is_top_message = status
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //消息免打扰
    func requestConversationNotificationStatus(status: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
//        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/editIsMessageFree", parameters: ["is_message_free":status,"id":dataModel?.myCircleMemberModel?.id ?? ""],  success: { (response) in
            
//            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataModel?.myCircleMemberModel?.is_message_free = status
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
//            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSIMCircleMangerDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerTitles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerMemberIconCell) as! FSIMCircleMemberCell
            
            cell.dataModels = dataModel?.memberList
            cell.didSelectItemBlock = {[unowned self](index) in
                if index == self.dataModel?.memberList.count {
                    self.goAllMembers()
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 7 || indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerSwitchCell) as! GYZCommonSwitchCell
            
            cell.switchView.tag = indexPath.row
            cell.switchView.addTarget(self, action: #selector(onSwitchViewChange(sender:)), for: .valueChanged)
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            if indexPath.row == 7 {//置顶消息
                cell.switchView.isOn = dataModel?.myCircleMemberModel?.is_top_message == "1"
            }else{
                cell.switchView.isOn = dataModel?.myCircleMemberModel?.is_message_free == "1"
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 11 || indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerOperatorCell) as! GYZLabelCenterCell
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleMangerCell) as! GYZCommonArrowCell
            
            cell.nameLab.text = managerTitles[indexPath.row - 1]
            
            if indexPath.row == 3 || indexPath.row == 10 {
                cell.rightIconView.isHidden = true
            }else{
                cell.rightIconView.isHidden = false
            }
            cell.contentLab.text = ""
            if let model = dataModel {
                if indexPath.row == 2 {
                    cell.contentLab.text = model.myCircleMemberModel?.circle_nick_name
                }else if indexPath.row == 3 {
                    cell.contentLab.text = model.circleModel?.unique_id
                }else if indexPath.row == 10 {
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
        if indexPath.row == 1 { //管理社圈
            goManageCircle()
        }else if indexPath.row == 2 { //昵称
            goEditNickName()
        }else if indexPath.row == 5 { //公告
            goNoticeVC()
        }else if indexPath.row == 4 { //二维码
            goQRCodeVC()
        }else if indexPath.row == 6 { //简介
            goEditIntroduction()
        }else if indexPath.row == 11 { //清空聊天内容
            showCleanRecordMsgAlert()
        }else if indexPath.row == 12 { //退出
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
