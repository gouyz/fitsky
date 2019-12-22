//
//  FSFindCourseListVC.swift
//  fitsky
//  发现 运动 课程专题 按分类数据
//  Created by gouyz on 2019/10/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

private let findCourseListCell = "findCourseListCell"

class FSFindCourseListVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var categoryId: String = ""
    
    var dataList:[FSFindCourseModel] = [FSFindCourseModel]()
    
    var categoryList:[FSFindCourseCategoryModel] = [FSFindCourseCategoryModel]()
    /// 请求参数
    var paramDic:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dropMenuView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(dropMenuView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        paramDic["category_id"] = categoryId
        
        requestCourseList()
    }
    
    lazy var dropMenuView: DOPDropDownMenu = {
        let menu = DOPDropDownMenu.init(origin: CGPoint.init(x: 0, y: 0), andHeight: kTitleHeight)
        menu?.indicatorColor = kHeightGaryFontColor
        menu?.textColor = kHeightGaryFontColor
        menu?.textSelectedColor = kOrangeFontColor
        menu?.separatorColor = kGrayLineColor
        menu?.separatorHeighPercent = 0
        menu?.delegate = self
        menu?.dataSource = self
        
        return menu!
    }()
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kBackgroundColor
        
        
        table.register(FSFindSupportCourseCell.classForCoder(), forCellReuseIdentifier: findCourseListCell)
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
    ///获取发现课程数据
    func requestCourseList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        paramDic["p"] = currPage
        
        GYZNetWork.requestNetwork("Course/Course/index",parameters: paramDic,  success: { (response) in
            
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
                    weakSelf?.showEmptyView(content:"暂无课程信息")
                    weakSelf?.view.bringSubviewToFront((weakSelf?.dropMenuView)!)
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
                weakSelf?.view.bringSubviewToFront((weakSelf?.dropMenuView)!)
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
        requestCourseList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestCourseList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 课程详情
    func goDetailVC(index: Int){
        let vc = FSFindCourseDetailVC()
        vc.courseId = dataList[index].id!
        self.naviController?.pushViewController(vc, animated: true)
    }
}
extension FSFindCourseListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: findCourseListCell) as! FSFindSupportCourseCell
        
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
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSFindCourseListVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
        //        if userDefaults.bool(forKey: kIsPublishDynamicTagKey) {
        //
        //            // 发布动态返回需要刷新数据
        //            userDefaults.set(false, forKey: kIsPublishDynamicTagKey)
        //            dataList.removeAll()
        //            tableView.reloadData()
        //            refresh()
        //        }
    }
}
extension FSFindCourseListVC: DOPDropDownMenuDelegate,DOPDropDownMenuDataSource{
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        
        return categoryList[column].childList.count
    }
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return categoryList.count
    }
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        
        return categoryList[indexPath.column].childList[indexPath.row].name!
    }
    
    func menu(_ menu: DOPDropDownMenu!, titleForHeaderInColumn column: Int) -> String! {
        
        return categoryList[column].name!
    }
    /**
    *  点击代理，点击了第column 第row 或者item项，如果 item >=0
    */
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        let model = categoryList[indexPath.column].childList[indexPath.row]
        paramDic[model.attr_key!] = model.id!
        
        refresh()
    }
}
