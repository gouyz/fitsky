//
//  FSIMCircleMemberCell.swift
//  fitsky
//
//  Created by gouyz on 2020/3/6.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let IMCircleMemberIconCell = "IMCircleMemberIconCell"
private let IMCircleMemberRightCell = "IMCircleMemberRightCell"

class FSIMCircleMemberCell: UITableViewCell {
    
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
            make.top.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(lineView.snp.top)
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
        layout.itemSize = CGSize(width: 60, height: 60)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = klineWidth
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        collView.showsVerticalScrollIndicator = false
        collView.showsHorizontalScrollIndicator = false
        
        collView.register(FSIMCircleMemberIconCell.self, forCellWithReuseIdentifier: IMCircleMemberIconCell)
        collView.register(FSIMCircleMemberRightCell.self, forCellWithReuseIdentifier: IMCircleMemberRightCell)
        
        return collView
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}

extension FSIMCircleMemberCell : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 9 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMCircleMemberRightCell, for: indexPath) as! FSIMCircleMemberRightCell
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMCircleMemberIconCell, for: indexPath) as! FSIMCircleMemberIconCell
            
            //            cell.iconView.kf.setImage(with: URL.init(string: dataModels![indexPath.row]))
            
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if didSelectItemBlock != nil {
            didSelectItemBlock!(indexPath.row)
        }
    }
}
