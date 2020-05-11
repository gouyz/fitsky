//
//  FSCustomTagSelectedCell.swift
//  fitsky
//  自定义标签 cell
//  Created by iMac on 2020/5/11.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSCustomTagSelectedCell: UITableViewCell {
    
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
        contentView.addSubview(desLab)
        contentView.addSubview(lineView)
        contentView.addSubview(iconView)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(iconView.snp.left).offset(-kMargin)
            make.height.equalTo(24)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
            make.bottom.equalTo(-kMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "点击创建标签"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_btn_class_sel_add"))
}
