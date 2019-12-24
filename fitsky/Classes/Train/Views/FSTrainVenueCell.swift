//
//  FSTrainVenueCell.swift
//  fitsky
//  训练营场馆cell
//  Created by gouyz on 2019/10/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class FSTrainVenueCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSTrainVenueModel?{
        didSet{
            if let model = dataModel {
                venueImgView.kf.setImage(with: URL.init(string: model.thumb_store_logo!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                if model.status == "1" {
                    vipImgView.isHidden = false
                    timeLab.isHidden = false
                    timeLab.text = "营业时间：\(model.business_stime!)-\(model.business_etime!)"
                }else{/// 未认证 隐藏
                    vipImgView.isHidden = true
                    timeLab.isHidden = true
                }
                nameLab.text = model.store_name
                numLab.text = model.hot_text
                distanceLab.text = model.distance_text
                
                tagsView.removeAllTags()
                tagsView.addTags(model.tags)
                
                tagsView.preferredMaxLayoutWidth = kScreenWidth - 160
                
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
        
        contentView.addSubview(venueImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(vipImgView)
        contentView.addSubview(timeLab)
        contentView.addSubview(numLab)
        contentView.addSubview(tagsView)
        contentView.addSubview(distanceLab)
        contentView.addSubview(lineView)
        
        venueImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 130, height: 90))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(venueImgView.snp.right).offset(kMargin)
            make.top.equalTo(venueImgView)
            make.height.equalTo(20)
        }
        vipImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(distanceLab.snp.left).offset(-kMargin)
        }
        numLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(timeLab)
            make.top.equalTo(timeLab.snp.bottom)
        }
        distanceLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(venueImgView)
            make.height.equalTo(timeLab)
//            make.width.equalTo(60)
        }
        tagsView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(numLab.snp.bottom).offset(5)
            make.right.equalTo(-kMargin)
            make.height.greaterThanOrEqualTo(30)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    /// 场馆图片
    lazy var venueImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 场馆名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "联动健身工作室"
        
        return lab
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_approve_venue"))
    /// 营业时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.text = "营业时间：10：00-18：00"
        
        return lab
    }()
    // 人气
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k12Font
        lab.text = "人气 93"
        
        return lab
    }()
    // 1.5km
    lazy var distanceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .right
        lab.text = "1.5km"
        
        return lab
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
        view.backgroundColor = kWhiteColor
        //        view.alignment = .fillByExpandingWidth
        view.manualCalculateHeight = true
        
        return view
    }()
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
}
