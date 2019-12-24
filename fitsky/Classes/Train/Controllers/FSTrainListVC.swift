//
//  FSTrainListVC.swift
//  fitsky
//  训练营 列表
//  Created by gouyz on 2019/10/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD
import PYSearch


private let trainListCell = "trainListCell"
private let trainCourseListCell = "trainCourseListCell"
private let trainListHeader = "trainListHeader"
private let trainListEmptyFooter = "trainListEmptyFooter"

private let trainCustomPopupMenuCell = "trainCustomPopupMenuCell"

private let searchHistoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "PYSearchhistoriesTrain.plist" // the path of search record cached

class FSTrainListVC: GYZWhiteNavBaseVC {
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    weak var naviController: UINavigationController?
    
    let sortTitles: [String] = ["热度","距离"]
    var sortIndex: Int = 1
    var sortCourseIndex: Int = 0
    /// 判断是场馆还是课程
    var isVenue: Bool = true
    /// k类型
    var type: Int = 0
    let typeTitles: [String] = ["健身馆","瑜伽馆","武术馆","休闲馆"]
    /// 轮播图
    var bannerList: [FSBannerModel] = [FSBannerModel]()
    var bannerImgURLList: [String] = [String]()
    // 场馆列表
    var dataVenueList: [FSTrainVenueModel] = [FSTrainVenueModel]()
    /// 课程列表
    var dataCourseList:[FSVenueServiceModel] = [FSVenueServiceModel]()
    
