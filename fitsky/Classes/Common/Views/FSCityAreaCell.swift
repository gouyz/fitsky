//
//  FSCityAreaCell.swift
//  fitsky
//  热门城市，区县cell
//  Created by gouyz on 2019/7/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCityAreaCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kGrayBackGroundColor
        addSubview(nameLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.textAlignment = .center
        lab.text = "常州"
        
        return lab
    }()
}
