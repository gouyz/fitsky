//
//  FSIMCircleAllMemberVC.swift
//  fitsky
//  全部成员
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

private let IMCircleAllMemberCell = "IMCircleAllMemberCell"

class FSIMCircleAllMemberVC: GYZWhiteNavBaseVC {
    
    var isDel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "全部成员"
        self.view.backgroundColor = kWhiteColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    var rightBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("删除", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.setTitleColor(kBlueFontColor, for: .selected)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return rightBtn
    }()
    var cancleBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("取消", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickCancleBtn), for: .touchUpInside)
        
        return rightBtn
    }()
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(FSIMCircleAllMemberCell.classForCoder(), forCellReuseIdentifier: IMCircleAllMemberCell)
        
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
    /// 删除
    @objc func onClickRightBtn(){
        if !isDel {
            isDel = true
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancleBtn)
            rightBtn.isSelected = isDel
        }else{
            // 删除
        }
        tableView.reloadData()
    }
    
    /// 取消
    @objc func onClickCancleBtn(){
        isDel = false
        rightBtn.isSelected = isDel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: (isWhiteBack ? "icon_back_white" : "icon_back_black"))?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        tableView.reloadData()
    }
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
extension FSIMCircleAllMemberVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
        //            return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IMCircleAllMemberCell) as! FSIMCircleAllMemberCell
        if indexPath.row == 0 {
            cell.managerImgView.isHidden = false
        }else{
            cell.managerImgView.isHidden = true
        }
        
        cell.followLab.isHidden = isDel
        cell.checkImgView.isHidden = !isDel
        
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
        return 84
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
