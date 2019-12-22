//
//  FSAllConmentHeaderView.swift
//  fitsky
//  所有评论排序header
//  Created by gouyz on 2019/8/25.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSAllConmentHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(sortImgView)
        
        sortImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 40, height: 15))
        }
    }
    ///排序图片
    lazy var sortImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_search_by_hot"))
    
}
