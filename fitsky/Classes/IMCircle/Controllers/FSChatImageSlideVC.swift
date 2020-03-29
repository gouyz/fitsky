//
//  FSChatImageSlideVC.swift
//  fitsky
//  聊天图片
//  Created by gouyz on 2020/3/29.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSChatImageSlideVC: RCImagePreviewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.titleLabel?.font = k15Font
        leftBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.addTarget(self, action: #selector(leftBarButtonItemPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.rightBarButtonItem = nil
        
        
    }
    /// 重载设置状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
