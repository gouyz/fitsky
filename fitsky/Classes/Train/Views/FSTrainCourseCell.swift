//
//  FSTrainCourseCell.swift
//  fitsky
//  训练营 精彩课程 cell
//  Created by gouyz on 2019/10/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTrainCourseCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSVenueServiceModel?{
        didSet{
            if let model = dataModel {
                
                venueImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                courseNameLab.text = model.goods_name
                desLab.text = model.difficulty_text
                nameLab.text = model.store_id_text
                numLab.text = "已有\(model.member_count!)人加入学习"
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
        contentView.addSubview(courseNameLab)
        contentView.addSubview(numLab)
        contentView.addSubview(desLab)
        contentView.addSubview(lineView)
        
        venueImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 130, height: 90))
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        
        courseNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(venueImgView.snp.right).offset(kMargin)
            make.top.equalTo(venueImgView)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(courseNameLab)
            make.left.equalTo(courseNameLab.snp.right).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(15)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(courseNameLab)
            make.top.equalTo(courseNameLab.snp.bottom)
        }
        vipImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        numLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.right.equalTo(-kMargin)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
        
    }
    /// 课程图片
    lazy var venueImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 课程名称
    lazy var courseNameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "高效减脂"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "零基础"
        
        return lab
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
    
    // 人数
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "已有201000人加入学习"
        
        return lab
    }()
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
}
