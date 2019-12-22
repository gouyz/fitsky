//
//  FSFoodGuideCell.swift
//  fitsky
//  饮食指南 cell
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let foodGuideChildCell = "foodGuideChildCell"

class FSFoodGuideCell: UITableViewCell {
    
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    /// 填充数据
    var dataModel : [FSCookBookModel] = [FSCookBookModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kWhiteColor
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(contentView)
            make.height.equalTo(150)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: 110, height: 150)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineDoubleWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = kMargin
        layout.scrollDirection = .horizontal
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        collView.showsVerticalScrollIndicator = false
        collView.showsHorizontalScrollIndicator = false
        
        collView.register(FSFoodGuideChildCell.self, forCellWithReuseIdentifier: foodGuideChildCell)
        
        return collView
    }()
}

extension FSFoodGuideCell : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodGuideChildCell, for: indexPath) as! FSFoodGuideChildCell
        
        cell.dataModel = dataModel[indexPath.row]
        if indexPath.row == dataModel.count - 1 {
            cell.moreLab.isHidden = false
            cell.nameLab.isHidden = true
        }else{
            cell.moreLab.isHidden = true
            cell.nameLab.isHidden = false
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if didSelectItemBlock != nil {
            didSelectItemBlock!(indexPath.row)
        }
    }
}
