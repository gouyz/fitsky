//
//  FSFindCircleVC.swift
//  fitsky
//  发现社圈
//  Created by gouyz on 2020/2/23.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let findCircleCell = "findCircleCell"
private let findCircleHeader = "findCircleHeader"

class FSFindCircleVC: GYZWhiteNavBaseVC {
    
    /// 搜索 内容
    var searchContent: String = ""
    var isSearch: Bool = false
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    var dataList:[FSIMCircleModel] = [FSIMCircleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "发现社圈"
        self.view.backgroundColor = kWhiteColor
        
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(kTitleHeight)
        }
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(kMargin)
            make.left.right.bottom.equalTo(self.view)
        }
        
        requestFindCircleList()
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSFindCircleCell.classForCoder(), forCellReuseIdentifier: findCircleCell)
        table.register(LHSGeneralHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: findCircleHeader)
        
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
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索社圈"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        search.backgroundImage = UIImage.init()
    
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        //弹出键盘
        //        search.becomeFirstResponder()
        
        return search
    }()
    ///获取发现社圈数据
    func requestFindCircleList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        if searchContent.isEmpty {
            isSearch = false
        }
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Circle/Circle/index"
        var paramDic: [String:Any] = ["p":currPage]
        if isSearch {
            method = "Circle/Circle/search"
            paramDic["keyword"] = searchContent
        }
        
        GYZNetWork.requestNetwork(method,parameters: paramDic,  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSIMCircleModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无社圈信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.searchBar)!)
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
                    weakSelf?.requestFindCircleList()
                })
            }
            weakSelf?.view.bringSubviewToFront((weakSelf?.searchBar)!)
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        currPage = 1
        requestFindCircleList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestFindCircleList()
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
    /// 申请社圈
    func goApplyCircle(circleId: String){
        let vc = FSJoinIMCircleVC()
        vc.circleId = circleId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 聊天
    func goChat(index: Int){
        let vc = FSChatVC()
        vc.targetId = dataList[index].id!
        vc.conversationType = .ConversationType_GROUP
        vc.userName = dataList[index].name!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSFindCircleVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.isSearch = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        dataList.removeAll()
        tableView.reloadData()
        refresh()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.isSearch = false
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        dataList.removeAll()
        tableView.reloadData()
        refresh()
    }
}
extension FSFindCircleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: findCircleCell) as! FSFindCircleCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearch {
            return UIView()
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: findCircleHeader) as! LHSGeneralHeaderView
        
        headerView.nameLab.textColor = kOrangeFontColor
        headerView.nameLab.font = UIFont.boldSystemFont(ofSize: 14.0)
        headerView.nameLab.text = "猜你喜欢"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataList[indexPath.row].is_join == "1" {
            goChat(index: indexPath.row)
        }else{
            goApplyCircle(circleId: dataList[indexPath.row].id!)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isSearch {
            return 30
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
