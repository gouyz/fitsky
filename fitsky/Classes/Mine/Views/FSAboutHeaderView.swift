//
//  FSAboutHeaderView.swift
//  fitsky
//  帮助与关于 header
//  Created by gouyz on 2019/10/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSAboutHeaderView: UIView {
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(logoView)
        addSubview(lineView)
        
        logoView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 115, height: 100))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        
    }
    lazy var logoView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_logo"))
        
        return imgView
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
