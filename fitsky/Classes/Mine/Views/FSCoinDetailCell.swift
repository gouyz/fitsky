//
//  FSCoinDetailCell.swift
//  fitsky
//  积分明细 cell
//  Created by gouyz on 2019/11/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCoinDetailCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCoinDetailModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.title
                nameLab.textAlignment = .left
                coinNumLab.text = model.point_text
                dateLab.text = model.display_create_time
                
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
        contentView.addSubview(coinNumLab)
        contentView.addSubview(dateLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(coinNumLab.snp.left).offset(-kMargin)
        }
        coinNumLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(kScreenWidth * 0.3)
            make.height.equalTo(20)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.bottom.equalTo(-kMargin)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
    }
    
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.numberOfLines = 0
        lab.text = "阻力带"
        
        return lab
    }()
    ///
    lazy var coinNumLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.textAlignment = .center
        lab.text = "300积分"
        
        return lab
    }()
    ///
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "限1000份"
        
        return lab
    }()
    
}
