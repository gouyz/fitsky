//
//  FSMessageHeaderView.swift
//  fitsky
//  消息header
//  Created by gouyz on 2020/3/27.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

class FSMessageHeaderView: UIView {
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(zanView)
        addSubview(conmentView)
        addSubview(favouriteView)
        addSubview(noticeView)
        addSubview(dingYueView)
        
        zanView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(54)
        }
        conmentView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(zanView)
            make.top.equalTo(zanView.snp.bottom).offset(klineDoubleWidth)
        }
        favouriteView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(zanView)
            make.top.equalTo(conmentView.snp.bottom).offset(klineDoubleWidth)
        }
        noticeView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(zanView)
            make.top.equalTo(favouriteView.snp.bottom).offset(klineDoubleWidth)
        }
        dingYueView.snp.makeConstraints { (make) in
            make.left.right.equalTo(zanView)
            make.height.equalTo(64)
            make.bottom.equalTo(-klineWidth)
        }
    }
    lazy var zanView: FSMessageCell = {
        let view = FSMessageCell()
        view.tag = 110
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    lazy var conmentView: FSMessageCell = {
        let view = FSMessageCell()
        view.tag = 111
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    lazy var favouriteView: FSMessageCell = {
        let view = FSMessageCell()
        view.tag = 112
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    lazy var noticeView: FSMessageCell = {
        let view = FSMessageCell()
        view.tag = 113
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    lazy var dingYueView: FSMessageChatCell = {
        let view = FSMessageChatCell()
        view.tag = 114
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    
    @objc func onClickedOperator(sender:UITapGestureRecognizer){
        if didSelectItemBlock != nil {
            didSelectItemBlock!((sender.view?.tag)!)
        }
    }
}
