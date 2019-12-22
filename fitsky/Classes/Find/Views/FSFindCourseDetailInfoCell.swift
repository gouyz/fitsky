//
//  FSFindCourseDetailInfoCell.swift
//  fitsky
//  发现 课程详情 课程信息cell
//  Created by gouyz on 2019/10/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindCourseDetailInfoCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSFindCourseDetailModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.formData?.name
                timeLab.text = model.formData?.video_duration_text
                levelLab.text = model.formData?.attr_id_3_text
                desLab.text = model.formData?.brief
                
                if model.moreModel?.is_collect == "1" {
                    favouriteBtn.isSelected = true
                }else{
                    favouriteBtn.isSelected = false
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
        contentView.addSubview(nameLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(levelLab)
        contentView.addSubview(favouriteBtn)
        contentView.addSubview(desLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.height.top.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.width.equalTo(60)
        }
        levelLab.snp.makeConstraints { (make) in
            make.left.equalTo(timeLab.snp.right).offset(5)
            make.top.height.equalTo(timeLab)
            make.width.equalTo(80)
        }
        favouriteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(kTitleHeight)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
            make.right.equalTo(-kMargin)
        }
        
    }
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k18Font
        lab.text = "高效燃脂"
        
        return lab
    }()
    ///
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "60分钟"
        
        return lab
    }()
    ///
    lazy var levelLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "入门级"
        
        return lab
    }()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_favourite"), for: .normal)
        btn.setImage(UIImage.init(named: "app_icon_favourite_selected"), for: .selected)
        return btn
    }()
    /// 课程简介
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "基础动作练习，从0开始！"
        
        return lab
    }()

}
