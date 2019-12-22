//
//  FSPersonHomeAblumHeaderView.swift
//  fitsky
//  相册 header
//  Created by gouyz on 2019/12/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeAblumHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(lineView)
        addSubview(nameLab)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalTo(self)
            make.right.equalTo(-kMargin)
        }
    }
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 13)
        lab.textColor = kGaryFontColor
        lab.text = "全部相册"
        
        return lab
    }()

}
