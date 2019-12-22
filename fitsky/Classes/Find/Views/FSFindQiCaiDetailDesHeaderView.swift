//
//  FSFindQiCaiDetailDesHeaderView.swift
//  fitsky
//  发现 器材详情 器材使用说明View
//  Created by gouyz on 2019/10/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import WebKit

class FSFindQiCaiDetailDesHeaderView: UITableViewHeaderFooterView {
    
    /// 选择结果回调
    var resultHeightBlock:((_ wkHeight: CGFloat) -> Void)?
    
    /// 加载
    func loadContent(url: String){
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
    }
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(webView)
        contentView.addSubview(nameLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(5)
            make.height.equalTo(kTitleHeight)
        }
        webView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
        }
    }
    /// 加载富文本 商品详情
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.clear
        //! 解决iOS9.2以上黑边问题
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        
        return webView
    }()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "使用方法"
        
        return lab
    }()
    
}
extension FSFindQiCaiDetailDesHeaderView : WKNavigationDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        //        createHUD(message: "加载中...")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //获取网页的高度
        webView.evaluateJavaScript("document.body.scrollHeight") {[unowned self] (result, error) in
            if self.resultHeightBlock != nil {
                self.resultHeightBlock!((result as! CGFloat) + 50)
            }
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        //        self.hud?.hide(animated: true)
    }
}
