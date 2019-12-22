//
//  FSMyCourseOrderVC.swift
//  fitsky
//  课程订单
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView

class FSMyCourseOrderVC: GYZWhiteNavBaseVC {
    
    weak var naviController: UINavigationController?
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let titles = ["全部","待支付", "待使用", "已使用"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(segmentedView)
        self.view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
//            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(kTitleHeight)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segmentedView.snp.bottom)
        }
        
        segmentedView.contentScrollView = listContainerView.scrollView
        
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
        segmentedViewDataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = kOrangeFontColor
        
        let segView = JXSegmentedView()
        segView.delegate = self
        segView.backgroundColor = kBackgroundColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    
    
}
extension FSMyCourseOrderVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FSMyCourseOrderListVC()
        vc.naviController = self.naviController
        vc.type = index
        return vc
    }
}

extension FSMyCourseOrderVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
extension FSMyCourseOrderVC: JXSegmentedListContainerViewListDelegate {
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
