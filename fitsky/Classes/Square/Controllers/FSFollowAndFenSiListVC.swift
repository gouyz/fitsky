//
//  FSFollowAndFenSiListVC.swift
//  fitsky
//  关注、粉丝
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

private let followAndFenSiListCell = "followAndFenSiListCell"

class FSFollowAndFenSiListVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    var typeIndex: Int = 0
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var userId: String = ""
    var dataList: [FSUserInfoModel] = [FSUserInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestUserList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        
        table.register(FSSearchUserCell.classForCoder(), forCellReuseIdentifier: followAndFenSiListCell)
        
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
    ///获取粉丝、关注用户数据
    func requestUserList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Member/MemberFriend/follow"
        if typeIndex == 1 {// 他的粉丝
            method = "Member/MemberFriend/fans"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["p":currPage,"friend_id": userId],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSUserInfoModel.init(dict: itemInfo)
                    
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
                    weakSelf?.requestUserList()
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
        currPage = 1
        requestUserList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestUserList()
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
        if model.type == "3" {
            let vc = FSVenueHomeVC()
            vc.userId = model.id!
            self.naviController?.pushViewController(vc, animated: true)
        }else{
            let vc = FSPersonHomeVC()
            vc.userId = model.id!
            vc.userType = model.type!
            self.naviController?.pushViewController(vc, animated: true)
        }
    }
}
extension FSFollowAndFenSiListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: followAndFenSiListCell) as! FSSearchUserCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.followLab.tag = indexPath.row
        cell.followLab.addOnClickListener(target: self, action: #selector(onClickedFollow(sender:)))
        
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
        goUserHome(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
extension FSFollowAndFenSiListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    
    func listDidAppear() {
//        print("listDidAppear:\(typeString)")
    }
    
    func listDidDisappear() {
//        print("listDidDisappear:\(typeString)")
    }
}
