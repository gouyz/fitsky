//
//  FSPasterImgView.swift
//  fitsky
//  贴纸 View
//  Created by gouyz on 2019/12/19.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let pasterImgCell = "pasterImgCell"

class FSPasterImgView: UIView {
    
    var didSelectItemBlock:((_ pasterImage: UIImage) -> Void)?
    /// 填充数据
    var pasterImageArray : [FSFindQiCaiCategoryModel]?{
        didSet{
            if pasterImageArray != nil {
                
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onCancleTap))
        setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(contentView)
        contentView.addSubview(collectionView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(300)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    ///
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ColorHexWithAlpha("#333333", alpha: 0.9)
        
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = floor((kScreenWidth - kMargin * 4)/3)
        //设置cell的大小
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        layout.scrollDirection = .vertical
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = UIColor.clear
        collView.showsVerticalScrollIndicator = false
        collView.showsHorizontalScrollIndicator = false
        
        collView.register(FSPersonHomeAblumCell.self, forCellWithReuseIdentifier: pasterImgCell)
        
        return collView
    }()
    
    /// 点击背景取消
    @objc func onCancleTap(){
        hide()
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showBackground()
        showAlertAnimation()
    }
    func hide(){
        contentView.isHidden = true
        hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    fileprivate func showBackground(){
        backgroundView.alpha = 0.0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.1
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values   = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        
        popAnimation.isRemovedOnCompletion = true
        popAnimation.fillMode = CAMediaTimingFillMode.forwards
        contentView.layer.add(popAnimation, forKey: nil)
    }
    
    fileprivate func hideAlertAnimation(){
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.0
        UIView.commitAnimations()
    }
}

extension FSPasterImgView : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pasterImageArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pasterImgCell, for: indexPath) as! FSPersonHomeAblumCell
        cell.iconView.kf.setImage(with: URL.init(string: pasterImageArray![indexPath.row].thumb!), placeholder: UIImage.init(named: "icon_bg_square_default"))
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: FSPersonHomeAblumCell = self.collectionView.cellForItem(at: indexPath) as! FSPersonHomeAblumCell
        
//        currFilterModel = dataList[indexPath.row]
//        self.collectionView.reloadData()
        if didSelectItemBlock != nil {
            didSelectItemBlock!(cell.iconView.image!)
        }
        hide()
    }
}
