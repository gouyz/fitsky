//
//  FSFoodGuideVC.swift
//  fitsky
//  饮食指南
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import PYSearch

private let foodGuideHeader = "foodGuideHeader"
private let foodGuideCell = "foodGuideCell"

class FSFoodGuideVC: GYZWhiteNavBaseVC {
    let searchHistoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "PYSearchhistoriesFind.plist" // the path of search record cached
    
    var dataList: [FSFoodGuideModel] = [FSFoodGuideModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "饮食指南"
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_seach")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickRightBtn))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestFoodGuidesList()
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
        
        table.register(FSFoodGuideCell.classForCoder(), forCellReuseIdentifier: foodGuideCell)
        table.register(FSTitleAndMoreHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: foodGuideHeader)
        
        return table
    }()
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
    
    ///获取饮食指南数据
    func requestFoodGuidesList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Cookbook/Cookbook/foodGuides",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSFoodGuideModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    /// 菜谱详情
    func goDetailVC(cookId: String){
        let vc = FSFoodMenuDetailVC()
        vc.cookBookId = cookId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 分类详情
    func goCategoryVC(index: Int){
        let model = dataList[index]
        let vc = FSFoodMenuCategoryVC()
        vc.paramDic = [model.category_key!:model.id!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FSFoodGuideVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: foodGuideCell) as! FSFoodGuideCell
        
        cell.dataModel = dataList[indexPath.section].cookBookList
        cell.didSelectItemBlock = {[unowned self] (index) in
            if index == self.dataList[indexPath.section].cookBookList.count - 1 {
                self.goCategoryVC(index: indexPath.section)
            }else{
                let cookId: String = self.dataList[indexPath.section].cookBookList[index].id!
                self.goDetailVC(cookId: cookId)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: foodGuideHeader) as! FSTitleAndMoreHeaderView
        
        headerView.nameLab.textColor = kBlackFontColor
        headerView.nameLab.font = UIFont.boldSystemFont(ofSize: 18)
        headerView.nameLab.text = dataList[section].name
        headerView.moreLab.isHidden = true
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
