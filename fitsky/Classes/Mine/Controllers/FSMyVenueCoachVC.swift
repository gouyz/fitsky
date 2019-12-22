//
//  FSMyVenueCoachVC.swift
//  fitsky
//  我的场馆 教练
//  Created by gouyz on 2019/11/1.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myVenueCoachCell = "myVenueCoachCell"

class FSMyVenueCoachVC: GYZWhiteNavBaseVC {
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    
    var dataList: [FSCoachModel] = [FSCoachModel]()
    /// 选择的教练
    var selectServiceDic: [String: FSCoachModel] = [String: FSCoachModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "教练"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("停职", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestCoachList()
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
        
        table.register(FSMyVenueCoachCell.classForCoder(), forCellReuseIdentifier: myVenueCoachCell)
        
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
    /// 确认停职
    @objc func onClickRightBtn(){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["确认停职"])
        actionSheet.cancleTextColor = kWhiteColor
        actionSheet.cancleTextFont = k15Font
        actionSheet.itemTextColor = kGaryFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.didSelectIndex = {[unowned self] (index,title) in
            if index == 0{//确认停职
                self.requestStopServices()
            }
        }
    }
    
    ///获取教练数据
    func requestCoachList(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        showLoadingView()

        GYZNetWork.requestNetwork("Admin/StoreCoach/index",parameters: ["p":currPage],  success: { (response) in

            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)

            if response["result"].intValue == kQuestSuccessTag{//请求成功

                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue

                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCoachModel.init(dict: itemInfo)

                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无教练信息")
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
        requestCoachList()
    }

    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestCoachList()
    }

    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    /// 选择教练
    func changeSelectedCoach(index: Int){
        let model = dataList[index]
        if selectServiceDic.keys.contains(model.id!) {
            selectServiceDic.removeValue(forKey: model.id!)
        }else{
            selectServiceDic[model.id!] = model
        }
        tableView.reloadData()
    }
    
    //停职
    func requestStopServices(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        var ids: String = ""
        for item in selectServiceDic.keys {
            ids += item + ","
        }
        ids = ids.subString(start: 0, length: ids.count - 1)
        
        GYZNetWork.requestNetwork("Admin/StoreCoach/suspension", parameters: ["id":ids],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.refresh()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    // 编辑教练资料
    @objc func onClickUserHeader(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = FSMyCoachEditProfileVC()
        vc.coachId = dataList[tag!].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSMyVenueCoachVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myVenueCoachCell) as! FSMyVenueCoachCell
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        if selectServiceDic.keys.contains(model.id!) {
            cell.checkImgView.isHighlighted = true
        }else{
            cell.checkImgView.isHighlighted = false
        }
        cell.userImgView.tag = indexPath.row
        cell.userImgView.addOnClickListener(target: self, action: #selector(onClickUserHeader(sender:)))
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
        changeSelectedCoach(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
}
