//
//  FSAllReplyUserInfoCell.swift
//  fitsky
//  全部回复用户信息cell
//  Created by gouyz on 2019/8/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSAllReplyUserInfoCell: UITableViewCell {
    /// 填充数据
    var dataModel : FSConmentDetailModel?{
        didSet{
            if let model = dataModel {
                
                if let infoModel = model.formData{
                    userImgView.kf.setImage(with: URL.init(string: infoModel.avatar!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                    nameLab.text = infoModel.nick_name
                    dateLab.text = infoModel.display_create_time
                    contentLab.text = infoModel.content
                    /// 会员类型（1-普通 2-达人 3-场馆）
                    vipImgView.isHidden = false
                    if infoModel.member_type == "2"{
                        vipImgView.image = UIImage.init(named: "app_icon_daren")
                    }else if infoModel.member_type == "3"{
                        vipImgView.image = UIImage.init(named: "app_icon_approve_venue")
                    }else{
                        vipImgView.isHidden = true
                    }
                }
                
                var zanCount: String = (model.countModel?.like_count)!
                if zanCount.isEmpty || zanCount == "0"{
                    zanCount = ""
                }
                var conmentCount: String = (model.countModel?.reply_count)!
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
            
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
        
        conmentBtn.set(image: UIImage.init(named: "app_icon_comment_no"), title: "2019", titlePosition: .right, additionalSpacing: 3, state: .normal)
        zanBtn.set(image: UIImage.init(named: "icon_zan"), title: "2019", titlePosition: .right, additionalSpacing: 3, state: .normal)
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
        contentView.addSubview(conmentBtn)
        contentView.addSubview(zanBtn)
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
            make.top.equalTo(userImgView).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(24)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
        }
        conmentBtn.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(zanBtn)
            make.right.equalTo(zanBtn.snp.left).offset(-3)
        }
        zanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.top.equalTo(zanBtn.snp.bottom).offset(kMargin)
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
        lab.textColor = kHeightGaryFontColor
        lab.font = k15Font
        lab.text = "跑跑更健康"
        
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
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.numberOfLines = 0
        lab.text = "跟着视频来很有意思噢跟着视频来很有意思噢跟着视频来很有意思噢"
        
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
