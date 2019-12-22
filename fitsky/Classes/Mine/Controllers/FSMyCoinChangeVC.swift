//
//  FSMyCoinChangeVC.swift
//  fitsky
//  我的积分
//  Created by gouyz on 2019/10/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let coinChangeCell = "coinChangeCell"

class FSMyCoinChangeVC: GYZBaseVC {
    
    let imageHeight: CGFloat = kScreenWidth * 0.54
    
    var currPage : Int = 1
    /// 最后一页
    var lastPage: Int = 1
    var dataList: [FSCoinGoodsModel] = [FSCoinGoodsModel]()
    var isRefresh: Bool = false
    /// 总积分
    var totalCoin: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的积分"
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "app_img_bg_user_integral_i")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickRightBtn))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
        }
        
        bgImgView.addSubview(tagImgView)
        bgImgView.addSubview(nameLab)
        bgImgView.addSubview(coinNumLab)
        
        tagImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImgView)
            make.bottom.equalTo(bgImgView)
            make.size.equalTo(CGSize.init(width: 140, height: 140))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.bottom.equalTo(tagImgView.snp.centerY).offset(-5)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        coinNumLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(tagImgView.snp.centerY).offset(5)
        }
        bgHeaderView.addSubview(bgImgView)
        tableView.tableHeaderView = bgHeaderView
        
        requestCoinNum()
        requestGoodsList()
    }
    
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        
        table.register(FSCoinChangeCell.classForCoder(), forCellReuseIdentifier: coinChangeCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return table
    }()
    
    ///
    lazy var bgHeaderView: UIView = {
        let bgView = UIView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: imageHeight)
        bgView.isUserInteractionEnabled = true
        
        return bgView
    }()
    ///
    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_img_bg_user_integral"))
        imgView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: imageHeight)
        imgView.contentMode = .scaleAspectFill
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "app_bg_img_integral"))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.addOnClickListener(target: self, action: #selector(onClickedCoinDetail))
        
        return imgView
    }()
    ///
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kOrangeFontColor
        lab.textAlignment = .center
        lab.text = "总积分"
        
        return lab
    }()
    ///积分数量
    lazy var coinNumLab: UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kOrangeFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    
    ///积分总数
    func requestCoinNum(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/MemberPoint/point", parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]["formdata"]
                weakSelf?.totalCoin = data["point"].stringValue
                weakSelf?.coinNumLab.text = weakSelf?.totalCoin
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 右侧按钮
    @objc func onClickRightBtn(){
        let vc = FSCoinRuleVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 积分明细
    @objc func onClickedCoinDetail(){
        let vc = FSCoinDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取积分商品数据
    func requestGoodsList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("Member/MemberPoint/goods",parameters: ["p":currPage],  success: { (response) in
            
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.lastPage = response["data"]["page"]["last_page"].intValue
                
                guard let data = response["data"]["list"].array else { return }
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = FSCoinGoodsModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无积分商品信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.closeRefresh()
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            if weakSelf?.currPage == 1{
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.refresh()
                })
            }
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        if currPage == lastPage {
            GYZTool.resetNoMoreData(scorllView: tableView)
        }
        dataList.removeAll()
        tableView.reloadData()
        currPage = 1
        requestCoinNum()
        requestGoodsList()
    }
    
    /// 上拉加载更多
    func loadMore(){
        if currPage == lastPage {
            GYZTool.noMoreData(scorllView: tableView)
            return
        }
        currPage += 1
        requestGoodsList()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    
    /// 立即兑换
    @objc func onClickedCoinChange(sender:UIButton){
        
        let index = sender.tag
        GYZAlertViewTools.alertViewTools.showAlert(title: nil, message: "确认立即兑换？", cancleTitle: "取消", viewController: self, buttonTitles: "确认") { [unowned self] (tag) in
            
            if tag != cancelIndex{
                self.requestChangeGoods(index: index)
            }
        }
    }
    ///兑换商品
    func requestChangeGoods(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/MemberPoint/exchange", parameters: ["id":dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.requestGoodsById(index: index)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///单个积分商品
    func requestGoodsById(index: Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/MemberPoint/one", parameters: ["id":dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                weakSelf?.dealGoodsChange(model: FSCoinGoodsModel.init(dict: data),index: index)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealGoodsChange(model: FSCoinGoodsModel,index: Int){
        dataList[index] = model
        tableView.reloadData()
        let num: Int = Int.init(totalCoin)! - Int.init(model.point!)!
        coinNumLab.text = "\(num)"
    }
}

extension FSMyCoinChangeVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: coinChangeCell) as! FSCoinChangeCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.changeBtn.tag = indexPath.row
        cell.changeBtn.addTarget(self, action: #selector(onClickedCoinChange(sender:)), for: .touchUpInside)
        
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
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
        }else{
            navBarBgAlpha = 0
        }
        ///  头部下拉效果
        //        var y: CGFloat = 0
        //        if #available(iOS 11.0, *) {
        //            y = -kTitleAndStateHeight
        //        }
        //        if (contentOffsetY < y) {
        //            let totalOffset = imageHeight + abs(contentOffsetY)
        //            bgImgView.frame = CGRect.init(x: 0, y: contentOffsetY, width: kScreenWidth, height: totalOffset)
        //        }
    }
}
