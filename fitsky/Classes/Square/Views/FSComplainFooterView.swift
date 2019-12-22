//
//  FSComplainFooterView.swift
//  fitsky
//  举报投诉footer
//  Created by gouyz on 2019/8/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSComplainFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(contentTxtView)
        
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(self)
        }
    }
    
    /// 投诉理由：
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        txtView.borderColor = kHeightGaryFontColor
        txtView.borderWidth = klineWidth
        txtView.cornerRadius = kCornerRadius
        
        return txtView
    }()
}
