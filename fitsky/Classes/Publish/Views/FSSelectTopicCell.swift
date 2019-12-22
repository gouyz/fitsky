//
//  FSSelectTopicCell.swift
//  fitsky
//  发布动态 选择话题
//  Created by gouyz on 2019/9/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSelectTopicCell: UITableViewCell {

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
            make.top.equalTo(contentView)
            make.bottom.equalTo(lineView.snp.top)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(120)
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
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
