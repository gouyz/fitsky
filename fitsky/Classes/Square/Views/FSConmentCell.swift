//
//  FSConmentCell.swift
//  fitsky
//  评论cell
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSConmentCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSConmentModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.nick_name
                dateLab.text = model.display_create_time
                contentLab.text = model.content
                
                /// 会员类型（1-普通 2-达人 3-场馆）
                vipImgView.isHidden = false
                if model.member_type == "2"{
                    vipImgView.image = UIImage.init(named: "app_icon_daren")
                }else if model.member_type == "3"{
                    vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                }else{
                    vipImgView.isHidden = true
                }
                
                var zanCount: String = model.like_count!
                if zanCount.isEmpty || zanCount == "0"{
                    zanCount = ""
                }
                var conmentCount: String = model.reply_count!
                if conmentCount.isEmpty || conmentCount == "0"{
                    conmentCount = ""
                }
                
                if model.moreModel?.is_like == "1"{// 已点赞
                    zanBtn.set(image: UIImage.init(named: "icon_zan_selected"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    zanBtn.setTitleColor(kOrangeFontColor, for: .normal)
                }else{
                    zanBtn.set(image: UIImage.init(named: "icon_zan"), title: zanCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                    zanBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
                }
                conmentBtn.set(image: UIImage.init(named: "app_icon_comment_no"), title: conmentCount, titlePosition: .right, additionalSpacing: 5, state: .normal)
                if Int(model.reply_count!) > 0{
                    replyLab.isHidden = false
                }else{
                    replyLab.isHidden = true
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
        contentView.addSubview(dateLab)
        contentView.addSubview(contentLab)
        
        contentView.addSubview(replyLab)
        contentView.addSubview(conmentBtn)
        contentView.addSubview(zanBtn)
        contentView.addSubview(lineView)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 10, height: 10))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(20)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(userImgView)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(userImgView.snp.bottom).offset(5)
        }
        replyLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.left.equalTo(contentLab)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        zanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(replyLab)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        conmentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(zanBtn.snp.left).offset(-3)
            make.centerY.size.equalTo(zanBtn)
        }
        lineView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.left.equalTo(nameLab)
            make.top.equalTo(replyLab.snp.bottom)
        }
        
    }
    
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 20
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "Alison"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "06-22 13:00"
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "很有效很有效很有效很有效很有效很有效很有效很有效很有效很有效......"
        
        return lab
    }()
    /// 查看更多回复
    lazy var replyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k13Font
        lab.text = "展开全部回复"
        
        return lab
    }()
    /// 评论
    lazy var conmentBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        return btn
    }()
    /// 点赞
    lazy var zanBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        return btn
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
