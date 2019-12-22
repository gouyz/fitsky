//
//  FSNewsListCell.swift
//  fitsky
//  资讯  cell
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSNewsListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSSquareHotModel?{
        didSet{
            if let model = dataModel {
                nameLab.text = model.content
                newsImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                
                userHeaderImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                useNameLab.text = model.nick_name
                dateLab.text = model.display_create_time
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
        
        contentView.addSubview(nameLab)
        contentView.addSubview(newsImgView)
        contentView.addSubview(userHeaderImgView)
        contentView.addSubview(vipImgView)
        contentView.addSubview(useNameLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(lineView)
        
        newsImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.width.equalTo(140)
            make.height.equalTo(105)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.right.equalTo(newsImgView.snp.left).offset(-kMargin)
            make.top.equalTo(newsImgView)
            make.left.equalTo(kMargin)
        }
        userHeaderImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(newsImgView)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userHeaderImgView)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        useNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userHeaderImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(userHeaderImgView)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(useNameLab.snp.right).offset(kMargin)
            make.centerY.height.equalTo(useNameLab)
            make.width.equalTo(90)
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 资讯图片
    lazy var newsImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.cornerRadius = 5
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.numberOfLines = 2
        lab.text = "鸡肋，这些最受欢迎的健身动作，其实一点用…"
        
        return lab
    }()
    ///用户头像
    lazy var userHeaderImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.cornerRadius = 16
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///用户名称
    lazy var useNameLab: UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "抖汗官方账号"
        
        return lab
    }()
    ///日期
    lazy var dateLab: UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "06-12"
        
        return lab
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
