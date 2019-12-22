//
//  GYZLoginInputView.swift
//  baking
//  登录界面的输入View
//  Created by gouyz on 2016/12/1.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import SnapKit

class GYZLoginInputView: UIView {
    
    ///图片尺寸大小
    var imgSize: CGSize? = CGSize.init(width: 20, height: 22){
        didSet{
            if let size = imgSize {
                iconView.snp.updateConstraints({ (make) in
                    make.size.equalTo(size)
                })
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    convenience init(iconName : String,isPwd: Bool = false,keyType: UIKeyboardType = .default,size: CGSize? = nil){
        self.init(frame: CGRect.zero)
        
        iconView.image = UIImage(named: iconName)
        textFiled.keyboardType = keyType
        textFiled.isSecureTextEntry = isPwd
        
        if size != nil {
            imgSize = size!
            iconView.snp.updateConstraints({ (make) in
                make.size.equalTo(imgSize!)
            })
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        // 添加子控件
        addSubview(iconView)
        addSubview(textFiled)
        
        // 布局子控件
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalTo(self)
            make.size.equalTo(imgSize!)
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-kMargin)
            make.bottom.equalTo(self)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kWhiteColor
        textFiled.clearButtonMode = .whileEditing
        return textFiled
    }()
}
