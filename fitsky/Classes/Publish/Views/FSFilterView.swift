//
//  FSFilterView.swift
//  fitsky
//
//  Created by gouyz on 2020/4/19.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let FilterChildCell = "FilterChildCell"

class FSFilterView: UIView {
    
    var didSelectItemBlock:((_ model: AliyunEffectFilterInfo) -> Void)?
    /// FMDB的封装类
    var dbHelper: AliyunDBHelper = AliyunDBHelper.init()
    var dataList: [AliyunEffectFilterInfo] = [AliyunEffectFilterInfo]()
    /// 当前滤镜model
    var currFilterModel: AliyunEffectFilterInfo?
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupUI()
        
        loadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(contentView)
        contentView.addSubview(collectionView)
        
        contentView.addSubview(lineView)
        contentView.addSubview(filterView)
        filterView.addSubview(filterLab)
        filterView.addSubview(filterDotView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(145)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        filterView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo(80)
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
        
        
    }
    ///
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ColorHexWithAlpha("#343434", alpha: 0.3)
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
        
        collView.register(FSFilterTypeCell.self, forCellWithReuseIdentifier: FilterChildCell)
        
        return collView
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
}

extension FSFilterView : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterChildCell, for: indexPath) as! FSFilterTypeCell
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
