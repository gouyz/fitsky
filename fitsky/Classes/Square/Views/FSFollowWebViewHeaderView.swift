//
//  FSFollowWebViewHeaderView.swift
//  fitsky
//
//  Created by gouyz on 2019/9/4.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import WebKit

class FSFollowWebViewHeaderView: UITableViewHeaderFooterView {
    /// 选择结果回调
    var resultHeightBlock:((_ wkHeight: CGFloat) -> Void)?
    
    /// 填充数据
    var dataModel : FSDynamicDetailModel?{
        didSet{
            if let model = dataModel {
                
                if let url = model.formData?.opus_content {
                    loadContent(url: url)
                }
                
                
                if model.materialUrlList.count > 0{
                    imgViews.isHidden = false
                    
                    if model.materialUrlList.count == 1 {
                        let imgItem = model.materialList[0]
                        let imgSize = GYZTool.getThumbSize(url: imgItem.material!, thumbUrl: imgItem.thumb!)
                        imgViews.imgHight = (kScreenWidth - kMargin * 2) * imgSize.height / imgSize.width
                        imgViews.imgWidth = kScreenWidth - kMargin * 2
                        imgViews.perRowItemCount = 1
                    }else if model.materialUrlList.count == 2 || model.materialUrlList.count == 4 {
                        imgViews.imgHight = kPhotosImgHeight2
                        imgViews.imgWidth = kPhotosImgHeight2
                        imgViews.perRowItemCount = 2
                    }else{
                        imgViews.imgHight = kPhotosImgHeight3
                        imgViews.imgWidth = kPhotosImgHeight3
                        imgViews.perRowItemCount = 3
                    }
                    
                    imgViews.selectImgUrls = model.materialUrlList
                    let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                    imgViews.snp.updateConstraints { (make) in
                        make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                    }
                }else{
                    imgViews.isHidden = true
                    imgViews.snp.updateConstraints({ (make) in
                        
                        make.height.equalTo(0)
                    })
                }
            }
        }
    }
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
        contentView.addSubview(imgViews)
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(0)
//            make.bottom.equalTo(imgViews.snp.top).offset(-kMargin)
        }
        imgViews.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(webView.snp.bottom).offset(kMargin)
            make.height.equalTo(0)
        }
    }
    /// 加载富文本 商品详情
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.red
        //! 解决iOS9.2以上黑边问题
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        
        return webView
    }()
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    
}
extension FSFollowWebViewHeaderView : WKNavigationDelegate{
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
        /// 获取网页title
        //        self.title = self.webView.title
//        self.hud?.hide(animated: true)
        var imgHeight: CGFloat = 0
        var rowCount: CGFloat = 0
        if dataModel?.materialUrlList.count > 0{
            
            if dataModel?.materialUrlList.count == 1 {
                let imgItem = dataModel?.materialList[0]
                let imgSize = GYZTool.getThumbSize(url: imgItem!.material!, thumbUrl: imgItem!.thumb!)
                imgHeight = imgSize.height
                rowCount = 1
            }else if dataModel?.materialUrlList.count == 2 || dataModel?.materialUrlList.count == 4 {
                imgHeight = kPhotosImgHeight2
                rowCount = 2
            }else{
                imgHeight = kPhotosImgHeight3
                rowCount = 3
            }
            
            let rowIndex = ceil(CGFloat.init((dataModel?.materialUrlList.count)!) / rowCount)//向上取整
            imgHeight = imgHeight * rowIndex + kMargin * (rowIndex - 1)
        }
        //获取网页的高度
        webView.evaluateJavaScript("document.body.scrollHeight") {[unowned self] (result, error) in
            
            GYZLog((result as! CGFloat))
            self.webView.snp.updateConstraints { (make) in
                make.height.equalTo((result as! CGFloat))
            }
            GYZLog(self.webView.frame.size.height)
            if self.resultHeightBlock != nil {
                self.resultHeightBlock!((result as! CGFloat) + imgHeight + kMargin * 2)
            }
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
//        self.hud?.hide(animated: true)
    }
}
