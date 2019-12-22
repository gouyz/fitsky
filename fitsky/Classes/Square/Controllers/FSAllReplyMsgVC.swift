//
//  FSAllReplyMsgVC.swift
//  fitsky
//  全部回复
//  Created by gouyz on 2019/8/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let allReplyCell = "allReplyCell"
private let allReplyUserInfoCell = "allReplyUserInfoCell"

class FSAllReplyMsgVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool) -> Void)?

    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataModel: FSConmentDetailModel?
    var dataList: [FSReplyModel] = [FSReplyModel]()
    var conmentId: String = ""
    var isModify:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "全部回复"
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
        
        bottomView.desLab.text = "快来回复你的见解吧！"
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        requestConmentDetail()
        requestReplyList()
        
        bottomView.onClickedOperatorBlock = {[weak self] (index) in
            
            if index == 101 { // 评论
                self?.showConment()
            }else if index == 103 { // 点赞
                self?.requestZan(index: 0, type: "9")
            }
        }
        sendConmentView.sendBtn.addTarget(self, action: #selector(onClickedSend), for: .touchUpInside)
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
        
        table.register(FSAllReplyCell.classForCoder(), forCellReuseIdentifier: allReplyCell)
        table.register(FSAllReplyUserInfoCell.classForCoder(), forCellReuseIdentifier: allReplyUserInfoCell)
        
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
    ///评论详情
    func requestConmentDetail(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Comment/info", parameters: ["id":conmentId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSConmentDetailModel.init(dict: data)
                weakSelf?.dealData()
                weakSelf?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///获取回复列表数据
    func requestReplyList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/CommentReply/index",parameters: ["p":currPage,"comment_id": conmentId],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSReplyModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealData(){
        if dataModel != nil {
            if dataModel?.moreModel?.is_like == "1"{
                bottomView.zanImgView.isHighlighted = true
            }else {
                bottomView.zanImgView.isHighlighted = false
            }
        }
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestReplyList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestReplyList()
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
    /// 显示回复
    func showConment(){
        self.bottomView.isHidden = true
        self.sendConmentView.isHidden = false
        self.tableView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(-kBottomTabbarHeight)
        })
        //弹出键盘
        self.sendConmentView.contentTxtView.becomeFirstResponder()
    }
    // 回复
    @objc func onClickedReply(){
        showConment()
    }
    // 评论点赞
    @objc func onClickedZan(){
        requestZan(index: 0, type: "9")
    }
    // 评论回复点赞
    @objc func onClickedReplyZan(sender:UIButton){
        requestZan(index: sender.tag, type: "10")
    }
    ///点赞（取消点赞）
    func requestZan(index: Int,type: String){
        if !GYZTool.checkNetWork() {
            return
        }
    
        var id:String = conmentId
        if type == "10" {
            id = dataList[index].id!
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
                if type == "10"{
                   weakSelf?.dataList[index].moreModel?.is_like = data["status"].stringValue
                   weakSelf?.dataList[index].like_count = data["count"].stringValue
                }else{
                    weakSelf?.dataModel?.moreModel?.is_like = data["status"].stringValue
                    weakSelf?.dataModel?.countModel?.like_count = data["count"].stringValue
                    weakSelf?.dealData()
                }
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    // 发送评论或回复
    @objc func onClickedSend(){
        if sendConmentView.contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "发送内容不能为空")
            return
        }
        sendConmentView.contentTxtView.resignFirstResponder()
        requestSendReply()
    }
    ///发送回复
    func requestSendReply(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Comment/Reply/add", parameters: ["comment_id":conmentId,"content":sendConmentView.contentTxtView.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.isModify = true
                weakSelf?.sendConmentView.contentTxtView.text = ""
                weakSelf?.dealReplyData()
                weakSelf?.dataList.removeAll()
                weakSelf?.refresh()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 回复后处理
    func dealReplyData(){
        let count: Int = Int((dataModel?.countModel?.reply_count)!)! + 1
        dataModel?.countModel?.reply_count = "\(count)"
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    // 点击回复用户头像 用户主页
    @objc func onClickedUserHome(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        if model.from_member_type == "3"{ /// 场馆
            let vc = FSVenueHomeVC()
            vc.userId = model.from_member_id!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.from_member_id!
            vc.userType = model.from_member_type!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    // 点击评论用户头像 用户主页
    @objc func onClickedHome(){
        if let model = self.dataModel {
            if model.formData?.member_type == "3"{ /// 场馆
                let vc = FSVenueHomeVC()
                vc.userId = (model.formData?.member_id)!
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = FSPersonHomeVC()
                vc.userId = (model.formData?.member_id)!
                vc.userType = (model.formData?.member_type)!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
extension FSAllReplyMsgVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if dataModel == nil{
                return 0
            }
            return 1
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: allReplyUserInfoCell) as! FSAllReplyUserInfoCell
            cell.dataModel = self.dataModel
            
            cell.conmentBtn.addTarget(self, action: #selector(onClickedReply), for: .touchUpInside)
            cell.zanBtn.addTarget(self, action: #selector(onClickedZan), for: .touchUpInside)
            cell.userImgView.addOnClickListener(target: self, action: #selector(onClickedHome))
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: allReplyCell) as! FSAllReplyCell
            
            cell.dataModel = dataList[indexPath.row]
            cell.zanBtn.tag = indexPath.row
            cell.zanBtn.addTarget(self, action: #selector(onClickedReplyZan(sender:)), for: .touchUpInside)
            cell.userImgView.tag = indexPath.row
            cell.userImgView.addOnClickListener(target: self, action: #selector(onClickedUserHome(sender:)))
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
