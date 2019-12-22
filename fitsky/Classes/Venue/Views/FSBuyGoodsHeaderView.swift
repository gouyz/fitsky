//
//  FSBuyGoodsHeaderView.swift
//  fitsky
//  选择教练 header
//  Created by gouyz on 2019/9/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSBuyGoodsHeaderView: UIView {

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
        addSubview(numDesLab)
        addSubview(minusView)
        addSubview(numLab)
        addSubview(addView)
        addSubview(coachDesLab)
        addSubview(desLab)
        numDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(80)
            make.top.equalTo(self)
            make.height.equalTo(kTitleHeight)
        }
        addView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(numDesLab)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        numLab.snp.makeConstraints { (make) in
            make.right.equalTo(addView.snp.left).offset(-kMargin)
            make.centerY.equalTo(addView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        minusView.snp.makeConstraints { (make) in
            make.right.equalTo(numLab.snp.left).offset(-kMargin)
            make.centerY.size.equalTo(addView)
        }
        
        coachDesLab.snp.makeConstraints { (make) in
            make.left.width.equalTo(numDesLab)
            make.top.equalTo(numDesLab.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.height.equalTo(coachDesLab)
            make.left.equalTo(coachDesLab.snp.right).offset(kMargin)
        }
    }
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 购买数量
    lazy var numDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "购买数量"
        
        return lab
    }()
    /// 减
    lazy var minusView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "app_btn_class_sel_nor")
        imgView.tag = 101
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 购买数量
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.textAlignment = .center
        lab.backgroundColor = kGrayLineColor
        lab.text = "1"
        
        return lab
    }()
    /// 加
    lazy var addView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "app_btn_class_sel_add")
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return imgView
    }()
    /// 教练配备
    lazy var coachDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k15Font
        lab.text = "教练配备"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .right
        lab.text = "（仅限一名教练）"
        
        return lab
    }()
    
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag)
        }
    }
}
