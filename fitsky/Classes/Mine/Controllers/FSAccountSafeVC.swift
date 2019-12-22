//
//  FSAccountSafeVC.swift
//  fitsky
//  账号安全
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let accountSafeCell = "accountSafeCell"

class FSAccountSafeVC: GYZWhiteNavBaseVC {
    
    let titleArr:[[String]] = [["手机号","登录密码"],["QQ账号","微信账号","微博账号"]]
    
    var dataModel: FSAccountSafeInitModel?
    var isRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "账号安全"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestAccountInit()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(FSAccountSafeCell.classForCoder(), forCellReuseIdentifier: accountSafeCell)
        
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isRefresh {
            requestAccountInit()
        }
    }
    
    //账号安全-初始化
    func requestAccountInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Setting/safeInit", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                weakSelf?.dataModel = FSAccountSafeInitModel.init(dict: data)
                weakSelf?.tableView.reloadData()
            
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 更换手机号
    func goChangePhone(){
        let vc = FSChangePhoneFirstVC()
        vc.mobile = (dataModel?.mobile)!
        vc.mobileTxt = (dataModel?.mobile_text)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 设置密码
    func goSettingPwd(){
        let vc = FSSettingPwdVC()
        vc.resultBlock = {[unowned self] () in
            self.dataModel?.is_password = "1"
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 更改密码
    func goChangePwd(){
        let vc = FSChangePwdVC()
        vc.mobile = (self.dataModel?.mobile)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension FSAccountSafeVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: accountSafeCell) as! FSAccountSafeCell
        
        cell.titleLab.text = titleArr[indexPath.section][indexPath.row]
        cell.contentLab.text = ""
        cell.desLab.text = "未设置"
        cell.desLab.textColor = kHeightGaryFontColor
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if let model = dataModel {
                    cell.contentLab.text = model.mobile_text
                }
                cell.desLab.text = "更换手机号"
                cell.desLab.textColor = kBlueFontColor
            }else if indexPath.row == 1 {
                if let model = dataModel {
                    if  model.is_password == "1" {
                        cell.desLab.text = "修改密码"
                        cell.desLab.textColor = kBlueFontColor
                    }
                }
            }
        }else{
            if let model = dataModel {
                if indexPath.row == 0 {
                    cell.desLab.text = model.is_qq == "1" ? "已设置" : "未设置"
                }else if indexPath.row == 1 {
                    cell.desLab.text = model.is_wx == "1" ? "已设置" : "未设置"
                }else if indexPath.row == 2 {
                    cell.desLab.text = model.is_weibo == "1" ? "已设置" : "未设置"
                }
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {// 更换手机号
                goChangePhone()
            }else if indexPath.row == 1 {// 设置密码
                if let model = dataModel {
                    if  model.is_password == "1" {
                        goChangePwd()
                    }else{
                        goSettingPwd()
                    }
                }
            }
        }
        
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
