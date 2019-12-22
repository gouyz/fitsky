//
//  FSFilterTypeCell.swift
//  fitsky
//  滤镜 cell
//  Created by gouyz on 2019/12/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFilterTypeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(nameLab)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(kMargin)
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
        imgView.image = UIImage.init(named: "icon_filter_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.borderColor = UIColor.clear
        imgView.borderWidth = 4
        
        return imgView
    }()
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "油画质感"
        
        return lab
    }()
}
