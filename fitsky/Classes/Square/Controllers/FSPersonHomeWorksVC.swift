//
//  FSPersonHomeWorksVC.swift
//  fitsky
//  个人主页 作品
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import MBProgressHUD

private let personHomeWorksCell = "personHomeWorksCell"
private let personHomeWorksHeader = "personHomeWorksHeader"

class FSPersonHomeWorksVC: GYZWhiteNavBaseVC {
    
    var userId: String = ""
    var dataList: [FSWorksCategoryModel] = [FSWorksCategoryModel]()
    /// 是否是自己
//    var isMySelf: Bool = false
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestWorksList()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 50)
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kWhiteColor
        
        collView.register(FSPersonHomeWorksCell.classForCoder(), forCellWithReuseIdentifier: personHomeWorksCell)
        collView.register(FSPersonHomeAblumHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: personHomeWorksHeader)
        
        return collView
    }()
    
    ///获取作品类别数据
    func requestWorksList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/opusCategory",parameters: ["friend_id":userId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSWorksCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.collectionView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无作品分类信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestWorksList()
            })
            
        })
    }
    /// 作品详情
    func goWorksDetail(cId: String){
        let vc = FSAllWorksVC()
        vc.userId = self.userId
//        vc.isMySelf = self.isMySelf
        vc.categoryId = cId
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSPersonHomeWorksVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personHomeWorksCell, for: indexPath) as! FSPersonHomeWorksCell
        
        cell.dataModel = dataList[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader{
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: personHomeWorksHeader, for: indexPath) as! FSPersonHomeAblumHeaderView
        }
        
        return reusableview
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goWorksDetail(cId: dataList[indexPath.row].id!)
    }
    //MARK: UICollectionViewDelegateFlowLayout
    // 返回HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: kScreenWidth, height: klineWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSPersonHomeWorksVC: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return collectionView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
}
