//
//  FSNewsVC.swift
//  fitsky
//  资讯
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import MBProgressHUD

private let newsListCell = "newsListCell"
private let newsListHeader = "newsListHeader"

class FSNewsVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 轮播图
    var bannerList: [FSBannerModel] = [FSBannerModel]()
    var bannerImgURLList: [String] = [String]()
    /// 资讯list
    var dataList:[FSSquareHotModel] = [FSSquareHotModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        headerView.adsImgView.didSelectedItem = {[unowned self] (index) in
            self.dealAds(index: index)
        }
        
        requestBannerList()
        requestNewsList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 125
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSNewsListCell.classForCoder(), forCellReuseIdentifier: newsListCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: newsListHeader)
        
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
    lazy var headerView: FSNewsAdsHeaderView = FSNewsAdsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: (kScreenWidth - kMargin * 2) * 0.4 + kMargin))
    
    ///获取轮播数据
    func requestBannerList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Activity/Banner/news",parameters: nil,  success: { (response) in
            
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
    
    ///获取资讯数据
    func requestNewsList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/news",parameters: ["p":currPage],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSSquareHotModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无资讯信息")
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
        requestNewsList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestNewsList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
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
    /// 用户主页
    @objc func onClickUserImg(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        /// 会员类型（1-普通 2-达人 3-场馆）
        if model.member_type == "3" {
            let vc = FSVenueHomeVC()
            vc.userId = model.member_id!
            self.naviController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.member_id!
            vc.userType = model.member_type!
            self.naviController?.pushViewController(vc, animated: true)
        }
    }
}
extension FSNewsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsListCell) as! FSNewsListCell
        cell.dataModel = dataList[indexPath.row]
        
        cell.userHeaderImgView.tag = indexPath.row
        cell.userHeaderImgView.addOnClickListener(target: self, action: #selector(onClickUserImg(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: newsListHeader) as! LHSGeneralHeaderView
        
        headerView.nameLab.text = "热点分享"
        headerView.nameLab.font = k18Font
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goWorksDetailVC(id: dataList[indexPath.row].id!)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSNewsVC: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
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
