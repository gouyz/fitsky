//
//  FSPrivateChatSettingVC.swift
//  fitsky
//  单聊设置
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let privateChatSettingCell = "privateChatSettingCell"

class FSPrivateChatSettingVC: GYZWhiteNavBaseVC {
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    var targetId: String = ""
    let titleArr: [String] = ["置顶聊天","新消息通知","清除聊天记录"]
    //消息通知状态
    var msgNotificationStatus: Bool = false
    //消息置顶状态
    var msgTopStatus: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "设置"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        getMsgStstus()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: privateChatSettingCell)
        
        return table
    }()
    func getMsgStstus(){
        //获取新消息通知状态
        RCIMClient.shared()?.getConversationNotificationStatus(.ConversationType_PRIVATE, targetId: targetId, success: {[unowned self] (status) in
            if status == .NOTIFY{
                self.msgNotificationStatus = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, error: { (error) in
            
        })
        //获取置顶聊天状态
        let conversation: RCConversation? = (RCIMClient.shared()?.getConversation(.ConversationType_PRIVATE, targetId: targetId))
        if conversation != nil {
            msgTopStatus = conversation!.isTop
            self.tableView.reloadData()
        }
    }
    
    /// 消息置顶、免打扰
    @objc func onSwitchViewChange(sender: UISwitch){
        let tag = sender.tag
//        let status: String = sender.isOn ? "1" : "0"
        
        if tag == 0 {//消息置顶
            let isSuccess: Bool = (RCIMClient.shared()?.setConversationToTop(.ConversationType_PRIVATE, targetId: targetId, isTop: sender.isOn))!

            if isSuccess {
                msgTopStatus = sender.isOn
            }
            tableView.reloadData()
        }else{//免打扰
            RCIMClient.shared()?.setConversationNotificationStatus(.ConversationType_PRIVATE, targetId: targetId, isBlocked: sender.isOn, success: { [unowned self] (nStatus) in
                self.msgNotificationStatus = sender.isOn//nStatus == .NOTIFY
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, error: {[unowned self] (error) in
                GYZLog(error)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    ///清空聊天内容
    func requestCleanRecord(){
        let isClear: Bool = (RCIMClient.shared()?.clearMessages(.ConversationType_PRIVATE, targetId: targetId))!
        if isClear {
            MBProgressHUD.showAutoDismissHUD(message: "清除成功")
            if self.resultBlock != nil {
                self.resultBlock!()
            }
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "清除失败")
        }
    }
}
extension FSPrivateChatSettingVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: privateChatSettingCell) as! GYZCommonSwitchCell
        cell.switchView.tag = indexPath.row
        cell.switchView.addTarget(self, action: #selector(onSwitchViewChange(sender:)), for: .valueChanged)
        
        cell.nameLab.text = titleArr[indexPath.row]
        cell.switchView.isHidden = false
        if indexPath.row == 2 {
            cell.switchView.isHidden = true
        }
        if indexPath.row == 0 {
            cell.switchView.isOn = msgTopStatus
        }else if indexPath.row == 1 {
            cell.switchView.isOn = msgNotificationStatus
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
        if indexPath.row == 2 {//清除聊天记录
            GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认清除聊天记录吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { [unowned self] (tag) in
                
                if tag != cancelIndex{
                    self.requestCleanRecord()
                }
            }
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
