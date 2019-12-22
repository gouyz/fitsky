//
//  FSVenueTeacherCell.swift
//  fitsky
//  场馆 教练cell
//  Created by gouyz on 2019/9/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class FSVenueTeacherCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCoachModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "app_img_avatar_def"))
                nameLab.text = model.name
                tagsView.removeAllTags()
                tagsView.addTags(model.tags)
                
                tagsView.preferredMaxLayoutWidth = kScreenWidth - 145
                
                //必须调用,不然高度计算不准确
                tagsView.reload()
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
        
        contentView.addSubview(bgView)
        bgView.addSubview(userImgView)
        bgView.addSubview(vipImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(tagsView)
        bgView.addSubview(tagImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(contentView)
            make.height.greaterThanOrEqualTo(92)
        }
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
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: 30))
        }
        tagsView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.right.equalTo(tagImgView.snp.left).offset(-7)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.cornerRadius = 4
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 1
        view.layer.shadowColor = UIColor.UIColorFromRGB(valueRGB: 0xc5c9e5).cgColor
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        view.backgroundColor = kBackgroundColor
        view.isUserInteractionEnabled = true
        
        return view
    }()
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
        lab.text = "顾峰"
        
        return lab
    }()
    
    lazy var tagImgView: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_read"), for: .normal)
        
        return btn
    }()
    /// 所有标签
    lazy var tagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k12Font
        config?.textColor = kBlueFontColor
        config?.selectedTextColor = kBlueFontColor
        config?.borderColor = kBlueFontColor
        config?.selectedBorderColor = kBlueFontColor
        config?.backgroundColor = kWhiteColor
        config?.selectedBackgroundColor = kWhiteColor
        config?.cornerRadius = kCornerRadius
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        config?.extraSpace = CGSize.init(width: 12, height: 8)
        view.enableTagSelection = false
//        view.numberOfLines = 2
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.horizontalSpacing = kMargin
        view.backgroundColor = kBackgroundColor
//        view.alignment = .fillByExpandingWidth
        view.manualCalculateHeight = true
        
        return view
    }()

}
