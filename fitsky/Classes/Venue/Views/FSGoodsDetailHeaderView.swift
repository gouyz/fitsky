//
//  FSGoodsDetailHeaderView.swift
//  fitsky
//  教程详情 header
//  Created by gouyz on 2019/9/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import ZFPlayer

class FSGoodsDetailHeaderView: UIView {

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
        
        addSubview(containerView)
        containerView.addSubview(playBtn)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
    }
    lazy var containerView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.setImageWithURLString("", placeholder: ZFUtilities.image(with: UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 开始
    lazy var playBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_video_play_white"), for: .normal)

        return btn
    }()
}
