//
//  FSTopicActiveListVC.swift
//  fitsky
//  活跃度排名
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let topicActiveListCell = "topicActiveListCell"
private let topicActiveListHeader = "topicActiveListHeader"

class FSTopicActiveListVC: GYZWhiteNavBaseVC {
    
    var topicId: String = ""
    /// 当前活跃度
    var currActive: String = "0"
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataList:[FSTopicActiveModel] = [FSTopicActiveModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "活跃度排名"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestCurrentActive()
        requestTalkActiveList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSTopicActiveListCell.classForCoder(), forCellReuseIdentifier: topicActiveListCell)
        table.register(FSTopicActiveHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: topicActiveListHeader)
        
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
    ///当前活跃度
    func requestCurrentActive(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/myActivity", parameters: ["id":topicId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.currActive = response["data"]["topic_member"]["activity_count"].stringValue
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///获取话题 活跃数据
    func requestTalkActiveList(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        showLoadingView()

        GYZNetWork.requestNetwork("Dynamic/TopicPublish/activity",parameters: ["p":currPage,"id": topicId],  success: { (response) in

            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功

                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue

                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSTopicActiveModel.init(dict: itemInfo)

                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无信息")
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
                    weakSelf?.requestTalkActiveList()
                })
            }

        })
    }
//     MARK: - 上拉加载更多/下拉刷新
//    / 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestTalkActiveList()
    }

    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestTalkActiveList()
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
    
    /// 关注
    @objc func onClickedFollow(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        requestFollow(index: tag!)
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
    
    /// 用户主页
    func goUserHome(index: Int){
        let model = dataList[index]
        /// 会员类型（1-普通 2-达人 3-场馆）
        if model.member_type == "3" {
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
extension FSTopicActiveListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: topicActiveListCell) as! FSTopicActiveListCell
        
        cell.followLab.tag = indexPath.row
        cell.followLab.addOnClickListener(target: self, action: #selector(onClickedFollow(sender:)))
        
        cell.dataModel = dataList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: topicActiveListHeader) as! FSTopicActiveHeaderView
        headerView.contentLab.text = "您当前活跃度为：\(self.currActive)"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goUserHome(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
