//
//  FSFindVC.swift
//  fitsky
//  发现
//  Created by gouyz on 2019/8/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import JXSegmentedView
import JXPagingView
import PYSearch

class FSFindVC: GYZWhiteNavBaseVC {
    let searchHistoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "PYSearchhistoriesFind.plist" // the path of search record cached
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    let JXTableHeaderViewHeight: Int = Int(kTitleAndStateHeight)
    let titles = ["资讯", "运动", "饮食", "器材"]
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        segmentedView.contentScrollView = pagingView.listContainerView.collectionView
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(kStateHeight)
        
        self.view.addSubview(navBarView)
        navBarView.addSubview(scanBtn)
        navBarView.addSubview(searchView)
        navBarView.addSubview(lineView)
        
        navBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(kTitleAndStateHeight)
        }
        scanBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.width.equalTo(kTitleHeight)
            make.top.equalTo(kStateHeight)
            make.bottom.equalTo(lineView.snp.top)
        }
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(scanBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(scanBtn)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(navBarView)
            make.height.equalTo(klineWidth)
        }
        
        
        searchView.searchBtn.set(image: UIImage.init(named: "app_icon_seach"), title: "搜索资讯、课程、菜谱、器材", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
        
        searchView.searchBtn.addTarget(self, action: #selector(onClickedSearch), for: .touchUpInside)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isSearch {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isSearch = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    lazy var pagingView: JXPagingView = {
        let pageView = JXPagingListRefreshView(delegate: self) //JXPagingView.init(delegate: self)
        
        return pageView
    }()
    lazy var segmentedView: JXSegmentedView = {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleNormalColor = kHeightGaryFontColor
        segmentedViewDataSource.titleSelectedColor = kOrangeFontColor
        segmentedViewDataSource.titleNormalFont = UIFont.boldSystemFont(ofSize: 16)
        segmentedViewDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16)
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
    
    lazy var navBarView: UIView = {
        let navView = UIView()
        navView.backgroundColor = kWhiteColor
        navView.isUserInteractionEnabled = true
        
        return navView
    }()
    /// 扫描二维码
    lazy var scanBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_scan_qrcode"), for: .normal)
        btn.addTarget(self, action: #selector(clickedScanQrCode), for: .touchUpInside)
        return btn
    }()
    /// 搜索
    lazy var searchView: GYZSearchBtnView = GYZSearchBtnView()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    
    /// 扫描二维码
    @objc func clickedScanQrCode(){
        
    }
    /// 搜索
    @objc func onClickedSearch(){
        isSearch = true
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
}
extension FSFindVC: JXPagingViewDelegate {
    
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
        if index > 0 { // 运动、饮食、器材
            let vc = FSSupportVC()
            vc.type = "\(index)"
            vc.naviController = self.navigationController
            return vc
        }
        let vc = FSNewsVC()
        vc.naviController = self.navigationController
        return vc
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        var percent = scrollView.contentOffset.y/kTitleHeight
        percent = max(0, min(1, percent))
        navBarView.alpha = 1 - percent
    }
}

extension FSFindVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}
