//
//  FSApplyMikeVC.swift
//  fitsky
//  申请麦克风
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSApplyMikeVC: GYZBaseVC {
    
    var topicId: String = ""
    var topicTitle: String = ""
    /// 活跃度
    var topicActiveCount: Int = 0
    /// 申请麦克风描述
    var applyAdminText: String = ""
    /// 是否可以申请
    var isApplyMike: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        self.navigationItem.title = "申请麦克风"
        
        setUpUI()
        
        if isApplyMike == "1" {
            applyBtn.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0x252c5b)
            applyBtn.isUserInteractionEnabled = true
        }else{
            applyBtn.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xcacaca)
            applyBtn.isUserInteractionEnabled = false
        }
        /// lab加载富文本
//        let desStr = try? NSAttributedString.init(data: applyAdminText.data(using: String.Encoding.unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
//        desLab.attributedText = desStr
        
    }
    func setUpUI(){
        
        view.addSubview(bgImgView)
        bgImgView.addSubview(desLab)
        bgImgView.addSubview(guideLab)
        bgImgView.addSubview(applyBtn)
        bgImgView.addSubview(ruleLab)
        bgImgView.addSubview(workLab)
        
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(kTitleAndStateHeight + 80)
        }
        guideLab.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(desLab.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        applyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImgView)
            make.size.equalTo(CGSize.init(width: 240, height: 50))
            make.bottom.equalTo(ruleLab.snp.top).offset(-kMargin)
        }
        ruleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImgView)
            make.size.equalTo(CGSize.init(width: 240, height: 30))
            make.bottom.equalTo(workLab.snp.top).offset(-30)
        }
        workLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImgView)
            make.bottom.equalTo(kStateHeight > 20.0 ? -54 : -kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
    }
    
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_topic_apply")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kWhiteColor
        lab.numberOfLines = 0
        let attStr = NSMutableAttributedString.init(string: applyAdminText)
        attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeFontColor, range: NSMakeRange(4, topicTitle.count))
        
        lab.attributedText = attStr
        
        return lab
    }()
    ///麦克风指南
    lazy var guideLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .right
        lab.text = "详情请鉴《麦克风指南》"
        lab.tag = 101
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    /// 申请麦克风
    lazy var applyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("申请麦克风", for: .normal)
        btn.titleLabel?.font = k18Font
        btn.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0x252c5b)
        btn.cornerRadius = 10
        
        btn.addTarget(self, action: #selector(clickedApplyBtn), for: .touchUpInside)
        
        return btn
    }()
    ///话题管理规定
    lazy var ruleLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "我已阅读并同意《话题管理规定》"
        lab.tag = 102
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    ///话题合作
    lazy var workLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kOrangeFontColor
        lab.textAlignment = .center
        lab.text = "话题合作"
        lab.tag = 103
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    /// 申请麦克风
    @objc func clickedApplyBtn(){
        requestApplyMike()
    }
    ///申请麦克风
    func requestApplyMike(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/applay", parameters: ["id":topicId],  success: { (response) in
            
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
    ///
    @objc func onClickedOperator(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        var method:String = ""
        if tag == 101 {///麦克风指南
            method = "News/Home/topicMicrophoneGuide"
        }else if tag == 102 {///话题管理规定
            method = "News/Home/topicManagementProvisions"
        }else if tag == 103 {///话题合作
            method = "News/Home/topicCooperation"
        }
        goWebVC(method: method)
    }
    
    /// webView
    func goWebVC(method: String){
        let vc = JSMWebViewVC()
        vc.method = method
        navigationController?.pushViewController(vc, animated: true)
    }
}
