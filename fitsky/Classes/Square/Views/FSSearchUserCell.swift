//
//  FSSearchUserCell.swift
//  fitsky
//  搜索用户 cell
//  Created by gouyz on 2019/8/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSearchUserCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSUserInfoModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.nick_name
                levelNameLab.text = model.type_text
                countLab.text = "粉丝：\(model.fans!)"
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
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
        contentView.addSubview(levelNameLab)
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
            make.top.equalTo(userImgView)
            make.right.equalTo(followLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        levelNameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        countLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(levelNameLab)
            make.top.equalTo(levelNameLab.snp.bottom)
            make.bottom.equalTo(userImgView)
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
        
        return lab
    }()
    ///
    lazy var levelNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        
        return lab
    }()
    /// 粉丝数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        
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
