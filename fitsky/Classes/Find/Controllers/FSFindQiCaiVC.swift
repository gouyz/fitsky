//
//  FSFindQiCaiVC.swift
//  fitsky
//  固定器械、自由器械
//  Created by gouyz on 2019/10/13.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import JXSegmentedView
import PYSearch

private let findQiCaiCell = "findQiCaiCell"

class FSFindQiCaiVC: GYZWhiteNavBaseVC {
    
    let searchHistoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "PYSearchhistoriesFind.plist" // the path of search record cached
    
    weak var naviController: UINavigationController?
    /// 搜索 内容
    var searchContent: String = ""
    var isSearch: Bool = false
    
    /// 1固定器械、2自由器械
    var type: String = "1"
    
    var dataList:[FSFindCourseModel] = [FSFindCourseModel]()
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isSearch {
            self.navigationItem.title = (type == "1" ? "固定器械": "自由器械")
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_seach")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickRightBtn))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestQiCaiList()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kBackgroundColor
        
        table.register(FSFindQiCaiCell.classForCoder(), forCellReuseIdentifier: findQiCaiCell)
        
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
    
    ///获取器材数据
    func requestQiCaiList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "Course/Instrument/fixed"
        if type == "2" {
            method = "Course/Instrument/free"
        }
        var paramDic:[String:Any] = ["p":currPage]
        if isSearch {
            paramDic["keyword"] = searchContent
            method = "Course/Instrument/search"
            
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
                    let model = FSFindCourseModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无器材信息")
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
        requestQiCaiList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestQiCaiList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 器材详情
    func goDetailVC(index: Int){
        let vc = FSFindQiCaiDetailVC()
        vc.qiCaiId = dataList[index].id!
        if isSearch {
            self.naviController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 搜索
    @objc func onClickRightBtn(){
        let searchVC: PYSearchViewController = PYSearchViewController.init(hotSearches: [], searchBarPlaceholder: "搜索资讯、课程、菜谱、器材") { (searchViewController, searchBar, searchText) in
            
            let searchVC = FSFindSearchVC()
            searchVC.searchContent = searchText!
            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        let searchNav = GYZBaseNavigationVC(rootViewController:searchVC)
        //
        searchVC.cancelButton.setTitleColor(kHeightGaryFontColor, for: .normal)
        
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            searchVC.searchBar.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            searchVC.searchBarBackgroundColor = kGrayBackGroundColor
        }
        //显示输入光标
        searchVC.searchBar.tintColor = kHeightGaryFontColor
        searchVC.searchHistoriesCachePath = searchHistoryPath
        self.present(searchNav, animated: true, completion: nil)
    }
}

extension FSFindQiCaiVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: findQiCaiCell) as! FSFindQiCaiCell
        
        cell.dataModel = dataList[indexPath.row]
        
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
        goDetailVC(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
/// 搜索时用到
extension FSFindQiCaiVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
    }
}
