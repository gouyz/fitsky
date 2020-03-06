//
//  FSIMCircleMemberRightCell.swift
//  fitsky
//  社圈用户头像 查看更多cell
//  Created by gouyz on 2020/3/6.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleMemberRightCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 8, height: 16))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_icon_big_right")
        
        return imgView
    }()
}
