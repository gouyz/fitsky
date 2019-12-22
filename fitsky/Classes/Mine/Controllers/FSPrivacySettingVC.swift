//
//  FSPrivacySettingVC.swift
//  fitsky
//  隐私设置
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let privacySettingCell = "privacySettingCell"

class FSPrivacySettingVC: GYZWhiteNavBaseVC {
    
    /// 允许通讯录好友找到我（0-否 1-是）
    var isPrivacyTxl: String = "0"
    /// 附近隐藏我的动态（0-否 1-是）
    var isPrivacyDynamic: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "隐私设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestPrivacySettingInit()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(GYZCommonSwitchCell.classForCoder(), forCellReuseIdentifier: privacySettingCell)
        
        return table
    }()
    
    //初始化
    func requestPrivacySettingInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/privacy", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isPrivacyTxl = response["data"]["formdata"]["is_privacy_1"].stringValue
                weakSelf?.isPrivacyDynamic = response["data"]["formdata"]["is_privacy_2"].stringValue
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 状态
    @objc func onSwitchViewChange(sender: UISwitch){
        let tag = sender.tag
        let status: String = sender.isOn ? "1" : "0"
        if tag == 0 {// 允许通讯录的好友找到我
            requestPrivacyTxl(status: status)
        }else{//附近隐藏我的动态
            requestPrivacyDynamic(status: status)
        }
    }
    /// 允许通讯录的好友找到我
    func requestPrivacyTxl(status: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Member/privacy1", parameters: ["is_privacy_1":status],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 附近隐藏我的动态
    func requestPrivacyDynamic(status: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Member/privacy2", parameters: ["is_privacy_2":status],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSPrivacySettingVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: privacySettingCell) as! GYZCommonSwitchCell
        
        cell.switchView.tag = indexPath.row
        cell.switchView.addTarget(self, action: #selector(onSwitchViewChange(sender:)), for: .valueChanged)
        if indexPath.row == 0 {
            cell.nameLab.text = "允许通讯录的好友找到我"
            cell.switchView.isOn = isPrivacyTxl == "1"
        }else{
            cell.nameLab.text = "附近隐藏我的动态"
            cell.switchView.isOn = isPrivacyDynamic == "1"
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
        
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}


