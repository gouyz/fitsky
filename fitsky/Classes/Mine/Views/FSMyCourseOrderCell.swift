//
//  FSMyCourseOrderCell.swift
//  fitsky
//  课程订单 cell
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMyCourseOrderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCourseOrderModel?{
        didSet{
            if let model = dataModel {
                
                courseImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_topic_default"))
                venueNameLab.text = model.store_name
                statusNameLab.text = model.status_text
                nameLab.text = model.goods_name
                levelLab.text = model.difficulty_text
                orderNumLab.text = "课程订单：\(model.order_sn!)"
                
                moneyLab.text = "合计金额：￥\(model.order_payed!)"
                if model.write_off_code!.isEmpty {
                    checkNumLab.isHidden = true
                    checkNumLab.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }else{
                    checkNumLab.isHidden = false
                    checkNumLab.snp.updateConstraints { (make) in
                        make.height.equalTo(30)
                    }
                    checkNumLab.text = "核销码   ：\(model.write_off_code!)"
                }
                if model.pay_time!.isEmpty {
                    payTimeLab.isHidden = true
                    payTimeLab.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }else{
                    payTimeLab.isHidden = false
                    payTimeLab.snp.updateConstraints { (make) in
                        make.height.equalTo(30)
                    }
                    payTimeLab.text = "支付时间：\(model.pay_time!)"
                }
                if model.coach_id_text!.isEmpty {
                    teacherLab.isHidden = true
                    teacherLab.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }else{
                    teacherLab.isHidden = false
                    teacherLab.snp.updateConstraints { (make) in
                        make.height.equalTo(30)
                    }
                    teacherLab.text = "指定教练：\(model.coach_id_text!)"
                }
                
                if model.cancel_btn_text!.isEmpty{
                    cancleBtn.isHidden = true
                    cancleBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else{
                    cancleBtn.isHidden = false
                    cancleBtn.setTitle(model.cancel_btn_text, for: .normal)
                    cancleBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }
                if model.feedback_btn_text!.isEmpty{
                    feedBackBtn.isHidden = true
                    feedBackBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else{
                    feedBackBtn.isHidden = false
                    feedBackBtn.setTitle(model.feedback_btn_text, for: .normal)
                    feedBackBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }
                if model.pay_btn_text!.isEmpty{
                    payBtn.isHidden = true
                    payBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else{
                    payBtn.isHidden = false
                    payBtn.setTitle(model.pay_btn_text, for: .normal)
                    payBtn.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(venueNameLab)
        bgView.addSubview(rightIconView)
        bgView.addSubview(statusNameLab)
        bgView.addSubview(courseImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(levelLab)
        bgView.addSubview(orderNumLab)
        bgView.addSubview(checkNumLab)
        bgView.addSubview(payTimeLab)
        bgView.addSubview(teacherLab)
        bgView.addSubview(cancleBtn)
        bgView.addSubview(feedBackBtn)
        bgView.addSubview(payBtn)
        bgView.addSubview(moneyLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        venueNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
           
            make.height.equalTo(kTitleHeight)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.left.equalTo(venueNameLab.snp.right).offset(kMargin)
            make.centerY.equalTo(venueNameLab)
            make.size.equalTo(rightArrowSize)
        }
        statusNameLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(venueNameLab)
            make.width.equalTo(80)
        }
        courseImgView.snp.makeConstraints { (make) in
            make.left.equalTo(venueNameLab)
            make.top.equalTo(venueNameLab.snp.bottom).offset(5)
            make.size.equalTo(CGSize.init(width: 90, height: 90))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(courseImgView.snp.right).offset(kMargin)
            make.top.equalTo(courseImgView)
            make.height.equalTo(30)
        }
        levelLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.width.equalTo(80)
            make.top.height.equalTo(nameLab)
        }
        orderNumLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(30)
        }
        checkNumLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(orderNumLab)
            make.top.equalTo(orderNumLab.snp.bottom)
            make.height.equalTo(30)
        }
        payTimeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(orderNumLab)
            make.height.equalTo(30)
            make.top.equalTo(checkNumLab.snp.bottom)
        }
        teacherLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(orderNumLab)
            make.top.equalTo(payTimeLab.snp.bottom)
            make.height.equalTo(30)
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(courseImgView)
            make.top.equalTo(teacherLab.snp.bottom).offset(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(-kMargin)
        }
        feedBackBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cancleBtn)
            make.top.equalTo(cancleBtn)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        payBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cancleBtn.snp.right).offset(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.top.equalTo(cancleBtn)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(cancleBtn)
            make.left.equalTo(payBtn.snp.right).offset(kMargin)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        view.isUserInteractionEnabled = true
        
        return view
    }()
    /// 场馆名称
    lazy var venueNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "联动健身馆"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 订单状态
    lazy var statusNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k13Font
        lab.textAlignment = .right
        lab.text = "待使用"
        
        return lab
    }()
    /// 课程图片
    lazy var courseImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.cornerRadius = 5
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 课程名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k16Font
        lab.text = "高效减脂"
        
        return lab
    }()
    /// 课程等级
    lazy var levelLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.text = "零基础"
        
        return lab
    }()
    /// 课程订单
    lazy var orderNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "课程订单：5657678900"
        
        return lab
    }()
    /// 核销码
    lazy var checkNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "核销码   ：163889989080"
        
        return lab
    }()
    /// 支付时间
    lazy var payTimeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "支付时间：2019-09-10 12:00"
        
        return lab
    }()
    /// 指定教练
    lazy var teacherLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "指定教练：王磊"
        
        return lab
    }()
    
    /// 合计金额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.textAlignment = .right
        lab.text = "合计金额：￥268"
        
        return lab
    }()
    /// 操作
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("取消订单", for: .normal)
        btn.cornerRadius = 15
        btn.borderColor = kBlueFontColor
        btn.borderWidth = klineWidth
        return btn
    }()
    /// 反馈
    lazy var feedBackBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("反馈", for: .normal)
        btn.cornerRadius = 15
        btn.borderColor = kBlueFontColor
        btn.borderWidth = klineWidth
        return btn
    }()
    /// 去支付
    lazy var payBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("去支付", for: .normal)
        btn.cornerRadius = 15
        btn.borderColor = kBlueFontColor
        btn.borderWidth = klineWidth
        return btn
    }()
}

