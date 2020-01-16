//
//  FSHelpVSAboutVC.swift
//  fitsky
//  帮助与关于
//  Created by gouyz on 2019/10/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import StoreKit

private let helpVSAboutCell = "helpVSAboutCell"

class FSHelpVSAboutVC: GYZWhiteNavBaseVC {
    
    let titleArr:[String] = ["去App Store评分","合作洽谈","反馈","客服热线","协议与条款"]
    /// 合作洽谈 email
    var email: String = ""
    /// 合作洽谈合作须知
    var notice: String = ""
    /// 客服热线
    var tel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "帮助与关于"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        
        requestCooperateInit()
        requestTelInit()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(GYZCommonArrowCell.classForCoder(), forCellReuseIdentifier: helpVSAboutCell)
        
        return table
    }()
    lazy var headerView: FSAboutHeaderView = FSAboutHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200))
    
    /// 显示合作
    func showCooperateAlert(){
        let alertView = FSCustomCooperateAlertView()
        alertView.emailLab.text = email
        alertView.contentLab.text = notice
        alertView.show()
    }
    /// 反馈
    func goFeedBack(){
        let vc = FSFeedBackVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 联系客服
    func showCustomerAlert(){
        let alertView = FSLinkCustomerAlertView()
        let phone: String = "客服热线：\(tel)"
        let phoneAttr : NSMutableAttributedString = NSMutableAttributedString(string: phone)
        phoneAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: kGaryFontColor, range: NSMakeRange(0, 5))
        alertView.contentLab.attributedText = phoneAttr
        alertView.show()
    }
    
    /// webView
    func goWebVC(method: String){
        let vc = JSMWebViewVC()
        vc.method = method
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //合作洽谈 初始化
    func requestCooperateInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("News/Home/cooperationNegotiation", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.email = response["data"]["email"].stringValue
                weakSelf?.notice = response["data"]["notice"].stringValue
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //客服热线 初始化
    func requestTelInit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("News/Home/serviceHotline", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.tel = response["data"]["tel"].stringValue
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func lg_iTunesScoreComment() {
        if #available(iOS 10.3 , *) {
            SKStoreReviewController.requestReview()
        } else {
            let openStr:String = "itms-apps://itunes.apple.com/app/id\(APPID)?action=write-review"
            if UIApplication.shared.canOpenURL(URL(string: openStr)!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: openStr)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.canOpenURL(URL(string: openStr)!)
                }
            } else {
                GYZUpdateVersionTool.goAppStore()
            }
        }
    }
}
extension FSHelpVSAboutVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: helpVSAboutCell) as! GYZCommonArrowCell
        
        cell.nameLab.text = titleArr[indexPath.row]
        cell.nameLab.textColor = kGaryFontColor
        
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
        switch indexPath.row {
        case 0://去App Store评分
            lg_iTunesScoreComment()
        case 1://合作洽谈
            showCooperateAlert()
        case 2:/// 反馈
            goFeedBack()
        case 3:// 联系客服
            showCustomerAlert()
        case 4:
            goWebVC(method: "News/Home/agreementItem")
            
        default:
            break
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
