//
//  FSModifyConfirmVC.swift
//  fitsky
//  修改认证
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSModifyConfirmVC: GYZWhiteNavBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改认证"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(nameView)
        view.addSubview(desLab)
        view.addSubview(desLab1)
        view.addSubview(desLab2)
        
        nameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(kMargin)
            make.top.equalTo(nameView.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab)
            make.top.equalTo(desLab1.snp.bottom).offset(kMargin)
        }
    }
    
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "修改认证", placeHolder: "")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.isEnabled = false
        
        return nView
    }()
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "1.官方会在7个工作日内进行审核"
        
        return lab
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "2.用户仅一次修改认证的次数"
        
        return lab
    }()
    ///
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "3.申请用户应确认提交资料无虚假情况"
        
        return lab
    }()
    
    /// 提交
    @objc func onClickRightBtn(){
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定要修改认证吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") {[unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestCheckDarenEdit()
            }
        }
    }
    ///
    func requestCheckDarenEdit(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Setting/checkDarenEdit", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goDaRenConfirm()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 达人认证
    func goDaRenConfirm(){
        let vc = FSDaRenConfirmVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
