//
//  FSPersonHomeAblumCell.swift
//  fitsky
//  个人主页 相册 cell
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeAblumCell: UICollectionViewCell {
    /// 填充数据
    var dataModel : FSSquareHotModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
                
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        self.clipsToBounds = true
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_bg_square_default")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
    }()
}
