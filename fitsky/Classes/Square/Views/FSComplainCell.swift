//
//  FSComplainCell.swift
//  fitsky
//  举报投诉 cell
//  Created by gouyz on 2019/8/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSComplainCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.backgroundColor = kGrayLineColor
        lab.textAlignment = .center
        
        return lab
    }()
}
