//
//  FSMySettingVC.swift
//  fitsky
//  我的设置
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let settingCell = "settingCell"
private let settingLoginOutFooter = "settingLoginOutFooter"

class FSMySettingVC: GYZWhiteNavBaseVC {
    
    let titleArr:[String] = ["账号与安全","屏蔽名单","隐私设置","清理缓存","修改认证"]
    /// 达人是否可以修改认证（0-否 1-是）
    var is_daren_reapply: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestSettingInit()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(GYZLabArrowCell.classForCoder(), forCellReuseIdentifier: settingCell)
        table.register(FSLoginOutFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: settingLoginOutFooter)
        
        return table
    }()
    
    //初始化
    func requestSettingInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Setting/init", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.is_daren_reapply = response["data"]["formdata"]["is_daren_reapply"].stringValue
            
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 关于我们
    func goAboutVC(){
        //            let vc = JSLAboutVC()
        //            navigationController?.pushViewController(vc, animated: true)
    }
    // 屏蔽名单
    func goPingBiVC(){
        let vc = FSPingBiListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 隐私设置
    func goPrivacyVC(){
        let vc = FSPrivacySettingVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改认证
    func goModifyConfirmVC(){
        let vc = FSModifyConfirmVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 账号安全
    func goAccountSafeVC(){
        let vc = FSAccountSafeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 退出
    @objc func onClickLoginOutBtn(){
        requestLoginOut()
    }
    ///退出登录
    func requestLoginOut(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Login/logout", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                GYZTool.removeUserInfo()
                KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSMySettingVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell) as! GYZLabArrowCell
        
        cell.nameLab.text = titleArr[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: settingLoginOutFooter) as! FSLoginOutFooterView
        
        headerView.loginOutBtn.addTarget(self, action: #selector(onClickLoginOutBtn), for: .touchUpInside)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // 账号安全
            goAccountSafeVC()
        }else if indexPath.row == 1 {// 屏蔽名单
            goPingBiVC()
        }else if indexPath.row == 2 {// 隐私设置
            goPrivacyVC()
        }else if indexPath.row == 4 {// 修改认证
            goModifyConfirmVC()
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
        return 70
    }
}

