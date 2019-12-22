//
//  FSLoginOutFooterView.swift
//  fitsky
//  退出登录footer
//  Created by gouyz on 2019/10/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSLoginOutFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(loginOutBtn)
        
        loginOutBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(20)
            make.height.equalTo(50)
        }
    }
    /// 退出登录
    lazy var loginOutBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kGaryFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.setTitle("退出账号", for: .normal)
        return btn
    }()

}
