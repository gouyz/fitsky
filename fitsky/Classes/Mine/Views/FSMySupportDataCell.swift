//
//  FSMySupportDataCell.swift
//  fitsky
//  运动数据 cell
//  Created by gouyz on 2019/10/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMySupportDataCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.centerY.equalTo(bgView)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k14Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .center
        lab.text = "健身：30分钟"
        
        return lab
    }()
}
