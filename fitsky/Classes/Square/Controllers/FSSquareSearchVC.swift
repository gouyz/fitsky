//
//  FSSquareSearchVC.swift
//  fitsky
//  广场 搜索
//  Created by gouyz on 2019/8/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import JXPagingView

class FSSquareSearchVC: GYZWhiteNavBaseVC {

    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let JXTableHeaderViewHeight: Int = 0
    let titles = ["综合", "用户", "话题", "关注"]
    /// 搜索 内容
    var searchContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.titleView = searchBar
        /// 解决iOS11中UISearchBar高度变大
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
        }
        
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            if #available(iOS 13.0, *){// 不懂为什么多15
                make.top.equalTo(15 + kTitleAndStateHeight)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        segmentedView.contentScrollView = pagingView.listContainerView.collectionView
        
    }
    lazy var pagingView: JXPagingView = {
        let pageView = JXPagingListRefreshView(delegate: self) //JXPagingView.init(delegate: self)
        
        return pageView
    }()
    lazy var segmentedView: JXSegmentedView = {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = false
        segmentedViewDataSource.titleNormalColor = kHeightGaryFontColor
        segmentedViewDataSource.titleSelectedColor = kOrangeFontColor
        segmentedViewDataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = kOrangeFontColor
        
        let segView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
        segView.delegate = self
        segView.backgroundColor = kWhiteColor
        segView.dataSource = segmentedViewDataSource
        segView.indicators = [indicator]
        
        return segView
    }()
    /// 搜索框
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "搜索文章、用户、话题、附近"
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
}
extension FSSquareSearchVC: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView()
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(kTitleHeight)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 1 {
            let userVC = FSSearchUserVC()
            userVC.searchContent = self.searchContent
            userVC.naviController = self.navigationController
            return userVC
        }else if index == 2 {
            let talkVC = FSSearchTalkVC()
            talkVC.searchContent = self.searchContent
            talkVC.naviController = self.navigationController
            return talkVC
        }else{
            let zongHeVC = FSSearchZongHeVC()
            zongHeVC.naviController = self.navigationController
            zongHeVC.type = index == 0 ? "1" : "2"
            zongHeVC.searchContent = self.searchContent
            return zongHeVC
        }
    }
}

extension FSSquareSearchVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
        //            navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}
extension FSSquareSearchVC: UISearchBarDelegate {
    ///mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.searchContent = searchBar.text ?? ""
        pagingView.reloadData()
    }
    
//    func saveSearchHistory(){
//        let historyArr: [String] = NSKeyedUnarchiver.unarchiveObject(withFile: PYSEARCH_SEARCH_HISTORY_CACHE_PATH)
//    }
}
