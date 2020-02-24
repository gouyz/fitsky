//
//  FSFindCircleCell.swift
//  fitsky
//  发现社圈
//  Created by gouyz on 2020/2/24.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSFindCircleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(tagImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(typeLab)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        typeLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(tagImgView)
            make.height.equalTo(30)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(typeLab.snp.right).offset(kMargin)
            make.centerY.height.equalTo(typeLab)
        }
        
    }
    
    /// 社圈图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 24
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k14Font
        lab.text = "湖塘健身一圈1"
        
        return lab
    }()
    ///
    lazy var typeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.text = "学员"
        
        return lab
    }()

}
