//
//  FSMoreConmentFooterView.swift
//  fitsky
//  更多评论footer
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMoreConmentFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(conmentBtn)
        
        conmentBtn.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.width.equalTo(kScreenWidth * 0.5)
            make.height.equalTo(34)
        }
        conmentBtn.set(image: UIImage.init(named: "icon_more_down_arrow_orange"), title: "查看更多评论", titlePosition: .left, additionalSpacing: 5, state: .normal)
    }
    /// 更多评论
    lazy var conmentBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kOrangeFontColor, for: .normal)
        return btn
    }()
}
