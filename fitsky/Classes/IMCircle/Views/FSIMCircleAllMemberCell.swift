//
//  FSIMCircleAllMemberCell.swift
//  fitsky
//  全部成员 cell
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleAllMemberCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSIMCircleMemberModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                nameLab.text = model.circle_nick_name
                checkImgView.isHidden = true
                if model.is_group == "1" || model.is_admin == "1" {
                    managerImgView.isHidden = false
                }else{
                    managerImgView.isHidden = true
                }
                /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
                if model.friend_type == "0"{
                    followLab.isHidden = false
                    followLab.text = "关注"
                    followLab.backgroundColor = kOrangeFontColor
                }else if model.friend_type == "1" || model.friend_type == "2"{
                    followLab.isHidden = false
                    followLab.text = "取消关注"
                    followLab.backgroundColor = kHeightGaryFontColor
                }else{
                    followLab.isHidden = true
                }
            }
        }
    }

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
        contentView.addSubview(managerImgView)
        contentView.addSubview(followLab)
        contentView.addSubview(checkImgView)
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
            make.height.equalTo(30)
        }
        managerImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 16, height: 12))
        }
        followLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        checkImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
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
    /// 管理员
    lazy var managerImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_identity_administrator"))
    /// 关注
    lazy var followLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.cornerRadius = 12
        lab.backgroundColor = kOrangeFontColor
        lab.text = "关注"
        
        return lab
    }()
    /// check
    lazy var checkImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_btn_sel_no"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()

}
