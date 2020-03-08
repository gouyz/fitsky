//
//  FSIMCircleMemberIconCell.swift
//  fitsky
//  社圈用户头像cell
//  Created by gouyz on 2020/3/6.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSIMCircleMemberIconCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(iconView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        iconView.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var bgView:UIView = UIView()
    ///
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "app_img_avatar_def")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.cornerRadius = 24
        
        return imgView
    }()
}
