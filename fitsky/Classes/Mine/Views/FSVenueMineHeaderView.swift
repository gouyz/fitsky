//
//  FSVenueMineHeaderView.swift
//  fitsky
//  场馆主页 header
//  Created by gouyz on 2019/10/31.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSVenueMineHeaderView: UIView {
    
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    /// 填充数据
    var dataModel : FSMineInfoModel?{
        didSet{
            if let model = dataModel {
                
                if let userInfo = model.infoData {
                    userImgView.kf.setImage(with: URL.init(string: userInfo.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    nameLab.text = userInfo.nick_name
                    uIdLab.text = "ID：\(userInfo.unique_id!)"
                    
                    /// 会员类型（1-普通 2-达人 3-场馆）
                    vipImgView.isHidden = false
                    if userInfo.type == "2"{
                        vipImgView.image = UIImage.init(named: "app_icon_daren")
                    }else if userInfo.type == "3"{
                        vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                    }else{
                        vipImgView.isHidden = true
                    }
                }
                
                followView.contentLab.text = model.countData?.follow
                fenSiView.contentLab.text = model.countData?.fans
                msgView.contentLab.text = model.countData?.message
                favouriteView.contentLab.text = model.countData?.collect
                
                if model.countData?.is_news_fans == "1" {
                    fenSiView.desLab.showBadge(animated: false)
                }else{
                    fenSiView.desLab.clearBadge(animated: false)
                }
                if Int.init((model.countData?.message)!) > 0 {
                    msgView.desLab.showBadge(animated: false)
                }else{
                    msgView.desLab.clearBadge(animated: false)
                }
                
            }
        }
    }
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(userBgView)
        userBgView.addSubview(userImgView)
        userBgView.addSubview(vipImgView)
        userBgView.addSubview(nameLab)
        userBgView.addSubview(uIdLab)
        userBgView.addSubview(rightIconView)
        
        addSubview(followBgView)
        followBgView.addSubview(followView)
        followBgView.addSubview(lineView)
        followBgView.addSubview(fenSiView)
        followBgView.addSubview(lineView1)
        followBgView.addSubview(msgView)
        followBgView.addSubview(lineView2)
        followBgView.addSubview(favouriteView)
        
        addSubview(funcBgView)
        funcBgView.addSubview(serviceView)
        funcBgView.addSubview(coachView)
        funcBgView.addSubview(circleView)
        funcBgView.addSubview(tradeView)
        addSubview(lineView3)
        
        
        userBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(kMargin)
            make.height.equalTo(80)
        }
        userImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(userBgView)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.top.equalTo(userImgView).offset(5)
            make.height.equalTo(30)
        }
        uIdLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.bottom.equalTo(userImgView).offset(-kMargin)
            make.height.equalTo(20)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 8, height: 16))
        }
        followBgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.top.equalTo(userBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(70)
        }
        followView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(followBgView)
            make.width.equalTo(fenSiView)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.left.equalTo(followView.snp.right)
            make.width.equalTo(klineWidth)
        }
        fenSiView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(msgView)
            make.left.equalTo(lineView.snp.right)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineView)
            make.left.equalTo(fenSiView.snp.right)
        }
        msgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(favouriteView)
            make.left.equalTo(lineView1.snp.right)
        }
        lineView2.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(lineView)
            make.left.equalTo(msgView.snp.right)
        }
        favouriteView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(followView)
            make.width.equalTo(followView)
            make.left.equalTo(lineView2.snp.right)
            make.right.equalTo(followBgView)
        }
        
        funcBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(followBgView)
            make.top.equalTo(followBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(80)
        }
        serviceView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(funcBgView)
            make.width.equalTo(coachView)
        }
        coachView.snp.makeConstraints { (make) in
            make.left.equalTo(serviceView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(serviceView)
            make.width.equalTo(circleView)
        }
        circleView.snp.makeConstraints { (make) in
            make.left.equalTo(coachView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(serviceView)
            make.width.equalTo(tradeView)
        }
        tradeView.snp.makeConstraints { (make) in
            make.left.equalTo(circleView.snp.right).offset(kMargin)
            make.top.bottom.width.equalTo(serviceView)
            make.right.equalTo(funcBgView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(klineWidth)
        }
    }
    lazy var userBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.tag = 110
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k18Font
        lab.text = "悦动健身馆"
        
        return lab
    }()
    /// 用户id
    lazy var uIdLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "ID:12345678"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_big_right"))
    
    lazy var followBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        view.layer.shadowColor = kGrayLineColor.cgColor
        view.borderColor = kWhiteColor
        view.borderWidth = klineWidth
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        
        return view
    }()
    /// 关注
    lazy var followView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "关注"
        view.contentLab.text = "1"
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 粉丝
    lazy var fenSiView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "粉丝"
        view.contentLab.text = "1200"
        view.desLab.badgeView.style = .normal
        view.desLab.badgeView.size = CGSize.init(width: 3, height: 3)
        view.desLab.showBadge(animated: false)
        //        view.desLab.clearBadge(animated: false)
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 消息
    lazy var msgView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "消息"
        view.contentLab.text = "100"
        view.desLab.badgeView.style = .normal
        view.desLab.badgeView.size = CGSize.init(width: 3, height: 3)
        view.desLab.showBadge(animated: false)
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 收藏
    lazy var favouriteView : FSLabAndLabBtnView = {
        let view = FSLabAndLabBtnView()
        view.desLab.text = "收藏"
        view.contentLab.text = "10"
        
        view.tag = 104
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    
    lazy var funcBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        //        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        //        view.layer.shadowOpacity = 0.8
        //        view.layer.shadowRadius = 4
        //        view.layer.shadowColor = kGrayLineColor.cgColor
        //        view.borderColor = kWhiteColor
        //        view.borderWidth = klineWidth
        //        // true的情况不出阴影效果
        //        view.layer.masksToBounds = false
        
        return view
    }()
    /// 服务
    lazy var serviceView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_serve", title: "服务")
        view.tag = 106
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 教练
    lazy var coachView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_user_coach", title: "教练")
        view.tag = 107
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 社圈
    lazy var circleView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_venue_circle", title: "社圈")
        view.tag = 108
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 交易
    lazy var tradeView: GYZFuncModelView = {
        let view = GYZFuncModelView.init(frame: CGRect.zero, iconName: "app_btn_venue_trade", title: "交易")
        view.tag = 109
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 分割线
    var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    @objc func onClickedOperator(sender:UITapGestureRecognizer){
        if didSelectItemBlock != nil {
            didSelectItemBlock!((sender.view?.tag)!)
        }
    }
}
