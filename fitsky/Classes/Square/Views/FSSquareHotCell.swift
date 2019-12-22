//
//  FSSquareHotCell.swift
//  fitsky
//  广场 热门cell
//  Created by gouyz on 2019/8/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSquareHotCell: UICollectionViewCell {
    
    /// 填充数据
    var dataModel : FSSquareHotModel?{
        didSet{
            if let model = dataModel {
                
                if model.thumb!.isEmpty{
                    tagImgView.isHidden = true
                }else{
                    tagImgView.isHidden = false
                    tagImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                }
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                
                if model.type == "3" || model.type == "6"{// 视频
                    playImgView.isHidden = false
                }else{
                    playImgView.isHidden = true
                }
                tuiJianImgView.isHidden = model.is_official == "1" ? false : true
                
                userHeaderImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.nick_name
                contentLab.text = model.content
                
                var zanCount: String = model.like_count!
                if zanCount.isEmpty || zanCount == "0"{
                    zanCount = ""
                }
                if model.moreModel?.is_like == "1"{// 已点赞
                    zanBtn.set(image: UIImage.init(named: "icon_zan_selected"), title: zanCount, titlePosition: .right, additionalSpacing: 3, state: .normal)
                    zanBtn.setTitleColor(kOrangeFontColor, for: .normal)
                }else{
                    zanBtn.set(image: UIImage.init(named: "icon_zan"), title: zanCount, titlePosition: .right, additionalSpacing: 3, state: .normal)
                    zanBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgWaiView)
        bgWaiView.addSubview(bgView)
        bgView.addSubview(tagImgView)
        tagImgView.addSubview(playImgView)
        bgWaiView.addSubview(tuiJianImgView)
        bgView.addSubview(userHeaderImgView)
        bgView.addSubview(vipImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(contentLab)
        bgView.addSubview(zanBtn)
        
        bgWaiView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(bgWaiView)
            make.top.equalTo(4)
            make.right.equalTo(-4)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
//            make.height.equalTo(frame.size.height - 84)
            make.bottom.equalTo(contentLab.snp.top).offset(-kMargin)
        }
        playImgView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.size.equalTo(CGSize.init(width: 29, height: 29))
        }
        tuiJianImgView.snp.makeConstraints { (make) in
            make.top.right.equalTo(bgWaiView)
            make.size.equalTo(CGSize.init(width: 29, height: 29))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(userHeaderImgView.snp.top).offset(-kMargin)
            make.height.equalTo(30)
        }
        userHeaderImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentLab)
            make.bottom.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userHeaderImgView)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userHeaderImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(userHeaderImgView)
            make.right.equalTo(zanBtn.snp.left).offset(-5)
        }
        zanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.height.equalTo(userHeaderImgView)
            make.width.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///外层背景view
    lazy var bgWaiView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
//        view.cornerRadius = kCornerRadius
        view.isUserInteractionEnabled = true
        
        return view
    }()
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.cornerRadius = kCornerRadius
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.UIColorFromRGB(valueRGB: 0xc5c9e5).cgColor
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        view.backgroundColor = kWhiteColor
        view.isUserInteractionEnabled = true
        
        return view
    }()
    ///tag图片
    lazy var tagImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = 3
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage.init(named: "icon_bg_square_default")
        
        return imgView
    }()
    /// 播放
    lazy var playImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_square_play"))
    /// 推荐
    lazy var tuiJianImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_square_recommend"))
    ///用户头像
    lazy var userHeaderImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = 12
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "Alison"
        
        return lab
    }()
    ///内容
    lazy var contentLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 12)
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        lab.text = "5个瑜伽动作，每天十几分钟，告别大粗腿，以前…"
        
        return lab
    }()
    /// 点赞
    lazy var zanBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
}

