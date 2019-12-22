//
//  FSFindZongHeWorksCell.swift
//  fitsky
//  搜索发现 作品 cell 测
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

private let findZongHeWorksCell = "findZongHeWorksCell"

class FSFindZongHeWorksCell: UITableViewCell {
    let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
    
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    /// 填充数据
    var dataModel : [FSSquareHotModel]?{
        didSet{
            if dataModel != nil {
                
                self.collectionView.reloadData()
                self.collectionView.layoutIfNeeded()
                let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
                
                self.collectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(height)
                }
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
//            make.left.equalTo(kMargin)
//            make.right.equalTo(-kMargin)
            make.top.left.right.equalTo(contentView)
            make.bottom.equalTo(-kMargin)
            make.height.equalTo(itemWidth + 84)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kWhiteColor
        collView.isScrollEnabled = false
        
        collView.register(FSSquareHotCell.classForCoder(), forCellWithReuseIdentifier: findZongHeWorksCell)
        
        return collView
    }()
}

extension FSFindZongHeWorksCell : UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataModel?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: findZongHeWorksCell, for: indexPath) as! FSSquareHotCell
        
        cell.playImgView.isHidden = true
        cell.tuiJianImgView.isHidden = true
        cell.dataModel = dataModel?[indexPath.row]
        
        return cell
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemBlock != nil {
            didSelectItemBlock!(indexPath.row)
        }
    }
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let model = (dataModel?[indexPath.row])!
            var height: CGFloat = 0
            if model.thumb!.isEmpty {
                height = 0
            }else{
                height = itemWidth * CGFloat(GYZTool.getThumbScale(url: model.material!, thumbUrl: model.thumb!))
            }
        
        return CGSize(width: itemWidth, height: height + 84)
    }
    
}
