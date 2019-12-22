//
//  FSAllConmentVC.swift
//  fitsky
//  全部评论
//  Created by gouyz on 2019/8/25.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let allDynamicConmentCell = "allDynamicConmentCell"
private let allDynamicConmentHeader = "allDynamicConmentHeader"

private let customPopupMenuCell = "customPopupMenuCell"

class FSAllConmentVC: GYZWhiteNavBaseVC {

    let sortTitles: [String] = ["热度","时间"]
    var sortIndex: Int = 0
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool) -> Void)?
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataList: [FSConmentModel] = [FSConmentModel]()
    var contentId: String = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var type: String = ""
    /// 是否点赞
    var isLike: String = "0"
    var isModify:Bool = false
    /// 区分评论或回复，true评论，false回复
    var isReplyOrConment: Bool = true
    /// 要回复的评论索引
    var conmentIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 1.0
        self.navigationItem.title = "全部评论"
        view.addSubview(sendConmentView)
        sendConmentView.isHidden = true
        sendConmentView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        view.addSubview(bottomView)
        bottomView.favouriteImgView.isHidden = true
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(kTabBarHeight)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kTabBarHeight)
            make.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bottomView.onClickedOperatorBlock = {[weak self] (index) in
            
            if index == 101 { // 评论
                self?.isReplyOrConment = true
                self?.showConment()
            }else if index == 103 { // 点赞
                self?.requestZan(id: (self?.contentId)!, type: (self?.type)!)
            }
        }
        sendConmentView.sendBtn.addTarget(self, action: #selector(onClickedSend), for: .touchUpInside)
        dealData()
        requestConmentList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSAllConmentHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: allDynamicConmentHeader)
        table.register(FSConmentCell.classForCoder(), forCellReuseIdentifier: allDynamicConmentCell)
        
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
    /// 底部评论view
    lazy var bottomView: FSConmentBottomView = FSConmentBottomView()
    /// 发送评论view
    lazy var sendConmentView: FSConmentSendView = FSConmentSendView()
    
    override func clickedBackBtn() {
        super.clickedBackBtn()
        if resultBlock != nil {
            resultBlock!(isModify)
        }
    }
    func dealData(){
        if isLike == "1"{
            bottomView.zanImgView.isHighlighted = true
        }else {
            bottomView.zanImgView.isHighlighted = false
        }
    }
    ///获取评论数据
    func requestConmentList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Comment/Comment/index",parameters: ["p":currPage,"content_id": contentId,"type": type,"orderby": sortIndex + 1],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSConmentModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无评论信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.sendConmentView)!)
                    weakSelf?.view.bringSubviewToFront((weakSelf?.bottomView)!)
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
                    weakSelf?.requestConmentList()
                })
                weakSelf?.view.bringSubviewToFront((weakSelf?.sendConmentView)!)
                weakSelf?.view.bringSubviewToFront((weakSelf?.bottomView)!)
            }
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestConmentList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestConmentList()
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
    
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        bottomView.isHidden = false
        sendConmentView.isHidden = true
        self.tableView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-kTabBarHeight)
        }
        sendConmentView.contentTxtView.resignFirstResponder()
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /// 显示评论或回复
    func showConment(){
        self.bottomView.isHidden = true
        self.sendConmentView.isHidden = false
        self.tableView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(-kBottomTabbarHeight)
        })
        //弹出键盘
        self.sendConmentView.contentTxtView.becomeFirstResponder()
    }
    // 发送评论或回复
    @objc func onClickedSend(){
        if sendConmentView.contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "发送内容不能为空")
            return
        }
        sendConmentView.contentTxtView.resignFirstResponder()
        if isReplyOrConment {//发送评论
            requestSendConment()
        }else{//回复
            requestSendReply()
        }
    }
    
    ///发送评论
    func requestSendConment(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Publish/add", parameters: ["content_id":contentId,"content":sendConmentView.contentTxtView.text!,"type":type],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.sendConmentView.contentTxtView.text = ""
                weakSelf?.isModify = true
                weakSelf?.dataList.removeAll()
                weakSelf?.tableView.reloadData()
                weakSelf?.refresh()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///发送回复
    func requestSendReply(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Reply/add", parameters: ["comment_id":dataList[conmentIndex].id!,"content":sendConmentView.contentTxtView.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.sendConmentView.contentTxtView.text = ""
                weakSelf?.dealReplyData()
                weakSelf?.isModify = true
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 回复后处理
    func dealReplyData(){
        let count: Int = Int(dataList[conmentIndex].reply_count!)! + 1
        dataList[conmentIndex].reply_count = "\(count)"
        tableView.reloadData()
    }
    
    // 弹出排序
    @objc func onClickedSort(sender:UITapGestureRecognizer){
        YBPopupMenu.showRely(on: sender.view, titles: sortTitles, icons: nil, menuWidth: 170) { [weak self](popupMenu) in
            popupMenu?.delegate = self
            popupMenu?.isShadowShowing = false
            popupMenu?.tableView.register(GYZLabelCenterCell.classForCoder(), forCellReuseIdentifier: customPopupMenuCell)
        }
    }
    // 查看全部回复
    @objc func onClickedAllReply(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = FSAllReplyMsgVC()
        vc.conmentId = dataList[tag!].id!
        vc.resultBlock = {[weak self] (isRefresh) in
            if isRefresh {
                self?.isModify = isRefresh
                self?.dataList.removeAll()
                self?.tableView.reloadData()
                self?.refresh()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    // 回复/举报
    @objc func onClickedShowConment(sender:UIButton){
        let tag = sender.tag
        self.conmentIndex = tag
        
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["回复","举报"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[weak self] (index,title) in
            if index == 0 {//回复
                self?.isReplyOrConment = false
                self?.showConment()
            }else if index == 1{//评论举报
                self?.goComplainVC(type: "9", contentId: (self?.dataList[tag].id)!)
            }
        }
    }
    /// 评论投诉
    func goComplainVC(type: String,contentId: String){
        let vc = FSComplainVC()
        vc.type = type
        vc.contentId = contentId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 评论点赞
    @objc func onClickedZan(sender:UIButton){
        let tag = sender.tag
        conmentIndex = tag
        requestZan(id: dataList[conmentIndex].id!, type: "9")
    }
    ///点赞（取消点赞）
    func requestZan(id: String,type: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
        GYZNetWork.requestNetwork("Member/MemberLike/add", parameters: ["content_id":id,"type":type],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                let data = response["data"]
                if type == "9"{
                    weakSelf?.dataList[(weakSelf?.conmentIndex)!].like_count = data["count"].stringValue
                    weakSelf?.dataList[(weakSelf?.conmentIndex)!].moreModel?.is_like = data["status"].stringValue
                }else{
                    weakSelf?.isLike = data["status"].stringValue
                    weakSelf?.dealData()
                }
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    // 点击评论用户头像 用户主页
    @objc func onClickedUserHome(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        if model.member_type == "3"{ /// 场馆
            let vc = FSVenueHomeVC()
            vc.userId = model.member_id!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.member_id!
            vc.userType = model.member_type!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FSAllConmentVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: allDynamicConmentCell) as! FSConmentCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.replyLab.tag = indexPath.row
        cell.replyLab.addOnClickListener(target: self, action: #selector(onClickedAllReply(sender:)))
        cell.conmentBtn.tag = indexPath.row
        cell.conmentBtn.addTarget(self, action: #selector(onClickedShowConment(sender:)), for: .touchUpInside)
        cell.zanBtn.tag = indexPath.row
        cell.zanBtn.addTarget(self, action: #selector(onClickedZan(sender:)), for: .touchUpInside)
        
        cell.userImgView.tag = indexPath.row
        cell.userImgView.addOnClickListener(target: self, action: #selector(onClickedUserHome(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: allDynamicConmentHeader) as! FSAllConmentHeaderView
        headerView.sortImgView.addOnClickListener(target: self, action: #selector(onClickedSort(sender:)))
        
        if sortIndex == 0 {
            headerView.sortImgView.image = UIImage.init(named: "app_search_by_hot")
        }else{
            headerView.sortImgView.image = UIImage.init(named: "app_search_by_time")
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
extension FSAllConmentVC: YBPopupMenuDelegate{
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        sortIndex = index
        dataList.removeAll()
        tableView.reloadData()
        refresh()
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        
        let cell = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: customPopupMenuCell) as! GYZLabelCenterCell
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
