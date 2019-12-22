//
//  FSHotCityCell.swift
//  fitsky
//  热门城市 cell
//  Created by gouyz on 2019/7/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let hotCityCell = "hotCityCell"

class FSHotCityCell: UITableViewCell {

    var didSelectItemBlock:((_ index: Int) -> Void)?
    /// 当前选择区域
    var areaModel:FSCityListModel?
    /// 填充数据
    var dataModels : [FSCityListModel]?{
        didSet{
            if dataModels != nil {

                collectionView.reloadData()
            }
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
//            make.height.equalTo((kScreenWidth - 4 * kMargin)/3.0 * 1.6 + kMargin)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        /// 头像宽度
        let imgWidth = (kScreenWidth - 8 * kMargin)/3.0
        //设置cell的大小
        layout.itemSize = CGSize(width: imgWidth, height: 30)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = kMargin
        //每行之间最小的间距
        layout.minimumLineSpacing = kMargin
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        collView.isScrollEnabled = false
        
        collView.register(FSCityAreaCell.self, forCellWithReuseIdentifier: hotCityCell)
        
        return collView
    }()
}

extension FSHotCityCell : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataModels == nil {
            return 0
        }
        return (dataModels?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hotCityCell, for: indexPath) as! FSCityAreaCell
        
        let model = dataModels![indexPath.row]
        cell.nameLab.text = model.name
        if areaModel != nil {
            if model.id == areaModel?.id{
                cell.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xd4d4d4)
            }else{
                cell.backgroundColor = kGrayBackGroundColor
            }
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
