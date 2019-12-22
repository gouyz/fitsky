//
//  FSConfirmConditionCell.swift
//  fitsky
//  认证条件 cell
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSConfirmConditionCell: UITableViewCell {

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
        contentView.addSubview(nameLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        nameLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(bgView.snp.right).offset(kMargin)
            make.bottom.equalTo(-5)
            make.top.equalTo(5)
            make.height.greaterThanOrEqualTo(34)
        }
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        view.cornerRadius = 4
        
        return view
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.numberOfLines = 0
        lab.text = "需提供清晰头像"
        
        return lab
    }()

}
