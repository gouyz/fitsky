//
//  FSMsgZanCell.swift
//  fitsky
//  点赞消息cell
//  Created by gouyz on 2019/12/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMsgZanCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSMsgZanModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.from_avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                tagImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.from_member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.from_member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                nameLab.text = model.from_nick_name
                desLab.text = model.title
                if model.content_type == "1" {
                    bgContentView.backgroundColor = kGrayBackGroundColor
                }else{
                    bgContentView.backgroundColor = kWhiteColor
                }
                contentLab.text = model.content
                dateLab.text = model.display_create_time
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
        bgView.addSubview(vipImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(desLab)
        bgView.addSubview(tagImgView)
        bgView.addSubview(bgContentView)
        bgContentView.addSubview(contentLab)
        bgView.addSubview(dateLab)
        
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
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        tagImgView.snp.makeConstraints { (make) in
            make.right.top.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 90, height: 90))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(userImgView)
            make.right.equalTo(desLab.snp.left).offset(-5)
            make.height.equalTo(25)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(tagImgView.snp.left).offset(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.greaterThanOrEqualTo(100)
        }
        bgContentView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(desLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(nameLab)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.bottom.top.equalTo(bgContentView)
            make.right.equalTo(-5)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgContentView)
            make.top.equalTo(bgContentView.snp.bottom)
            make.height.equalTo(nameLab)
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
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 24
        
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
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k15Font
        
        return lab
    }()
    ///
    lazy var bgContentView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayBackGroundColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 图片tag
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        
        return lab
    }()
}

