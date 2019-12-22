//
//  FSTopicActiveListCell.swift
//  fitsky
//  活跃度排名 cell 
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTopicActiveListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSTopicActiveModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.nick_name
                
                /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
                if model.friend_type == "0"{
                    followLab.isHidden = false
                    followLab.text = "关注"
                    followLab.backgroundColor = kOrangeFontColor
                }else{
                    followLab.isHidden = true
                }
//                else if model.friend_type == "1" || model.friend_type == "2"{
//                    followLab.isHidden = false
//                    followLab.text = "取消关注"
//                    followLab.backgroundColor = kHeightGaryFontColor
//                }
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                
                var sexName: String = ""
//                var headerImg: String = "app_img_avatar_def"
                if model.sex == "0"{
                    sexName = "app_icon_sex_woman"
//                    headerImg = "app_img_avatar_def_woman"
                }else if model.sex == "1"{
                    sexName = "app_icon_sex_man"
//                    headerImg = "app_img_avatar_def_man"
                }
                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                sexImgView.image = UIImage.init(named: sexName)
                
                countLab.text = "活跃度：\(model.activity_count!)"
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
        contentView.addSubview(sexImgView)
        contentView.addSubview(followLab)
        contentView.addSubview(countLab)
        contentView.addSubview(lineView)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 72, height: 72))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(userImgView).offset(5)
            make.right.equalTo(followLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        sexImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.centerY.equalTo(countLab)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        countLab.snp.makeConstraints { (make) in
            make.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.left.equalTo(sexImgView.snp.right).offset(5)
        }
        followLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 36
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "跑跑更健康"
        
        return lab
    }()
    /// 性别
    lazy var sexImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_sex_man"))
    /// 粉丝数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "活跃度：1000"
        
        return lab
    }()
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
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
