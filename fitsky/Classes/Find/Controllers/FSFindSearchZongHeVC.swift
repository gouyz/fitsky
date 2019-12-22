//
//  FSFindSearchZongHeVC.swift
//  fitsky
//  发现 综合搜索
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

private let searchZongHeNewsCell = "searchZongHeNewsCell"
private let searchZongHeCourseCell = "searchZongHeCourseCell"
private let searchZongHeFoodCell = "searchZongHeFoodCell"
private let searchZongHeQiCaiCell = "searchZongHeQiCaiCell"
private let searchZongHeWorksCell = "searchZongHeWorksCell"
private let searchZongHeHeader = "searchZongHeHeader"

class FSFindSearchZongHeVC: GYZWhiteNavBaseVC {
    
    var didSelectItemBlock:((_ index: Int) -> Void)?
    
    weak var naviController: UINavigationController?
    /// 搜索 内容
    var searchContent: String = ""
    
    let titleArr: [String] = ["资讯","课程","菜谱","器材","作品"]
    
    var dataModel: FSFindSearchZongHeModel?
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataList:[FSSquareHotModel] = [FSSquareHotModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestZongHeSearchData()
        requestListDatas()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = 125
        // 设置行高为自动适配
        table.rowHeight = UITableView.automaticDimension
        
        table.register(FSNewsListCell.classForCoder(), forCellReuseIdentifier: searchZongHeNewsCell)
        table.register(FSFindSupportCourseCell.classForCoder(), forCellReuseIdentifier: searchZongHeCourseCell)
        table.register(FSFoodMenuCategoryCell.classForCoder(), forCellReuseIdentifier: searchZongHeFoodCell)
        table.register(FSFindQiCaiCell.classForCoder(), forCellReuseIdentifier: searchZongHeQiCaiCell)
        table.register(FSFindZongHeWorksCell.classForCoder(), forCellReuseIdentifier: searchZongHeWorksCell)
        table.register(FSTitleAndMoreHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: searchZongHeHeader)
        
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
    /// 查看更多
    @objc func onClickedMore(sender: UITapGestureRecognizer){
        let tag : Int = sender.view!.tag
        if didSelectItemBlock != nil {
            didSelectItemBlock!(tag + 1)
        }
    }
    
    ///综合搜索信息
    func requestZongHeSearchData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Home/Search/findComprehensiveSearch", parameters: ["keyword":searchContent],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = FSFindSearchZongHeModel.init(dict: data)
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///获取数据
    func requestListDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Dynamic/Dynamic/searchOpus",parameters: ["p":currPage,"keyword":searchContent],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
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
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
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
        requestListDatas()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestListDatas()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 作品详情
    func goWorksDetailVC(id: String){
        let vc = FSSquareFollowDetailVC()
        vc.dynamicId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 课程详情
    func goCourseDetailVC(id: String){
        let vc = FSFindCourseDetailVC()
        vc.courseId = id
        self.naviController?.pushViewController(vc, animated: true)
    }
    /// 菜谱详情
    func goCookBookDetailVC(index: Int){
        let vc = FSFoodMenuDetailVC()
        vc.cookBookId = (dataModel?.cookbooklList[index].id)!
        self.naviController?.pushViewController(vc, animated: true)
    }
}

extension FSFindSearchZongHeVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == titleArr.count - 1 {
            return 1
        }else{
            if dataModel != nil {
                if section == 0{
                    return (dataModel?.newslList.count)!
                }else if section == 1{
                    return (dataModel?.courselList.count)!
                }else if section == 2{
                    return (dataModel?.cookbooklList.count)!
                }
                else if section == 3{
                    return (dataModel?.instrumentlList.count)!
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {//资讯
            let cell = tableView.dequeueReusableCell(withIdentifier: searchZongHeNewsCell) as! FSNewsListCell
            
            if dataModel?.newslList.count > 0 {
                cell.dataModel = dataModel?.newslList[indexPath.row]
            }
            
            cell.lineView.isHidden = true
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {//课程
            let cell = tableView.dequeueReusableCell(withIdentifier: searchZongHeCourseCell) as! FSFindSupportCourseCell
            
            if dataModel?.courselList.count > 0 {
                cell.dataModel = dataModel?.courselList[indexPath.row]
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2 {//菜谱
            let cell = tableView.dequeueReusableCell(withIdentifier: searchZongHeFoodCell) as! FSFoodMenuCategoryCell
            
            cell.lineView.isHidden = true
            if dataModel?.cookbooklList.count > 0 {
                cell.dataModel = dataModel?.cookbooklList[indexPath.row]
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3 {//器材
            let cell = tableView.dequeueReusableCell(withIdentifier: searchZongHeQiCaiCell) as! FSFindQiCaiCell
            
            if dataModel?.instrumentlList.count > 0 {
                cell.dataModel = dataModel?.instrumentlList[indexPath.row]
            }
            
            cell.selectionStyle = .none
            return cell
        }else {//作品
            let cell = tableView.dequeueReusableCell(withIdentifier: searchZongHeWorksCell) as! FSFindZongHeWorksCell
            
            cell.dataModel = dataList
            cell.didSelectItemBlock = {[unowned self] (index) in
                self.goWorksDetailVC(id: self.dataList[index].id!)
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: searchZongHeHeader) as! FSTitleAndMoreHeaderView
        
        headerView.nameLab.text = titleArr[section]
        
        if section == titleArr.count - 1 {
            headerView.moreLab.isHidden = true
        }else{
            headerView.moreLab.isHidden = false
        }
        
        headerView.moreLab.tag = section
        headerView.moreLab.addOnClickListener(target: self, action: #selector(onClickedMore(sender:)))
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            goWorksDetailVC(id: (dataModel?.newslList[indexPath.row].id)!)
        }else if indexPath.section == 1{
            goCourseDetailVC(id: (dataModel?.courselList[indexPath.row].id)!)
        }else if indexPath.section == 2{
            goCookBookDetailVC(index: indexPath.row)
        }else if indexPath.section == 3{
            goCourseDetailVC(id: (dataModel?.instrumentlList[indexPath.row].id)!)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
extension FSFindSearchZongHeVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
    func listDidAppear() {
        
    }
}
