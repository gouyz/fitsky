//
//  FSVenueUpdateVC.swift
//  fitsky
//  场馆升级
//  Created by gouyz on 2019/10/31.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSVenueUpdateVC: GYZWhiteNavBaseVC {
    
    let ruleContent: String = "阅读并确定《升级须知》"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "场馆升级"
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
        
        ruleLab.yb_addAttributeTapAction(with: ["《升级须知》"]) {[unowned self] (label, string, range, index) in
            if index == 0{//《升级须知》
                self.goWebVC(method: "News/Home/userAgreement")
            }
        }
    }
    
    func setUpUI(){
        
        view.addSubview(nameView)
        view.addSubview(lineView)
        view.addSubview(phoneView)
        view.addSubview(lineView1)
        view.addSubview(emailView)
        view.addSubview(lineView2)
        view.addSubview(checkImgView)
        view.addSubview(ruleLab)
        view.addSubview(operatorBtn)
        
        nameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneView.snp.bottom)
        }
        emailView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(emailView.snp.bottom)
        }
        checkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(ruleLab)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        ruleLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkImgView.snp.right).offset(kMargin)
            make.top.equalTo(lineView2.snp.bottom).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        
        operatorBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(ruleLab.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "运营者姓名", placeHolder: "请输入姓名")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var phoneView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "运营者手机号", placeHolder: "请输入手机号")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var emailView: GYZLabAndFieldView = {
        
        let nView = GYZLabAndFieldView.init(desName: "发票电子邮箱", placeHolder: "请输入接收发票的电子邮箱")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var checkImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_radio_no"))
        imgView.highlightedImage = UIImage.init(named: "app_icon_radio_yes")
        imgView.addOnClickListener(target: self, action: #selector(clickedCheckRule))
        
        return imgView
    }()
    lazy var ruleLab: UILabel = {
        let lab = UILabel()
        let attStr = NSMutableAttributedString.init(string: ruleContent)
        attStr.addAttribute(NSAttributedString.Key.font, value: k15Font, range: NSMakeRange(0, ruleContent.count))
       attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kBlueFontColor, range: NSMakeRange(0, ruleContent.count))
        attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kBlackFontColor, range: NSMakeRange(0, 5))
        
        lab.attributedText = attStr
        /// 点击效果，关闭
        lab.enabledTapEffect = false
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 确认升级
    lazy var operatorBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.backgroundColor = kOrangeFontColor
        btn.setTitle("确认升级", for: .normal)
        btn.cornerRadius = 25
        btn.addTarget(self, action: #selector(onClickOkBtn), for: .touchUpInside)
        return btn
    }()
    /// 确认升级
    @objc func onClickOkBtn(){
        if !checkImgView.isHighlighted {
            MBProgressHUD.showAutoDismissHUD(message: "请先同意升级须知")
            return
        }
        if nameView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return
        }
        if phoneView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !(phoneView.textFiled.text?.isMobileNumber())!{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        
        if emailView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入邮箱")
            return
        }else if !emailView.textFiled.text!.isValidateEmail(){
            MBProgressHUD.showAutoDismissHUD(message: "邮箱格式不正确")
            return
        }
        
        requestVenueUpdate()
        
    }
    /// 同意协议按钮
    @objc func clickedCheckRule(){
        checkImgView.isHighlighted = !checkImgView.isHighlighted
    }
    
    /// webView
    func goWebVC(method: String){
        let vc = JSMWebViewVC()
        vc.method = method
        navigationController?.pushViewController(vc, animated: true)
    }
    //场馆升级
    func requestVenueUpdate(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/Store/upgrade", parameters: ["operate_real_name":nameView.textFiled.text!,"operate_mobile":phoneView.textFiled.text!,"operate_email":emailView.textFiled.text!],  success: { (response) in
            
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
