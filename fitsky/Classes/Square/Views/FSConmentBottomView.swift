//
//  FSConmentBottomView.swift
//  fitsky
//  底部评论view
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSConmentBottomView: UIView {

    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int) -> Void)?
    
    
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
        
        addSubview(lineView)
        addSubview(bgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(desLab)
        addSubview(favouriteImgView)
        addSubview(zanImgView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.right.equalTo(favouriteImgView.snp.left).offset(-15)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(bgView)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(-kMargin)
        }
        
        zanImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgView)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        favouriteImgView.snp.makeConstraints { (make) in
            make.right.equalTo(zanImgView.snp.left).offset(-kMargin)
            make.centerY.height.equalTo(zanImgView)
            make.width.equalTo(16)
        }
        
    }
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayBackGroundColor
        view.cornerRadius = 15
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    ///tag图片
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_comment_edit"))
    ///
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "赶快参与评论吧！"
        
        return lab
    }()
    /// 收藏
    lazy var favouriteImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_icon_favourite"))
        imgView.highlightedImage = UIImage.init(named: "app_icon_favourite_selected")
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 赞
    lazy var zanImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_zan"))
        imgView.highlightedImage = UIImage.init(named: "icon_zan_selected")
        imgView.tag = 103
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag)
        }
    }
}
