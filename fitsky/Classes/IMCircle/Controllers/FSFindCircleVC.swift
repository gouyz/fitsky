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

class FSFindCircleVC: GYZWhiteNavBaseVC {
    
    /// 搜索 内容
    var searchContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "发现社圈"
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSSelectTopicCell.classForCoder(), forCellReuseIdentifier: findCircleCell)
        
        //            weak var weakSelf = self
        //            ///添加下拉刷新
        //            GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
        //                weakSelf?.refresh()
        //            })
        //            ///添加上拉加载更多
        //            GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //                weakSelf?.loadMore()
        //            })
        
        return table
    }()
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索社圈"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
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
    ///获取广场 话题搜索数据
//    func requestTalkSearchList(){
//        if !GYZTool.checkNetWork() {
//            return
//        }
//
//        weak var weakSelf = self
//        showLoadingView()
//
//        GYZNetWork.requestNetwork("Dynamic/Topic/search",parameters: ["p":currPage,"keyword": searchContent],  success: { (response) in
//
//            weakSelf?.closeRefresh()
//            weakSelf?.hiddenLoadingView()
//            GYZLog(response)
//
//            if response["result"].intValue == kQuestSuccessTag{//请求成功
//
//                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
//
//                guard let data = response["data"]["list"].array else { return }
//                for item in data{
//                    guard let itemInfo = item.dictionaryObject else { return }
//                    let model = FSTalkModel.init(dict: itemInfo)
//
//                    weakSelf?.dataList.append(model)
//                }
//                weakSelf?.tableView.reloadData()
//                if weakSelf?.dataList.count > 0{
//                    weakSelf?.hiddenEmptyView()
//                }else{
//                    ///显示空页面
//                    weakSelf?.showEmptyView(content:"暂无话题信息")
//                }
//
//            }else{
//                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
//            }
//
//        }, failture: { (error) in
//            weakSelf?.closeRefresh()
//            weakSelf?.hiddenLoadingView()
//            GYZLog(error)
//
//            //第一次加载失败，显示加载错误页面
//            if weakSelf?.currPage == 1{
//                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
//                    weakSelf?.hiddenEmptyView()
//                    weakSelf?.requestTalkSearchList()
//                })
//            }
//
//        })
//    }
//    // MARK: - 上拉加载更多/下拉刷新
//    /// 下拉刷新
//    func refresh(){
//        if currPage == lastPage {
//            GYZTool.resetNoMoreData(scorllView: tableView)
//        }
//        currPage = 1
//        requestTalkSearchList()
//    }
//
//    /// 上拉加载更多
//    func loadMore(){
//        if currPage == lastPage {
//            GYZTool.noMoreData(scorllView: tableView)
//            return
//        }
//        currPage += 1
//        requestTalkSearchList()
//    }
//
//    /// 关闭上拉/下拉刷新
//    func closeRefresh(){
//        if tableView.mj_header.isRefreshing{//下拉刷新
//            dataList.removeAll()
//            GYZTool.endRefresh(scorllView: tableView)
//        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
//            GYZTool.endLoadMore(scorllView: tableView)
//        }
//    }
}
extension FSFindCircleVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        
    }
    
}
extension FSFindCircleVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
        //            return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: findCircleCell) as! FSSelectTopicCell
        
        
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
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
