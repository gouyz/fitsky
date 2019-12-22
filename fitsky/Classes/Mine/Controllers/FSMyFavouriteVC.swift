//
//  FSMyFavouriteVC.swift
//  fitsky
//  收藏
//  Created by gouyz on 2019/11/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let myFavouriteCell = "myFavouriteCell"

class FSMyFavouriteVC: GYZWhiteNavBaseVC {
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    /// 是否需要重新h加载数据
    var isReloadData: Bool = true
    var dataList: [FSSquareHotModel] = [FSSquareHotModel]()
    
    
    /// 是否刷新数据
    var isRefresh: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的收藏"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestDynamicList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSZongHeCell.classForCoder(), forCellReuseIdentifier: myFavouriteCell)
        
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
    ///获取我的收藏数据
    func requestDynamicList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Member/MemberCollect/dynamic",parameters: ["p":currPage],  success: { (response) in
            
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
                    weakSelf?.showEmptyView(content:"暂无收藏信息")
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
        requestDynamicList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestDynamicList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 关注
    @objc func onClickedFollow(sender:UITapGestureRecognizer){
//        let tag = sender.view?.tag
        //            requestFollow(index: tag!)
    }
    ///关注（取消关注）
    func requestFollow(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/MemberFollow/add", parameters: ["friend_id":dataList[index].member_id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].friend_type = data["statue"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 收藏
    @objc func onClickedFavourite(sender:UIButton){
        let tag = sender.tag
        requestFavourite(index: tag)
    }
    // 点赞
    @objc func onClickedZan(sender:UIButton){
        let tag = sender.tag
        requestZan(index: tag)
    }
    ///点赞（取消点赞）
    func requestZan(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        let model = dataList[index]
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberLike/add", parameters: ["content_id":model.id!,"type":(model.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].like_count = data["count"].stringValue
                weakSelf?.dataList[index].moreModel?.is_like = data["status"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///收藏（取消收藏）
    func requestFavourite(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        let model = dataList[index]
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberCollect/add", parameters: ["content_id":model.id!,"type":(model.more_type)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                weakSelf?.dataList[index].collect_count = data["count"].stringValue
                weakSelf?.dataList[index].moreModel?.is_collect = data["status"].stringValue
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 评论
    @objc func onClickedShowConment(sender: UIButton){
        
    }
    
    /// 置顶、删除
    @objc func onClickedDynamicOperator(sender: UIButton){
        let tag = sender.tag
        let model = dataList[tag]
        if model.friend_type == "3" { // 自己的是删除+置顶 别人的就只有一个举报
            let titleArr : [String] = ["删除"]
            //            if model.is_top == "1" {
            //                titleArr.append("取消置顶")
            //            }else{
            //                titleArr.append("置顶")
            //            }
            let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: titleArr)
            actionSheet.cancleTextColor = kWhiteColor
            actionSheet.cancleTextFont = k15Font
            actionSheet.itemTextColor = kGaryFontColor
            actionSheet.itemTextFont = k15Font
            actionSheet.didSelectIndex = {[weak self] (index,title) in
                
                if index == 0{//删除
                    self?.showDeleteAlert(index: tag)
                }
                //                else if index == 1{/// 置顶/取消置顶
                //                    self?.requestTopDynamic(index: tag!)
                //                }
            }
        }else{
            showComplain(tag: tag)
        }
        
    }
    /// 举报
    func showComplain(tag: Int){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["举报"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kWhiteColor
        actionSheet.itemTextFont = k15Font
        actionSheet.itemBgColor = UIColor.UIColorFromRGB(valueRGB: 0x777777)
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0{//举报
                self?.goComplainVC(index: tag)
            }
        }
    }
    /// 评论投诉
    func goComplainVC(index: Int){
        let model = dataList[index]
        let vc = FSComplainVC()
        vc.type = model.more_type!
        vc.contentId = model.id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 删除提示
    func showDeleteAlert(index: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确定要删除此动态吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (tag) in
            
            if tag != cancelIndex{
                weakSelf?.requestDeleteDynamic(index: index)
            }
        }
    }
    /// 删除动态
    func requestDeleteDynamic(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/Publish/delete", parameters: ["id":dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList.remove(at: index)
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无消息")
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 置顶/取消置顶
    //    func requestTopDynamic(index: Int){
    //        if !GYZTool.checkNetWork() {
    //            return
    //        }
    //
    //        let isTop:String = dataList[index].is_top == "1" ? "0" : "1"
    //        weak var weakSelf = self
    //        createHUD(message: "加载中...")
    //        GYZNetWork.requestNetwork("Dynamic/Publish/top", parameters: ["id":dataList[index].id!,"type": isTop],  success: { (response) in
    //
    //            weakSelf?.hud?.hide(animated: true)
    //            GYZLog(response)
    //            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
    //            if response["result"].intValue == kQuestSuccessTag{//请求成功
    //                weakSelf?.dataList.removeAll()
    //                weakSelf?.tableView.reloadData()
    //                weakSelf?.refresh()
    //            }
    //
    //        }, failture: { (error) in
    //            weakSelf?.hud?.hide(animated: true)
    //            GYZLog(error)
    //        })
    //    }
    /// 动态详情
    func goDynamicDetailVC(id: String){
        let vc = FSHotDynamicVC()
        vc.dynamicId = id
        vc.resultBlock = {[unowned self] (isRefresh,dynamicId) in
            
            if isRefresh {
                self.isRefresh = false
                self.requestDynamicById(dynamicId: dynamicId)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
        tableView.reloadData()
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 用户主页
    @objc func onClickUserImg(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        /// 会员类型（1-普通 2-达人 3-场馆）
        if model.member_type == "3" {
            let vc = FSVenueHomeVC()
            vc.userId = model.member_id!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.member_id!
            vc.userType = model.member_type!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// 查看大图
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls, isShowDel: false, isShowAction: true))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    
    func goDetailVC(index:Int){
        let model = dataList[index]
        let type = model.type
        if type == "1" || type == "2" || type == "3" {//动态
            goDynamicDetailVC(id: model.id!)
        }else if type == "4" || type == "5" || type == "6" {//作品
            goWorksDetailVC(id: model.id!)
        }
    }
}
extension FSMyFavouriteVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myFavouriteCell) as! FSZongHeCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.downImgView.tag = indexPath.row
        cell.downImgView.addTarget(self, action: #selector(onClickedDynamicOperator(sender:)), for: .touchUpInside)
        
        cell.followLab.tag = indexPath.row
        cell.followLab.addOnClickListener(target: self, action: #selector(onClickedFollow(sender:)))
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(onClickedFavourite(sender:)), for: .touchUpInside)
        cell.conmentBtn.tag = indexPath.row
        cell.conmentBtn.addTarget(self, action: #selector(onClickedShowConment(sender:)), for: .touchUpInside)
        cell.zanBtn.tag = indexPath.row
        cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
        
        cell.imgViews.onClickedImgDetailsBlock = {[unowned self](index,urls) in
            if self.dataList[indexPath.row].video!.isEmpty {
                self.goBigPhotos(index: index, urls: self.dataList[indexPath.row].materialOrgionUrlList)
            }else{
                self.goDetailVC(index: indexPath.row)
            }
        }
        cell.userImgView.tag = indexPath.row
        cell.userImgView.addOnClickListener(target: self, action: #selector(onClickUserImg(sender:)))
        
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
        self.goDetailVC(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

