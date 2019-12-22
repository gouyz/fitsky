//
//  FSSquareTopicVC.swift
//  fitsky
//  广场 话题
//  Created by gouyz on 2019/9/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import MBProgressHUD
import TTGTagCollectionView

private let squareTopicCell = "squareTopicCell"

class FSSquareTopicVC: GYZWhiteNavBaseVC {
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    ///
    var categoryId: String = ""
    /// 上一次选中的 tag index
    var lastSelectedIndex: UInt = 0
    var dataList:[FSTalkModel] = [FSTalkModel]()
    /// 分类
    var catrgoryList: [FSCompainCategoryModel] = [FSCompainCategoryModel]()
    var catrgoryNameList: [String] = [String]()
    
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(categoryTagsView)
        view.addSubview(tableView)
        
        categoryTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(54)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTagsView.snp.bottom)
            make.left.right.bottom.equalTo(view)
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(view)
//            }else{
//                make.top.equalTo(kTitleAndStateHeight)
//            }
        }
        
        requestTalkCategoryList()
    }
    
    /// 所有分类
    lazy var categoryTagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k15Font
        config?.textColor = kHeightGaryFontColor
        config?.selectedTextColor = kWhiteColor
        config?.borderColor = kGrayBackGroundColor
        config?.selectedBorderColor = kOrangeFontColor
        config?.backgroundColor = kGrayBackGroundColor
        config?.selectedBackgroundColor = kOrangeFontColor
        config?.cornerRadius = kCornerRadius
        view.scrollDirection = .horizontal
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
//        config?.extraSpace = CGSize.init(width: 16, height: 10)
        view.numberOfLines = 1
        view.contentInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        view.showsHorizontalScrollIndicator = false
        view.horizontalSpacing = 15
        view.backgroundColor = kBackgroundColor
        view.delegate = self
        
        return view
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSSearchTalkCell.classForCoder(), forCellReuseIdentifier: squareTopicCell)
        
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
    ///获取广场 话题分类数据
    func requestTalkCategoryList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Topic/category",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.catrgoryList.append(model)
                    weakSelf?.catrgoryNameList.append(model.name!)
                }
                weakSelf?.dealData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    func dealData(){
        if catrgoryList.count > 0{
            categoryTagsView.addTags(catrgoryNameList)
            categoryTagsView.setTagAt(0, selected: true)
            categoryTagsView.reload()
            categoryId = catrgoryList[0].id!
        }
        requestTalkList()
    }
    ///获取广场 话题数据
    func requestTalkList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Dynamic/Topic/index",parameters: ["p":currPage,"category_id": categoryId],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSTalkModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无话题信息")
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
                    weakSelf?.requestTalkList()
                })
            }
            weakSelf?.view.bringSubviewToFront((weakSelf?.categoryTagsView)!)
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestTalkList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestTalkList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 详情
    func goDetailVC(index:Int){
        let vc = FSTopicDetailVC()
        vc.topicId = dataList[index].id!
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSSquareTopicVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: squareTopicCell) as! FSSearchTalkCell
        
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
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSSquareTopicVC: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
}
extension FSSquareTopicVC: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        //上一次选中 有值，并且跟本次选中的 index 不同
        if self.lastSelectedIndex != -1 && self.lastSelectedIndex != index {
            //取消上一次选中
            self.categoryTagsView.setTagAt(self.lastSelectedIndex, selected: false)
        }
        self.lastSelectedIndex = index
        self.categoryId = self.catrgoryList[Int(index)].id!
        self.dataList.removeAll()
        self.refresh()
    }
}
