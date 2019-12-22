//
//  FSFindSearchVC.swift
//  fitsky
//  发现 搜索
//  Created by gouyz on 2019/10/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView

class FSFindSearchVC: GYZWhiteNavBaseVC {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    let titles = ["综合", "资讯", "课程", "菜谱", "器材"]
    /// 搜索 内容
    var searchContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        self.view.addSubview(segmentedView)
        self.view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(kTitleAndStateHeight + 15)
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
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索资讯、菜谱、课程、器材"
        search.delegate = self
        //显示输入光标
        search.tintColor = kHeightGaryFontColor
        search.text = searchContent
        /// 搜索框背景色
        if #available(iOS 13.0, *){
            search.searchTextField.backgroundColor = kGrayBackGroundColor
        }else{
            if let textfiled = search.subviews.first?.subviews.last as? UITextField {
                textfiled.backgroundColor = kGrayBackGroundColor
            }
        }
        //弹出键盘
        //        search.becomeFirstResponder()
        
        return search
    }()
    func reloadData(index: Int) {
        //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
//        segmentedViewDataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: index)
        
        segmentedView.defaultSelectedIndex = index
        segmentedView.reloadData()
        
        listContainerView.defaultSelectedIndex = index
        listContainerView.reloadData()
    }
}
extension FSFindSearchVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedViewDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        if index == 1 {
            let vc = FSSearchNewsVC()
            vc.searchContent = self.searchContent
            vc.naviController = self.navigationController
            return vc
        }else if index == 2 {
            
            let vc = FSSearchCourseVC()
            vc.searchContent = self.searchContent
            vc.naviController = self.navigationController
            return vc
        }else if index == 3 {
            
            let vc = FSFoodMenuCategoryVC()
            vc.searchContent = self.searchContent
            vc.naviController = self.navigationController
            vc.isSearch = true
            return vc
        }else if index == 4 {
            
            let vc = FSFindQiCaiVC()
            vc.searchContent = self.searchContent
            vc.naviController = self.navigationController
            vc.isSearch = true
            return vc
        }else{
            let vc = FSFindSearchZongHeVC()
            vc.searchContent = self.searchContent
            vc.naviController = self.navigationController
            vc.didSelectItemBlock = {[unowned self](currIndex) in
                self.reloadData(index: currIndex)
            }
            return vc
        }
            
    }
}

extension FSFindSearchVC: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}
extension FSFindSearchVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        reloadData(index: 0)
    }
}
