//
//  FSSelectSeePowerCell.swift
//  fitsky
// 选择 谁可以看 cell
//  Created by gouyz on 2019/9/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSSelectSeePowerCell: UITableViewCell {

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
        contentView.addSubview(checkedImgView)
        checkedImgView.isHidden = true
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(checkedImgView.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        checkedImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 16, height: 12))
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
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    
    lazy var checkedImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_search_ok"))
}
