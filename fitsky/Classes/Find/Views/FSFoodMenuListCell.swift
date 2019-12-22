//
//  FSFoodMenuListCell.swift
//  fitsky
//  菜谱分类 cell
//  Created by gouyz on 2019/10/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodMenuListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : FSCookBookCategoryModel?{
        didSet{
            if let model = dataModel {
                nameLab.text = model.name
                bgImgView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_ads_default"))
                
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
        
        contentView.addSubview(bgImgView)
        bgImgView.addSubview(nameLab)
        
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        
    }
    
    /// 服务图片
    lazy var bgImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_ads_default")
        imgView.cornerRadius = kCornerRadius
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = UIFont.boldSystemFont(ofSize: 26)
        lab.textAlignment = .center
        lab.text = "早餐"
        
        return lab
    }()

}
