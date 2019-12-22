//
//  FSFoodGuideChildCell.swift
//  fitsky
//  饮食指南子cell
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFoodGuideChildCell: UICollectionViewCell {
    
    /// 填充数据
    var dataModel : FSCookBookModel?{
        didSet{
            if let model = dataModel {
                nameLab.text = model.title
                iconView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(nameLab)
        addSubview(moreLab)
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(nameLab.snp.top)
        }
        moreLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(nameLab.snp.top)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.bottom.equalTo(self)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_topic_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.cornerRadius = kCornerRadius
        
        return imgView
    }()
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "牛油果轻食"
        
        return lab
    }()
    ///查看更多
    lazy var moreLab: UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "查看更多"
        lab.backgroundColor = UIColor.RGBAColor(0, g: 0, b: 0, a: 0.5)
        
        return lab
    }()
}
