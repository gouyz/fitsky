//
//  FSFollowAndFenSiVC.swift
//  fitsky
//  关注与粉丝
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView

class FSFollowAndFenSiVC: GYZWhiteNavBaseVC {

    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var titles: [String] = [String]()
    var userId: String = ""
    var sex: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var sexStr = "她"
        if sex == "1" {
            sexStr = "他"
        }
        titles.append(sexStr + "的关注")
        titles.append(sexStr + "的粉丝")
        
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        /// 将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.contentScrollView = listContainerView.scrollView
    }
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
        var y: CGFloat = 0
        if #available(iOS 11.0, *) {
            y = kTitleAndStateHeight
        }
        let segView = JXSegmentedView(frame: CGRect(x: 0, y: y, width: kScreenWidth, height: kTitleHeight))
        segView.delegate = self
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    /// 导航栏View
    lazy var listContainerView: JXSegmentedListContainerView = {
        let listView: JXSegmentedListContainerView = JXSegmentedListContainerView.init(dataSource: self)
        listView.frame = CGRect(x: 0, y: self.segmentedView.bottomY, width: kScreenWidth, height: kScreenHeight - self.segmentedView.bottomY)
        
        return listView
    }()
    
}

extension FSFollowAndFenSiVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
extension FSFollowAndFenSiVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = FSFollowAndFenSiListVC()
        vc.naviController = navigationController
        vc.typeIndex = index
        vc.userId = self.userId
        return vc
    }
}