    // 热门搜索
    var hotSearchList:[FSCompainCategoryModel] = [FSCompainCategoryModel]()
    var hotSearchNameList:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
        }
        tableView.tableHeaderView = headerView
        
        headerView.onClickedOperatorBlock = {[unowned self] (index) in
            if index == 101{// 场馆
                if !self.isVenue {
                    self.isVenue = true
                    self.changeBtnState()
                }
            }else if index == 102{// 课程
                if self.isVenue {
                    self.isVenue = false
                    self.changeBtnState()
                }
            }else if index == 103{// 搜索
                self.goSearchVC()
            }
        }
        headerView.adsImgView.didSelectedItem = {[unowned self] (index) in
            self.dealAds(index: index)
        }
        
        headerView.venueBtn.setTitle(typeTitles[type], for: .normal)
        requestBannerList()
        self.changeBtnState()
        requestHotSearchData()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 110
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSTrainVenueCell.classForCoder(), forCellReuseIdentifier: trainListCell)
        table.register(FSAllConmentHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: trainListHeader)
        table.register(FSTrainCourseCell.classForCoder(), forCellReuseIdentifier: trainCourseListCell)
        table.register(GYZEmptyFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: trainListEmptyFooter)
        
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
    lazy var headerView: FSTrainHeaderView = FSTrainHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: (kScreenWidth - 120)*300/750*1.2 + 80))
    
    ///获取轮播数据
    func requestBannerList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var method: String = "Activity/Banner/fitness"
        if type == 1 {//瑜伽
            method = "Activity/Banner/yoga"
        }else if type == 2 {//武术
            method = "Activity/Banner/wushu"
        }else if type == 3 {//休闲
            method = "Activity/Banner/arder"
        }
        
        GYZNetWork.requestNetwork(method,parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSBannerModel.init(dict: itemInfo)
                    
                    weakSelf?.bannerList.append(model)
                    weakSelf?.bannerImgURLList.append(model.thumb!)
                }
                weakSelf?.headerView.adsImgView.setUrlsGroup((weakSelf?.bannerImgURLList)!)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    /// 改变按钮状态
    func changeBtnState(){
        if isVenue {
            headerView.venueBtn.backgroundColor = kBlueFontColor
            headerView.venueBtn.setTitleColor(kWhiteColor, for: .normal)
            headerView.courseBtn.backgroundColor = kGrayLineColor
            headerView.courseBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        }else{
            headerView.courseBtn.backgroundColor = kBlueFontColor
            headerView.courseBtn.setTitleColor(kWhiteColor, for: .normal)
            headerView.venueBtn.backgroundColor = kGrayLineColor
            headerView.venueBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        }
        requestData()
    }
    ///获取场馆数据
    func requestVenueList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Store/Store/fitness"
        if type == 1 {//瑜伽
            method = "Store/Store/yoga"
        }else if type == 2 {//武术
            method = "Store/Store/wushu"
        }else if type == 3 {//休闲
            method = "Store/Store/arder"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["p":currPage,"orderby":sortIndex + 1,"lng":userDefaults.string(forKey: CURRlongitude) ?? "","lat":userDefaults.string(forKey: CURRlatitude) ?? ""],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSTrainVenueModel.init(dict: itemInfo)
                    
                    weakSelf?.dataVenueList.append(model)
                }
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
        })
    }
    ///获取课程数据
    func requestCourseList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Store/Goods/fitness"
        if type == 1 {//瑜伽
            method = "Store/Goods/yoga"
        }else if type == 2 {//武术
            method = "Store/Goods/wushu"
        }else if type == 3 {//休闲
            method = "Store/Goods/arder"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["p":currPage,"orderby":sortCourseIndex + 1],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSVenueServiceModel.init(dict: itemInfo)
                    
                    weakSelf?.dataCourseList.append(model)
                }
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        requestData()
    }
    
    func requestData(){
        if isVenue {
            dataVenueList.removeAll()
            tableView.reloadData()
            currPage = 1
            requestVenueList()
        }else{
            dataCourseList.removeAll()
            tableView.reloadData()
            currPage = 1
            requestCourseList()
        }
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        
        if isVenue {
            requestVenueList()
        }else{
            requestCourseList()
        }
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    ///训练营热门搜索
    func requestHotSearchData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Store/Store/hotKey", parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["hot"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.hotSearchNameList.append(model.name!)
                    weakSelf?.hotSearchList.append(model)
                }
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    func goSearchVC(){
        let searchVC: PYSearchViewController = PYSearchViewController.init(hotSearches: hotSearchNameList, searchBarPlaceholder: "搜索训练营") { (searchViewController, searchBar, searchText) in
            
            let searchVC = FSTrainSearchListVC()
            searchVC.searchContent = searchText!
            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        let searchNav = GYZBaseNavigationVC(rootViewController:searchVC)
        //
        searchVC.cancelButton.setTitleColor(kHeightGaryFontColor, for: .normal)
        
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            searchVC.searchBar.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            searchVC.searchBarBackgroundColor = kGrayBackGroundColor
        }
        //显示输入光标
        searchVC.searchBar.tintColor = kHeightGaryFontColor
        searchVC.searchHistoriesCachePath = searchHistoryPath
        self.naviController?.present(searchNav, animated: true, completion: nil)
    }
    
    // 弹出排序
    @objc func onClickedSort(sender:UITapGestureRecognizer){
        YBPopupMenu.showRely(on: sender.view, titles: sortTitles, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.textColor = kGaryFontColor
            popupMenu?.isShadowShowing = false
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: trainCustomPopupMenuCell)
        }
    }
    func dealAds(index: Int){
        let model = bannerList[index]
        /// 类型（1-作品 2-活动 3-场馆 4-服务课程 5-课程 6-器械 7-饮食 8-外链）
        let type: String = model.type!
        
        if type != "8" {
            if  model.content_id == "0" {
                return
            }
        }
        switch type {
        case "1":
            goWorksDetailVC(id: model.content_id!)
        case "2":
            goActivityDetailVC(id: model.content_id!)
        case "3":
            goVenueHomeVC(id: model.content_id!)
        case "4":
            goServiceCourseDetailVC(id: model.content_id!)
        case "5":
            goFindCourseDetailVC(id: model.content_id!)
        case "6":
            goQiCaiDetailVC(id: model.content_id!)
        case "7":
            goFoodDetailVC(id: model.content_id!)
        case "8":
            goWebVC(url: model.link!, title: model.title!)
        default:
            break
        }
    }
    
    /// 作品详情
    func goWorksDetailVC(id: String){
        let vc = FSSquareFollowDetailVC()
        vc.dynamicId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    ///活动详情
    func goActivityDetailVC(id: String){
        let vc = FSActivityDetailVC()
        vc.activityId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    ///场馆
    func goVenueHomeVC(id: String){
        let vc = FSVenueHomeVC()
        vc.userId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 服务课程
    func goServiceCourseDetailVC(id: String){
        let vc = FSServiceGoodsDetailVC()
        vc.goodsId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 发现课程详情
    func goFindCourseDetailVC(id: String){
        let vc = FSFindCourseDetailVC()
        vc.courseId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 器材详情
    func goQiCaiDetailVC(id: String){
        let vc = FSFindQiCaiDetailVC()
        vc.qiCaiId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 菜谱详情
    func goFoodDetailVC(id: String){
        let vc = FSFoodMenuDetailVC()
        vc.cookBookId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// webView
    func goWebVC(url: String,title: String){
        let vc = JSMWebViewVC()
        vc.webTitle = title
        vc.url = url
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSTrainListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isVenue {
            return dataVenueList.count
        }
        return dataCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isVenue {
            let cell = tableView.dequeueReusableCell(withIdentifier: trainListCell) as! FSTrainVenueCell
            cell.dataModel = dataVenueList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: trainCourseListCell) as! FSTrainCourseCell
            
            cell.dataModel = dataCourseList[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: trainListHeader) as! FSAllConmentHeaderView
        headerView.sortImgView.addOnClickListener(target: self, action: #selector(onClickedSort(sender:)))
        
        if isVenue {
            if sortIndex == 0 {
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
            }else{
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_distance")
            }
        }else{
            if sortCourseIndex == 0 {
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
            }else{
                headerView.sortImgView.image = UIImage.init(named: "app_search_by_distance")
            }
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: trainListEmptyFooter) as! GYZEmptyFooterView
        if isVenue {
            if dataVenueList.count == 0 {
                footerView.contentLab.text = "暂无场馆信息"
                
                return footerView
            }
        }else{
            if dataCourseList.count == 0 {
                footerView.contentLab.text = "暂无课程信息"
                
                return footerView
            }
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isVenue {
            if dataVenueList[indexPath.row].status == "1" {//认证场馆进详情页
                goVenueHomeVC(id: dataVenueList[indexPath.row].id!)
            }
        }else{
            goServiceCourseDetailVC(id: dataCourseList[indexPath.row].id!)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isVenue {
            if dataVenueList.count == 0 {
                
                return 120
            }
        }else{
            if dataCourseList.count == 0 {
                return 120
            }
        }
        return 0.00001
    }
}
extension FSTrainListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
//        if userDefaults.bool(forKey: kIsPublishDynamicTagKey) {
//
//            // 发布动态返回需要刷新数据
//            userDefaults.set(false, forKey: kIsPublishDynamicTagKey)
//            dataList.removeAll()
//            tableView.reloadData()
//            refresh()
//        }
    }
}
extension FSTrainListVC: YBPopupMenuDelegate{
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        
        if isVenue {
            sortIndex = index
        }else{
            sortCourseIndex = index
        }
        refresh()
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        
        let cell = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: trainCustomPopupMenuCell) as! GYZLabelCenterCell
        cell.nameLab.text = sortTitles[index]
        if index == sortIndex {
            cell.nameLab.textColor = kBlueFontColor
        }else{
            cell.nameLab.textColor = kHeightGaryFontColor
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
