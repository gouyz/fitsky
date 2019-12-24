//
//  FSSupportVC.swift
//  fitsky
//  运动
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXPagingView
import MBProgressHUD

private let supportFindCell = "supportFindCell"
private let supportFindHeader = "supportFindHeader"
private let supportFindEmptyFooter = "supportFindHeader"

class FSSupportVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
    /// 1运动2美食3器材
    var type: String = "1"
    /// 是否刷新数据
    var isRefresh: Bool = true
    
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
        
        self.view.backgroundColor = kWhiteColor
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestBannerList()
        requestListDatas()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        layout.headerHeight = (kScreenWidth - kMargin * 2) * 0.4 + 120
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kBackgroundColor
        
        collView.register(FSSquareHotCell.classForCoder(), forCellWithReuseIdentifier: supportFindCell)
        collView.register(FSFindSupportHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supportFindHeader)
        collView.register(FSEmptyFooterReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: supportFindEmptyFooter)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: collView, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: collView, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return collView
    }()
    
    ///获取轮播数据
    func requestBannerList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var method: String = "Activity/Banner/sport"
        if type == "2" {
            method = "Activity/Banner/food"
        }else if type == "3" {
            method = "Activity/Banner/instrument"
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
                weakSelf?.collectionView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    
    ///获取数据
    func requestListDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        var method: String = "Dynamic/Dynamic/sport"
        if type == "2" {
            method = "Dynamic/Dynamic/food"
        }else if type == "3" {
            method = "Dynamic/Dynamic/instrument"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["p":currPage],  success: { (response) in
            
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
                weakSelf?.collectionView.reloadData()
                
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
            GYZTool.resetNoMoreData(scorllView: collectionView)
        }
        dataList.removeAll()
        collectionView.reloadData()
        currPage = 1
        requestListDatas()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: collectionView)
            return
        }
        currPage += 1
        requestListDatas()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if collectionView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: collectionView)
        }else if collectionView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: collectionView)
        }
    }
    
    /// 处理操作
    func dealOperator(index: Int){
        /// 1运动2美食3器材
        if type == "1" {
            if index == 101 {// 课程主题
                goFindCourse()
            }else if index == 102 {// 部位强化
                goFindBodyStrong()
            }
        }else if type == "2" {
            if index == 101 {// 饮食指南
                goFoodGuide()
            }else if index == 102 {// 菜谱分类
                goFoodMenu()
            }else if index == 103 {// 食材库
                goFoodStore()
            }
        }else{
            if index == 101 {// 固定机械
                goQiCaiVC(type: "1")
            }else if index == 102 {// 自由机械
                goQiCaiVC(type: "2")
            }
        }
    }
    // 课程主题
    func goFindCourse(){
        let vc = FSFindCourseManageVC()
        self.naviController?.pushViewController(vc, animated: true)
    }
    // 部位强化
    func goFindBodyStrong(){
        MBProgressHUD.showAutoDismissHUD(message: "暂未开放，敬请期待")
//        let vc = FSFindBodyStrongVC()
//        self.naviController?.pushViewController(vc, animated: true)
    }
    
    // 饮食指南
    func goFoodGuide(){
        let vc = FSFoodGuideVC()
        self.naviController?.pushViewController(vc, animated: true)
    }
    // 菜谱分类
    func goFoodMenu(){
        let vc = FSFoodMenuManagerVC()
        self.naviController?.pushViewController(vc, animated: true)
    }
    // 食材库
    func goFoodStore(){
        let vc = FSFoodStoreManagerVC()
        self.naviController?.pushViewController(vc, animated: true)
    }
    // 器材
    func goQiCaiVC(type: String){
        let vc = FSFindQiCaiVC()
        vc.type = type
        self.naviController?.pushViewController(vc, animated: true)
    }
    ///点赞（取消点赞）
    @objc func onClickedZan(sender:UIButton){
        let tag = sender.tag
        requestZan(index: tag)
    }
    ///点赞（取消点赞）
    func requestZan(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberLike/add", parameters: ["content_id":dataList[index].id!,"type":dataList[index].more_type!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].like_count = data["count"].stringValue
                weakSelf?.dataList[index].moreModel?.is_like = data["status"].stringValue
                weakSelf?.collectionView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
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
    /// 作品详情
    func goWorksDetailVC(id: String){
        let vc = FSSquareFollowDetailVC()
        vc.dynamicId = id
        vc.resultBlock = {[unowned self] (isRefresh,dynamicId) in
            
            if isRefresh {
                self.isRefresh = false
                self.requestDynamicById(dynamicId: dynamicId)
            }
        }
        self.naviController?.pushViewController(vc, animated: true)
    }
    ///单个动态
    func requestDynamicById(dynamicId: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/one", parameters: ["id":dynamicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dealDynamicChange(model: FSSquareHotModel.init(dict: data))
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealDynamicChange(model: FSSquareHotModel){
        for (index,item) in dataList.enumerated() {
            if item.id == model.id {
                dataList[index] = model
                break
            }
        }
        collectionView.reloadData()
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
extension FSSupportVC: UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportFindCell, for: indexPath) as! FSSquareHotCell
        
        cell.playImgView.isHidden = true
        cell.tuiJianImgView.isHidden = true
        
        cell.dataModel = dataList[indexPath.row]
        cell.zanBtn.tag = indexPath.row
        cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
        cell.userHeaderImgView.tag = indexPath.row
        cell.userHeaderImgView.addOnClickListener(target: self, action: #selector(onClickUserImg(sender:)))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader{
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supportFindHeader, for: indexPath) as! FSFindSupportHeaderView
            
            let headerView = reusableview as! FSFindSupportHeaderView
            
            headerView.adsImgView.setUrlsGroup(bannerImgURLList)
            
            if type == "1" {
                headerView.firstBtn.setTitle("课程主题", for: .normal)
                headerView.secondBtn.setTitle("部位强化", for: .normal)
                headerView.nameLab.text = "精彩分享"
            }else if type == "2" {
                headerView.firstBtn.setTitle("饮食指南", for: .normal)
                headerView.secondBtn.setTitle("菜谱分类", for: .normal)
                headerView.thirdBtn.setTitle("食材库", for: .normal)
                headerView.thirdBtn.isHidden = false
                headerView.nameLab.text = "新鲜分享"
            }else{
                headerView.firstBtn.setTitle("固定器械", for: .normal)
                headerView.secondBtn.setTitle("自由器械", for: .normal)
                headerView.nameLab.text = "花样分享"
            }
            
            headerView.adsImgView.didSelectedItem = {[unowned self] (index) in
                self.dealAds(index: index)
            }
            headerView.onClickedOperatorBlock = {[unowned self] (index) in
                self.dealOperator(index: index)
            }
        }else if kind == UICollectionView.elementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supportFindEmptyFooter, for: indexPath) as! FSEmptyFooterReusableView
            
            let footerView = reusableview as! FSEmptyFooterReusableView
            if dataList.count == 0 {
                footerView.contentLab.isHidden = false
                footerView.iconImgView.isHidden = false
            }else{
                footerView.contentLab.isHidden = true
                footerView.iconImgView.isHidden = true
            }

        }
        return reusableview
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goWorksDetailVC(id: dataList[indexPath.row].id!)
    }
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let model = dataList[indexPath.row]
        var height: CGFloat = 0
        if model.thumb!.isEmpty {
            height = 0
        }else{
            height = itemWidth * CGFloat(GYZTool.getThumbScale(url: model.material!, thumbUrl: model.thumb!))
        }
        
        return CGSize(width: itemWidth, height: height + 84)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        if dataList.count > 0 {
            return 0.000001
        }
        return 120
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSSupportVC: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return collectionView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
    func listDidAppear() {
        
//        if isRefresh || userDefaults.bool(forKey: kIsPublishDynamicTagKey) {
//            
//            // 发布动态返回需要刷新数据
//            userDefaults.set(false, forKey: kIsPublishDynamicTagKey)
//            isRefresh = false
//            dataList.removeAll()
//            collectionView.reloadData()
//            refresh()
//        }
    }
}
