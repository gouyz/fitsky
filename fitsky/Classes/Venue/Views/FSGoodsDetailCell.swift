//
//  FSGoodsDetailCell.swift
//  fitsky
//  服务详情 课程介绍 cell
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSGoodsDetailCell: UITableViewCell {

    /// 填充数据
    var dataModel : FSVenueServiceModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.goods_name
                timeLab.text = model.video_duration_text
                levelLab.text = model.difficulty_text
                
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
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.width.equalTo(60)
            make.bottom.equalTo(-kMargin)
        }
        levelLab.snp.makeConstraints { (make) in
            make.left.equalTo(timeLab.snp.right).offset(5)
            make.top.height.equalTo(timeLab)
            make.right.equalTo(nameLab)
            
        }
        
    }
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = UIFont.boldSystemFont(ofSize: 18)
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
}

