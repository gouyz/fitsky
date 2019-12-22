//
//  FSGoodsDetailBottomView.swift
//  fitsky
//  服务详情 课程介绍  bottom
//  Created by gouyz on 2019/9/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSGoodsDetailBottomView: UIView {

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
        addSubview(priceLab)
        addSubview(favouriteLab)
        addSubview(studyLab)
        
        lineView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.right.equalTo(favouriteLab.snp.left)
            make.height.equalTo(klineWidth)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(kBottomTabbarHeight)
            make.right.equalTo(lineView)
        }
        favouriteLab.snp.makeConstraints { (make) in
            make.right.equalTo(studyLab.snp.left)
            make.top.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(priceLab)
        }
        
        studyLab.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.bottom.equalTo(favouriteLab)
            make.width.equalTo(80)
        }
        
    }
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 价格
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kOrangeFontColor
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.text = "￥260"
        
        return lab
    }()
    ///
    lazy var favouriteLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.backgroundColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "收藏"
        lab.tag = 101
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    /// 加入学习
    lazy var studyLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.backgroundColor = kOrangeFontColor
        lab.text = "加入学习"
        lab.textAlignment = .center
        lab.tag = 102
        lab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return lab
    }()
    
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag)
        }
    }
}
