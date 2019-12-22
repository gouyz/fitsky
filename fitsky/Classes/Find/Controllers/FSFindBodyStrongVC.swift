//
//  FSFindBodyStrongVC.swift
//  fitsky
//  部位强化
//  Created by gouyz on 2019/10/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import MBProgressHUD

class FSFindBodyStrongVC: GYZWhiteNavBaseVC {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    /// 分类
    var catrgoryList: [FSCompainCategoryModel] = [FSCompainCategoryModel]()
    var catrgoryNameList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "部位强化"
        
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
        segmentedViewDataSource.titles = catrgoryNameList
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
    ///获取部位强化分类数据
    func requestCategoryList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Course/Course/strengthenCategory",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCompainCategoryModel.init(dict: itemInfo)
                    
                    weakSelf?.catrgoryList.append(model)
                    weakSelf?.catrgoryNameList.append(model.name!)
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
        if catrgoryList.count > 0{
            //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
            segmentedViewDataSource.titles = catrgoryNameList
            //reloadData(selectedIndex:)一定要调用
            segmentedViewDataSource.reloadData(selectedIndex: 0)
            
            segmentedView.defaultSelectedIndex = 0
            segmentedView.reloadData()
            
            listContainerView.defaultSelectedIndex = 0
            listContainerView.reloadData()
        }
    }
    
}
extension FSFindBodyStrongVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FSBodyStrongListVC()
        vc.naviController = self.navigationController
        vc.categoryId = catrgoryList[index].id!
        return vc
    }
}

extension FSFindBodyStrongVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
