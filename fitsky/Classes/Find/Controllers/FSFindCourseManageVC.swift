//
//  FSFindCourseManageVC.swift
//  fitsky
//  发现 运动 课程专题
//  Created by gouyz on 2019/10/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD
import PYSearch

class FSFindCourseManageVC: GYZWhiteNavBaseVC {
    let searchHistoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "PYSearchhistoriesFind.plist" // the path of search record cached
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var categoryList:[FSFindCourseCategoryModel] = [FSFindCourseCategoryModel]()
    var categoryNameList:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.title = "课程主题"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_icon_seach")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickRightBtn))
        
        self.view.addSubview(segmentedView)
        self.view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(kTitleHeight)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segmentedView.snp.bottom)
        }
        
        segmentedView.contentScrollView = listContainerView.scrollView
        requestCategoryList()
    }
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var segmentedView: JXSegmentedView = {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleNormalColor = kHeightGaryFontColor
        segmentedViewDataSource.titleSelectedColor = kOrangeFontColor
        segmentedViewDataSource.titles = categoryNameList
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = kOrangeFontColor
        
        let segView = JXSegmentedView()
        segView.delegate = self
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
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
    ///获取分类数据
    func requestCategoryList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Course/Course/category",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSFindCourseCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.categoryList.append(model)
                    weakSelf?.categoryNameList.append(model.name!)
                }
                weakSelf?.dealData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
            
        })
    }
    func dealData(){
        if categoryList.count > 0{
            //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
            segmentedViewDataSource.titles = categoryNameList
            //reloadData(selectedIndex:)一定要调用
            segmentedViewDataSource.reloadData(selectedIndex: 0)
            
            segmentedView.defaultSelectedIndex = 0
            segmentedView.reloadData()
            
            listContainerView.defaultSelectedIndex = 0
            listContainerView.reloadData()
        }
    }
    
}
extension FSFindCourseManageVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FSFindCourseListVC()
        vc.naviController = self.navigationController
        vc.categoryId = categoryList[index].id!
        vc.categoryList = categoryList[index].childList
        return vc
    }
}

extension FSFindCourseManageVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
