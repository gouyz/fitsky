//
//  FSFoodStoreListCell.swift
//  fitsky
//  食材库 列表 cell
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodStoreListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSFoodModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.name
                desLab.text = model.heat_text
                
                if model.is_recommend == "1" {
                    tuiJianLab.isHidden = false
                }else{
                    tuiJianLab.isHidden = true
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
        contentView.addSubview(desLab)
        contentView.addSubview(tuiJianLab)
        contentView.addSubview(lineView)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.right.equalTo(tuiJianLab.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
        }
        tuiJianLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "豆汁"
        
        return lab
    }()
    ///  规格
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "10.0Kcal/100g"
        
        return lab
    }()
    
    /// 推荐
    lazy var tuiJianLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = k15Font
        lab.textAlignment = .right
        lab.text = "推荐"
        
        return lab
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
