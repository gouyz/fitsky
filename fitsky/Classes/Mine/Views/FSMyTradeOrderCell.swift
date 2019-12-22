//
//  FSMyTradeOrderCell.swift
//  fitsky
//  交易 cell
//  Created by gouyz on 2019/11/1.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMyTradeOrderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCourseOrderModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.nick_name
                
                statusLab.text = model.display_pay_status_text
                statusLab.textColor = kOrangeFontColor
                if !model.display_refund_status_text!.isEmpty {
                    statusLab.text = model.display_refund_status_text
                    statusLab.textColor = kBlueFontColor
                }
                payTimeLab.text = "支付时间：\(model.display_pay_time!)"
                courseNameLab.text = model.goods_name
                priceLab.text = model.display_order_payed
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
        bgView.addSubview(userImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(statusLab)
        bgView.addSubview(payTimeLab)
        bgView.addSubview(courseNameLab)
        bgView.addSubview(priceLab)
        bgView.addSubview(checkImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
        }
        statusLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(kTitleHeight)
        }
        payTimeLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(checkImgView.snp.left).offset(-kMargin)
            make.height.equalTo(20)
            make.top.equalTo(nameLab.snp.bottom)
        }
        courseNameLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(payTimeLab)
            make.top.equalTo(payTimeLab.snp.bottom)
            make.right.equalTo(priceLab.snp.left).offset(-kMargin)
        }
        priceLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(courseNameLab)
            make.size.equalTo(CGSize.init(width: 120, height: 30))
        }
        
        checkImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    
    /// 用户图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 24
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "跑跑更健康"
        
        return lab
    }()
    ///
    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k12Font
        lab.text = "购买"
        
        return lab
    }()
    /// 支付时间
    lazy var payTimeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.text = "支付时间：2019.08.02 19：00"
        
        return lab
    }()
    /// 课程名称
    lazy var courseNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "《高效减脂》"
        
        return lab
    }()
    /// 价格
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k18Font
        lab.textAlignment = .right
        lab.text = "+￥268"
        
        return lab
    }()
    lazy var checkImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_sel_no"))
        imgView.highlightedImage = UIImage.init(named: "app_btn_sel_yes")
        imgView.isHidden = true
        
        return imgView
    }()
}

