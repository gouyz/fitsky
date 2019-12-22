//
//  FSCitySelectedHeaderView.swift
//  fitsky
//  城市选择header
//  Created by gouyz on 2019/7/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCitySelectedHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(nameLab)
        contentView.addSubview(areasBtn)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(areasBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(contentView)
        }
        areasBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(100)
        }
        
        areasBtn.set(image: UIImage.init(named: "app_btn_down"), title: "切换区县", titlePosition: .left, additionalSpacing: 5, state: .normal)
        areasBtn.set(image: UIImage.init(named: "app_btn_up"), title: "切换区县", titlePosition: .left, additionalSpacing: 5, state: .selected)
    }
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 区域选择btn
    lazy var areasBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        
        return btn
    }()
}
