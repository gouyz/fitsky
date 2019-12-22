//
//  FSFoodMenuDetailDesCell.swift
//  fitsky
//  菜谱描述 cell
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodMenuDetailDesCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCookBookDetailModel?{
        didSet{
            if let model = dataModel {
                
                desLab.text = model.formData?.desContent
                nameLab.text = "千卡\((model.formData?.heat_text)!)"
                nameLab1.text = "碳水\((model.formData?.carbon_text)!)"
                nameLab2.text = "蛋白质\((model.formData?.protein_text)!)"
                nameLab3.text = "脂肪\((model.formData?.fat_text)!)"
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
        contentView.addSubview(desLab)
        contentView.addSubview(nameLab)
        contentView.addSubview(nameLab1)
        contentView.addSubview(nameLab2)
        contentView.addSubview(nameLab3)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.width.equalTo(nameLab1)
            make.height.equalTo(kTitleHeight)
            make.bottom.equalTo(-5)
        }
        nameLab1.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.width.equalTo(nameLab2)
            make.top.bottom.equalTo(nameLab)
        }
        nameLab2.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab1.snp.right).offset(kMargin)
            make.width.equalTo(nameLab3)
            make.top.bottom.equalTo(nameLab)
        }
        nameLab3.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab2.snp.right).offset(kMargin)
            make.width.equalTo(nameLab)
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(-kMargin)
        }
        
    }
    /// 简介
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "蓝莓香蕉吐司蓝莓香蕉吐司，蓝莓香蕉吐司蓝莓香蕉吐司蓝莓香蕉吐司蓝莓香蕉吐司蓝莓香，蕉吐司蓝莓香蕉吐司蓝莓香蕉吐司蓝。"
        
        return lab
    }()

    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.backgroundColor = kGrayBackGroundColor
        lab.cornerRadius = kCornerRadius
        lab.text = "千卡541"
        
        return lab
    }()
    ///
    lazy var nameLab1 : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.backgroundColor = kGrayBackGroundColor
        lab.cornerRadius = kCornerRadius
        lab.text = "碳水541"
        
        return lab
    }()
    ///
    lazy var nameLab2 : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.backgroundColor = kGrayBackGroundColor
        lab.cornerRadius = kCornerRadius
        lab.text = "蛋白质541"
        
        return lab
    }()
    ///
    lazy var nameLab3 : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.backgroundColor = kGrayBackGroundColor
        lab.cornerRadius = kCornerRadius
        lab.text = "脂肪541"
        
        return lab
    }()
}
