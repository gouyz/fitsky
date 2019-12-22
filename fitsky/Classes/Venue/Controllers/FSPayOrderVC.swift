//
//  FSPayOrderVC.swift
//  fitsky
//  收银台
//  Created by gouyz on 2019/9/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class FSPayOrderVC: GYZWhiteNavBaseVC {
    
    /// 订单编号
    var orderSn: String = ""
    // 订单model
    var orderModel: FSOrderModel?
    /// 支付方式
    var payMentList: [FSPaymentModel] = [FSPaymentModel]()
    /// 支付方式 alipay-支付宝 wxpay-微信支付
    var payment: String = "alipay"
    /// 客服电话
    var kefuPhone:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "收银台"
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_link_kefu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedLinkKeFuBtn))
        
        setUpUI()
        requestOrderInfo()
        
        selectPayView.selectPayTypeBlock = {[unowned self] (isAlipay) in
            self.payment = isAlipay ? "alipay" : "wxpay"
        }
    }
    func setUpUI(){
        view.addSubview(topImgView)
        topImgView.addSubview(orderNoLab)
        topImgView.addSubview(moneyLab)
        view.addSubview(selectPayView)
        view.addSubview(payBtn)
        
        topImgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(kScreenWidth * 0.46)
        }
        orderNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(40)
            make.height.equalTo(30)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(orderNoLab)
            make.top.equalTo(orderNoLab.snp.bottom).offset(kMargin)
        }
        selectPayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(topImgView.snp.bottom).offset(5)
            make.height.equalTo(180)
        }
        
        payBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(-30)
        }
    }
    lazy var topImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_img_cashier"))
    /// 订单编号
    lazy var orderNoLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.textAlignment = .center
        lab.text = "课程订单-"
        
        return lab
    }()
    /// 订单金额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.textAlignment = .center
        
        return lab
    }()
    // 选择支付方式
    lazy var selectPayView: LHSSelectPayMethodView = LHSSelectPayMethodView()
    /// 确认支付
    lazy var payBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确认支付", for: .normal)
        btn.titleLabel?.font = k18Font
        btn.backgroundColor = kOrangeFontColor
        btn.cornerRadius = 30
        
        btn.addTarget(self, action: #selector(clickedPayBtn), for: .touchUpInside)
        
        return btn
    }()
    ///获取订单信息
    func requestOrderInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/Order/checkout", parameters: ["order_sn":orderSn],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["order"].dictionaryObject else { return }
                weakSelf?.orderModel = FSOrderModel.init(dict: data)
                guard let payData = response["data"]["payment"].array else { return }
                for item in payData{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSPaymentModel.init(dict: itemInfo)
                    weakSelf?.payMentList.append(model)
                }
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
            orderNoLab.text = "课程订单-" + model.order_sn!
            moneyLab.text = "￥" + String(format: "%.2f", Float((model.order_payed)!)!)
            payBtn.setTitle(model.pay_btn_text, for: .normal)
        }
    }
    /// 联系客服
    @objc func clickedLinkKeFuBtn(){
        if !kefuPhone.isEmpty{
            GYZTool.callPhone(phone: kefuPhone)
        }
    }
    ///获取支付参数
    func requestPayData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Store/Order/pay", parameters: ["order_sn":orderSn,"payment":payment],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                if weakSelf?.payment == "alipay"{// 支付宝
                    weakSelf?.goAliPay(orderInfo: data["pay_param"].stringValue)
                }else if weakSelf?.payment == "wxpay"{/// 微信支付
                    weakSelf?.goWeChatPay(data: data["wx_pay_param"])
                }
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 微信支付
    func goWeChatPay(data: JSON){
        let req = PayReq()
        req.timeStamp = data["timestamp"].uInt32Value
        req.partnerId = data["partnerid"].stringValue
        req.package = data["package"].stringValue
        req.nonceStr = data["noncestr"].stringValue
        req.sign = data["sign"].stringValue
        req.prepayId = data["prepayid"].stringValue
        
        WXApiManager.shared.payAlertController(self, request: req, paySuccess: { [unowned self]  in
            
            self.goPayResultVC()
        }) { [unowned self]  in
            self.goPayResultVC()
        }
    }
    /// 支付宝支付
    func goAliPay(orderInfo: String){
        
        AliPayManager.shared.requestAliPay(orderInfo, paySuccess: { [unowned self]  in
            
            self.goPayResultVC()
            }, payFail: { [unowned self]  in
                self.goPayResultVC()
        })
    }
    /// 支付
    @objc func clickedPayBtn(){
        requestPayData()
    }
    
    /// 支付结果
    func goPayResultVC(){
        let vc = FSPayOrderResultVC()
        vc.orderSn = self.orderSn
        vc.kefuPhone = kefuPhone
        navigationController?.pushViewController(vc, animated: true)
    }
}
