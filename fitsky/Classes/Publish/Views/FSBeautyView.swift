//
//  FSBeautyView.swift
//  fitsky
//  美化 view
//  Created by gouyz on 2019/12/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let beautyChildCell = "beautyChildCell"

class FSBeautyView: UIView {
    
    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int,_ sender: FSBeautyView) -> Void)?
    var didSelectItemBlock:((_ model: AliyunEffectFilterInfo) -> Void)?
    /// FMDB的封装类
    var dbHelper: AliyunDBHelper = AliyunDBHelper.init()
    var dataList: [AliyunEffectFilterInfo] = [AliyunEffectFilterInfo]()
    /// 当前滤镜model
    var currFilterModel: AliyunEffectFilterInfo?
    
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
        
        loadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(sliderView)
        
        contentView.addSubview(lineView)
        contentView.addSubview(filterView)
        filterView.addSubview(filterLab)
        filterView.addSubview(filterDotView)
        contentView.addSubview(beautyView)
        beautyView.addSubview(beautyLab)
        beautyView.addSubview(beautyDotView)
        contentView.addSubview(pasterView)
        pasterView.addSubview(pasterLab)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo((kStateHeight > 20 ? 220 : 200))
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(145)
        }
        
        sliderView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(70)
            make.left.equalTo(kMargin)
            make.height.equalTo(30)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        filterView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo(beautyView)
            make.height.equalTo(54)
        }
        filterLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(filterView)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        filterDotView.snp.makeConstraints { (make) in
            make.centerX.equalTo(filterView)
            make.top.equalTo(filterLab.snp.bottom)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        
        beautyView.snp.makeConstraints { (make) in
            make.left.equalTo(filterView.snp.right).offset(20)
            make.top.height.equalTo(filterView)
            make.width.equalTo(pasterView)
        }
        beautyLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(beautyView)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        beautyDotView.snp.makeConstraints { (make) in
            make.centerX.equalTo(beautyView)
            make.top.equalTo(beautyLab.snp.bottom)
            make.size.equalTo(filterDotView)
        }
        pasterView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(beautyView)
            make.width.equalTo(filterView)
            make.left.equalTo(beautyView.snp.right).offset(20)
        }
        pasterLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(pasterView)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    ///
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ColorHex("#343434")
//        view.addOnClickListener(target: self, action: #selector(onBgViewClicked))
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: 75, height: 125)
        //每个Item之间最小的间距
//        layout.minimumInteritemSpacing = klineDoubleWidth
//        //每行之间最小的间距
//        layout.minimumLineSpacing = kMargin
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        layout.scrollDirection = .horizontal
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = UIColor.clear
        collView.showsVerticalScrollIndicator = false
        collView.showsHorizontalScrollIndicator = false
        
        collView.register(FSFilterTypeCell.self, forCellWithReuseIdentifier: beautyChildCell)
        
        return collView
    }()
    lazy var sliderView: QiSlider = {
        let slider = QiSlider.init()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.thumbTintColor = kWhiteColor
        slider.minimumTrackTintColor = kWhiteColor
        slider.maximumTrackTintColor = kGrayLineColor
        slider.valueText = "0"
        
        return slider
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///滤镜
    lazy var filterView: UIView = {
        let view = UIView()
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 滤镜
    lazy var filterLab: UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "滤镜"
        
        return lab
    }()
    ///滤镜 圆点
    lazy var filterDotView: UIView = {
        let view = UIView()
        view.backgroundColor = kOrangeFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///美颜
    lazy var beautyView: UIView = {
        let view = UIView()
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 美颜
    lazy var beautyLab: UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "美颜"
        
        return lab
    }()
    ///美颜 圆点
    lazy var beautyDotView: UIView = {
        let view = UIView()
        view.backgroundColor = kOrangeFontColor
        view.cornerRadius = 4
        
        return view
    }()
    ///贴纸
    lazy var pasterView: UIView = {
        let view = UIView()
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
        return view
    }()
    /// 贴纸
    lazy var pasterLab: UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "贴纸"
        
        return lab
    }()
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.view!.tag,self)
        }
    }
    /// 初始化滤镜数据
    func loadData(){
        self.dataList.removeAll()
        dbHelper.queryResource(withEffecInfoType: AliyunEffectType.filter.rawValue, success: { [unowned self](infoModelArray) in
            for model in infoModelArray!{
                self.dataList.append(model as! AliyunEffectFilterInfo)
            }
            if self.dataList.count > 0{
                self.collectionView.reloadData()
            }
        }) { (error) in
            
        }
    }
    /// 点击背景取消
    @objc func onCancleTap(){
        hide()
    }
    
    @objc func onBgViewClicked(){
        
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

extension FSBeautyView : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: beautyChildCell, for: indexPath) as! FSFilterTypeCell
        let model = dataList[indexPath.row]
        cell.nameLab.text = model.name
        cell.iconView.image  = UIImage.init(contentsOfFile: model.localFilterIconPath())
        cell.iconView.borderColor = UIColor.clear
        if let item = currFilterModel  {
            if item.eid == model.eid {
                cell.iconView.borderColor = kWhiteColor
            }
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currFilterModel = dataList[indexPath.row]
        self.collectionView.reloadData()
        if didSelectItemBlock != nil {
            didSelectItemBlock!(dataList[indexPath.row])
        }
    }
}

