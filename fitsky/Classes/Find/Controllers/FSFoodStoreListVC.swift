//
//  FSFoodStoreListVC.swift
//  fitsky
//  食材库 列表
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import TTGTagCollectionView
import JXSegmentedView

private let foodStoreListCell = "foodStoreListCell"

class FSFoodStoreListVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 二级id
    var categoryId: String = ""
    /// 父级id
    var parentId: String = ""
    /// 上一次选中的 tag index
    var lastSelectedIndex: UInt = 0
    var categoryList:[FSCookBookCategoryModel] = [FSCookBookCategoryModel]()
    var categoryNameList:[String] = [String]()
    
    var dataList:[FSFoodModel] = [FSFoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for model in categoryList {
            categoryNameList.append(model.name!)
        }
        
        view.addSubview(categoryTagsView)
        view.addSubview(lineView)
        view.addSubview(tableView)
        
        categoryTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(54)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(categoryTagsView)
            make.top.equalTo(categoryTagsView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        if categoryList.count > 0 {
            parentId = categoryList[0].parent_id!
            categoryId = categoryList[0].id!
            categoryTagsView.addTags(categoryNameList)
            categoryTagsView.setTagAt(0, selected: true)
            categoryTagsView.reload()
        }
        
        requestFoodList()
    }
    
    /// 所有分类
    lazy var categoryTagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k15Font
        config?.textColor = kGaryFontColor
        config?.selectedTextColor = kWhiteColor
        config?.borderColor = kWhiteColor
        config?.selectedBorderColor = kOrangeFontColor
        config?.backgroundColor = kWhiteColor
        config?.selectedBackgroundColor = kOrangeFontColor
        config?.cornerRadius = 10
        config?.selectedCornerRadius = 10
        view.scrollDirection = .horizontal
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        //        config?.extraSpace = CGSize.init(width: 16, height: 10)
        view.numberOfLines = 1
        view.contentInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        view.showsHorizontalScrollIndicator = false
        view.horizontalSpacing = 15
        view.backgroundColor = kWhiteColor
        view.delegate = self
        
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kBackgroundColor
        
        table.register(FSFoodStoreListCell.classForCoder(), forCellReuseIdentifier: foodStoreListCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return table
    }()
    ///获取食材款数据
    func requestFoodList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Cookbook/Food/index",parameters: ["category_id_1":parentId,"category_id_2":categoryId,"p":currPage],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSFoodModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无食材信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.categoryTagsView)!)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            if weakSelf?.currPage == 1{
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.refresh()
                })
                weakSelf?.view.bringSubviewToFront((weakSelf?.categoryTagsView)!)
            }
            
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        dataList.removeAll()
        tableView.reloadData()
        currPage = 1
        requestFoodList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestFoodList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 详情
    func goDetailVC(index: Int){
        let vc = FSFoodStoreDetailVC()
        vc.foodId = dataList[index].id!
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSFoodStoreListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: foodStoreListCell) as! FSFoodStoreListCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goDetailVC(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSFoodStoreListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
    }
}
extension FSFoodStoreListVC: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        //上一次选中 有值，并且跟本次选中的 index 不同
        if self.lastSelectedIndex != -1 && self.lastSelectedIndex != index {
            //取消上一次选中
            self.categoryTagsView.setTagAt(self.lastSelectedIndex, selected: false)
        }
        self.lastSelectedIndex = index
        let x: Int = Int.init(self.lastSelectedIndex)
        self.parentId = self.categoryList[x].parent_id!
        self.categoryId = self.categoryList[x].id!
        self.refresh()
    }
}
