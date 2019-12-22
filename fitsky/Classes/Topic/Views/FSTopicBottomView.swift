//
//  FSTopicBottomView.swift
//  fitsky
//  话题 底部菜单
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTopicBottomView: UIView {

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
        addSubview(operatorImgView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(klineWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(34)
            make.right.equalTo(operatorImgView.snp.left).offset(-kMargin)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(bgView)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(-kMargin)
        }
        
        operatorImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgView)
            make.width.equalTo(26)
            make.height.equalTo(26)
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
        lab.text = "赶快参与话题吧！"
        
        return lab
    }()
    /// 赞
    lazy var operatorImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_btn_topic"))
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag)
        }
    }
}
