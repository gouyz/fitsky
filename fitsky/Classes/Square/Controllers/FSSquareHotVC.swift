//
//  FSSquareHotVC.swift
//  fitsky
//  热门/关注
//  Created by gouyz on 2019/8/19.
//  Copyright © 2019 gyz. All rights reserved.

import UIKit
import JXPagingView
import MBProgressHUD

private let squareHotCell = "squareHotCell"

class FSSquareHotVC: GYZWhiteNavBaseVC {

    let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    weak var naviController: UINavigationController?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var dataList: [FSSquareHotModel] = [FSSquareHotModel]()
    /// 是否刷新数据
    var isRefresh: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
//        let itemWidth = floor((kScreenWidth - kMargin * 3)/2)
        let layout = CHTCollectionViewWaterfallLayout()
        //设置cell的大小
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.73 + 90)
        layout.sectionInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.alwaysBounceHorizontal = false
        collView.backgroundColor = kBackgroundColor
        
        collView.register(FSSquareHotCell.classForCoder(), forCellWithReuseIdentifier: squareHotCell)
        
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
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: collectionView)
        }
        currPage = 1
        requestDynamicHotList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: collectionView)
            return
        }
        currPage += 1
        requestDynamicHotList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if collectionView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: collectionView)
        }else if collectionView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: collectionView)
        }
    }
    ///获取广场 热门数据
    func requestDynamicHotList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/hot",parameters: ["p":currPage],  success: { (response) in
            
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
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无动态消息")
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
                    weakSelf?.requestDynamicHotList()
                })
            }
            
        })
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
    
    /// 图片动态详情
    func goImgDynamicDetail(dynamicId: String){
        let vc = FSHotDynamicVC()
        vc.dynamicId = dynamicId
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
extension FSSquareHotVC: UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: squareHotCell, for: indexPath) as! FSSquareHotCell
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        cell.zanBtn.tag = indexPath.row
        cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
        cell.userHeaderImgView.tag = indexPath.row
        cell.userHeaderImgView.addOnClickListener(target: self, action: #selector(onClickUserImg(sender:)))
        
        return cell
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        let type = model.type
        if type == "1" || type == "2" || type == "3" {//动态
            goImgDynamicDetail(dynamicId: model.id!)
        }else if type == "4" || type == "5" || type == "6" {//作品
            goWorksDetailVC(id: model.id!)
        }
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}
extension FSSquareHotVC: JXPagingViewListViewDelegate {
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
        
        if isRefresh || userDefaults.bool(forKey: kIsPublishDynamicTagKey) {
            
            // 发布动态返回需要刷新数据
            userDefaults.set(false, forKey: kIsPublishDynamicTagKey)
            isRefresh = false
            dataList.removeAll()
            collectionView.reloadData()
            refresh()
        }
    }
}
