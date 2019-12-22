//
//  FSLabAndLabBtnView.swift
//  fitsky
//  上下2行文字btn
//  Created by gouyz on 2019/10/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSLabAndLabBtnView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        // 添加子控件
        addSubview(desLab)
        addSubview(contentLab)
        
        // 布局子控件
        desLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(kMargin)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.height.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.right.equalTo(-5)
            make.left.equalTo(5)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.textAlignment = .center
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .center
        
        return lab
    }()
}

