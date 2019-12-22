//
//  FSFoodMenuDetailCell.swift
//  fitsky
//  食谱食材列表cell
//  Created by gouyz on 2019/10/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodMenuDetailCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSFoodModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.name
                desLab.text = "\(model.amount!)\(model.unit_id_text!)"
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
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(desLab.snp.left).offset(-5)
            make.height.equalTo(kTitleHeight)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(60)
        }
        
    }

    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "蓝莓"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.textAlignment = .right
        lab.text = "1盒"
        
        return lab
    }()
}
