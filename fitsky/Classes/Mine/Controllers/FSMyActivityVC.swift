//
//  FSMyActivityVC.swift
//  fitsky
//  我的活动
//  Created by gouyz on 2019/10/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView

class FSMyActivityVC: GYZWhiteNavBaseVC {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let titles = ["进行中", "已结束"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的活动"
        
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
extension FSMyActivityVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FSMyActivityListVC()
        vc.naviController = self.navigationController
        vc.type = "\(index)"
        return vc
    }
}

extension FSMyActivityVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
