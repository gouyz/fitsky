//
//  FSIMCircleNoticeCell.swift
//  fitsky
//  公告 cell
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleNoticeCell: UITableViewCell {
    
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
        bgView.addSubview(vipImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(managerImgView)
        bgView.addSubview(dateLab)
        bgView.addSubview(contentLab)
        bgView.addSubview(lineView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(userImgView)
            make.height.equalTo(24)
        }
        managerImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 16, height: 12))
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(userImgView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(klineWidth)
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
        }
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 24
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.text = "Alison"
        
        return lab
    }()
    /// 管理员
    lazy var managerImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_identity_administrator"))
    ///
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.text = "07-22 16:09"
        
        return lab
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k14Font
        lab.numberOfLines = 0
        lab.text = "不得在群内骂人斗嘴具有人身攻击性质的行为，可私下单挑解决。如被暴打请拨打110或向管理员求助，但管理员不负责替你出头。"
        
        return lab
    }()
}
