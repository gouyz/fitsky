//
//  FSPersonHomeBottomView.swift
//  fitsky
//  个人主页底部 关注、私聊
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSPersonHomeBottomView: UIView {
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.addSubview(bgView)
        bgView.addSubview(followImgView)
        bgView.addSubview(lineView)
        bgView.addSubview(chatImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        lineView.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
            make.width.equalTo(30)
            make.height.equalTo(klineDoubleWidth)
        }
        followImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.bottom.equalTo(lineView.snp.top).offset(-5)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        chatImgView.snp.makeConstraints { (make) in
            make.centerX.size.equalTo(followImgView)
            make.top.equalTo(lineView.snp.bottom).offset(5)
        }
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        view.cornerRadius = 25
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    // 关注
    lazy var followImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_follow_no"), highlightedImage: UIImage.init(named: "app_icon_follow_yes"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGaryFontColor
        
        return view
    }()
    // 私聊
    lazy var chatImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_comment_message"))
}

