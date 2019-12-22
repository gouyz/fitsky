//
//  FSPayOrderResultVC.swift
//  fitsky
//  收银台 支付结果
//  Created by gouyz on 2019/9/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSPayOrderResultVC: GYZWhiteNavBaseVC {
    
    /// 订单编号
    var orderSn: String = ""
    // 订单model
    var orderModel: FSOrderModel?
    /// 客服电话
    var kefuPhone:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "收银台"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_link_kefu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedLinkKeFuBtn))
        
        setUpUI()
        failedImgView.isHidden = true
        
        requestOrderInfo()
    }
    func setUpUI(){
        view.addSubview(topImgView)
        topImgView.addSubview(tagImgView)
        topImgView.addSubview(desLab)
        topImgView.addSubview(moneyLab)
        
        topImgView.addSubview(orderNoLab)
        topImgView.addSubview(payTimeLab)
        topImgView.addSubview(payTypeLab)
        
        topImgView.addSubview(failedImgView)

        view.addSubview(backHomeBtn)
        
        topImgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(kScreenWidth * 0.84)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.top.equalTo(kTitleHeight)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(20)
            make.right.equalTo(-kMargin)
            make.top.equalTo(tagImgView)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(moneyLab)
            make.top.equalTo(moneyLab.snp.bottom).offset(5)
            make.bottom.equalTo(tagImgView)
        }
        orderNoLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(payTimeLab)
            make.bottom.equalTo(payTimeLab.snp.top).offset(-kMargin)
        }
        payTimeLab.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-30)
            make.centerY.equalTo(kScreenWidth * 0.63)
            make.height.equalTo(20)
        }
        payTypeLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(payTimeLab)
            make.top.equalTo(payTimeLab.snp.bottom).offset(kMargin)
        }
        
        failedImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(payTimeLab)
            make.centerX.equalTo(topImgView)
            make.size.equalTo(CGSize.init(width: 41, height: 43))
        }
        backHomeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(-30)
        }
    }
    lazy var topImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_img_pay"))
    
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_pay_msg_success"))
    
    /// 订单金额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.systemFont(ofSize: 20)
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.text = "支付成功，感谢购买！"
        
        return lab
    }()
    /// 订单编号
    lazy var orderNoLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "订单编号："
        
        return lab
    }()
    /// 支付时间
    lazy var payTimeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "支付时间："
        
        return lab
    }()
    /// 支付方式
    lazy var payTypeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "支付方式："
        
        return lab
    }()
    // 支付失败
    lazy var failedImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_msg_order_no"))
    
    /// 返回首页
    lazy var backHomeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("返回首页", for: .normal)
        btn.titleLabel?.font = k18Font
        btn.backgroundColor = kBlueFontColor
        btn.cornerRadius = 30
        
        btn.addTarget(self, action: #selector(clickedBackHomeBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 联系客服
    @objc func clickedLinkKeFuBtn(){
        if !kefuPhone.isEmpty{
            GYZTool.callPhone(phone: kefuPhone)
        }
    }
    
    ///获取订单信息
    func requestOrderInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/Order/info", parameters: ["order_sn":orderSn],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["order"].dictionaryObject else { return }
                weakSelf?.orderModel = FSOrderModel.init(dict: data)
                
                weakSelf?.dealData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealData(){
        if let model = orderModel {
            moneyLab.text = "￥" + String(format: "%.2f", Float((model.order_payed)!)!)
            if model.pay_status == "1"{// 已支付
                tagImgView.image = UIImage.init(named: "app_icon_pay_msg_success")
                desLab.text = "支付成功，感谢购买！"
                failedImgView.isHidden = true
                orderNoLab.isHidden = false
                payTimeLab.isHidden = false
                payTypeLab.isHidden = false
                
                orderNoLab.text = "订单编号：" + model.order_sn!
                payTypeLab.text = "支付时间：" + model.pay_time!
                payTimeLab.text = "支付方式：" + model.pay_name!
                
            }else{
                tagImgView.image = UIImage.init(named: "app_icon_pay_msg_def")
                desLab.text = "支付失败，请重新购买！"
                failedImgView.isHidden = false
                orderNoLab.isHidden = true
                payTimeLab.isHidden = true
                payTypeLab.isHidden = true
            }
        }
    }
    override func clickedBackBtn() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    /// 返回首页
    @objc func clickedBackHomeBtn(){
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
