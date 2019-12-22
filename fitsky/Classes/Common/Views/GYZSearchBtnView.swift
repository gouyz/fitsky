//
//  GYZSearchBtnView.swift
//  JSMachine
//  搜索
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class GYZSearchBtnView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    /// 在iOS11 NavBar自定义titleview里有个button,点击事件不触发了.的解决办法如下：
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(bgView)
        bgView.addSubview(searchBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(30)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        
        searchBtn.set(image: UIImage.init(named: "app_icon_seach"), title: "城市名/拼音", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
    }
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayBackGroundColor
        view.cornerRadius = 12
        view.isUserInteractionEnabled = true
        
        return view
    }()
    /// 搜索
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.backgroundColor = kGrayBackGroundColor
        btn.contentHorizontalAlignment = .left // 居左
        return btn
    }()
    
}
