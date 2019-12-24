//
//  FSVenueServiceVC.swift
//  fitsky
//  场馆主页 服务
//  Created by gouyz on 2019/9/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import MBProgressHUD
import TTGTagCollectionView

private let venueServiceCell = "venueServiceCell"

class FSVenueServiceVC: GYZWhiteNavBaseVC {

    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var userId: String = ""
    var status: String = ""
    ///
    var categoryId: String = ""
    /// 上一次选中的 tag index
    var lastSelectedIndex: UInt = 0
    var dataList:[FSVenueServiceModel] = [FSVenueServiceModel]()
    var userModel: FSSquareUserModel?
    
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
        
        if let userInfo = userModel {
            categoryTagsView.addTags(userInfo.storeData?.catrgoryNameList)
            if userInfo.storeData?.catrgoryNameList.count > 0{
                categoryTagsView.setTagAt(0, selected: true)
                categoryId = (userInfo.storeData?.catrgoryList[0].id)!
            }
            categoryTagsView.reload()
            
            status = userInfo.formData?.status ?? ""
        }
        
        if status == "1" {//已认证
            requestServiceList()
        }else{
            ///显示空页面
            showEmptyView(content:"该场馆还未申请认证，此功能未可使用哦~")
        }
    }

    /// 所有分类
    lazy var categoryTagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = UIFont.boldSystemFont(ofSize: 15)
        config?.textColor = kHeightGaryFontColor
        config?.selectedTextColor = kWhiteColor
        config?.borderColor = UIColor.UIColorFromRGB(valueRGB: 0xe9e9e9)
        config?.selectedBorderColor = kOrangeFontColor
        config?.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xe9e9e9)
        config?.selectedBackgroundColor = kOrangeFontColor
        config?.cornerRadius = kCornerRadius
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        view.scrollDirection = .horizontal
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
        
        table.register(FSVenueServiceCell.classForCoder(), forCellReuseIdentifier: venueServiceCell)
        
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
    ///获取场馆 服务数据
    func requestServiceList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Store/Goods/goods",parameters: ["p":currPage,"category_id": categoryId,"friend_id": userId],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSVenueServiceModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无服务信息")
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
                    weakSelf?.requestServiceList()
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
        requestServiceList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestServiceList()
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
    
    func goDetailVC(goodsId: String){
        let vc = FSServiceGoodsDetailVC()
        vc.goodsId = goodsId
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSVenueServiceVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: venueServiceCell) as! FSVenueServiceCell
        
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
        goDetailVC(goodsId:dataList[indexPath.row].id!)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
extension FSVenueServiceVC: JXPagingViewListViewDelegate {
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
extension FSVenueServiceVC: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        //上一次选中 有值，并且跟本次选中的 index 不同
        if self.lastSelectedIndex != -1 && self.lastSelectedIndex != index {
            //取消上一次选中
            self.categoryTagsView.setTagAt(self.lastSelectedIndex, selected: false)
        }
        self.lastSelectedIndex = index
        self.categoryId = (self.userModel?.storeData?.catrgoryList[Int(index)].id)!
        self.dataList.removeAll()
        self.refresh()
    }
}
