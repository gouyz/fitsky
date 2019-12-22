//
//  FSFoodStoreDetailDesCell.swift
//  fitsky
//  食材库 详情 描述信息 cell
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodStoreDetailDesCell: UITableViewCell {

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
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.top.equalTo(desLab.snp.bottom).offset(15)
        }
    }
    
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k18Font
        lab.text = "豆汁"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.numberOfLines = 0
        lab.text = "含有少量蛋白，淀粉，矿物质，充分煮熟后使用。含有少量蛋白，淀粉，矿物质，充分煮熟后使用。含有少量蛋白，淀粉，矿物质，充分煮熟后使用。含有少量蛋白，淀粉，矿物质，充分煮熟后使用。"
        
        return lab
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()

}
