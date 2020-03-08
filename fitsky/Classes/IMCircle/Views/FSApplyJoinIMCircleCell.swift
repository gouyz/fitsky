//
//  FSApplyJoinIMCircleCell.swift
//  fitsky
//  申请加入社圈 cell
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSApplyJoinIMCircleCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(userImgView)
        contentView.addSubview(vipImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(stateLab)
        contentView.addSubview(lineView)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 64, height: 64))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(userImgView)
            make.right.equalTo(stateLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        stateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.height.equalTo(userImgView)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 32
        
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
    ///
    lazy var stateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k15Font
        lab.textAlignment = .right
        lab.text = "新申请"
        
        return lab
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    
}
