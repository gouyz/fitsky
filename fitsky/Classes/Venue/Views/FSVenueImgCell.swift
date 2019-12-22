//
//  FSVenueImgCell.swift
//  fitsky
//
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let venueImgCell = "venueImgCell"

class FSVenueImgCell: UITableViewCell {

    var didSelectItemBlock:((_ index: Int) -> Void)?
    /// 填充数据
    var dataModels : [String]?{
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
        contentView.addSubview(lineView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(lineView.snp.top).offset(-kMargin)
            make.height.equalTo(100)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(klineWidth)
            make.bottom.equalTo(contentView)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: 100, height: 100)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = kMargin
        //每行之间最小的间距
        layout.minimumLineSpacing = kMargin
        layout.scrollDirection = .horizontal
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        collView.showsVerticalScrollIndicator = false
        collView.showsHorizontalScrollIndicator = false
        
        collView.register(FSPersonHomeAblumCell.self, forCellWithReuseIdentifier: venueImgCell)
        
        return collView
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}

extension FSVenueImgCell : UICollectionViewDataSource,UICollectionViewDelegate{
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: venueImgCell, for: indexPath) as! FSPersonHomeAblumCell
    
        cell.iconView.kf.setImage(with: URL.init(string: dataModels![indexPath.row]))
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if didSelectItemBlock != nil {
            didSelectItemBlock!(indexPath.row)
        }
    }
}
