//
//  GYZNetWork.swift
//  flowers
//  网络请求库封装
//  Created by gouyz on 2016/11/9.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

/// 网络请求基地址
#if DEBUG
let BaseRequestURL = "http://api.app.fitsky.net/v2.0.0/"
//let BaseRequestURL = "http://api.fitsky.lijiayin.com/v2.0.0/"
#else
let BaseRequestURL = "http://api.app.fitsky.net/v2.0.0/"
#endif

class GYZNetWork: NSObject {
    
    /// POST/GET网络请求
    ///
    /// - Parameters:
    /// - url: 请求URL
    /// - baseUrl: 网络请求基地址
    /// - parameter isToken:    是否需要传token，默认需要传
    /// - parameter parameters: 请求参数
    /// - parameter method:     请求类型POST/GET
    /// - success: 上传成功的回调
    /// - failture: 上传失败的回调
    static func requestNetwork(_ url : String,
                               baseUrl: String = BaseRequestURL,
                               isToken: Bool = true,
                               parameters : Parameters? = nil,
                               method : HTTPMethod = .post,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success : @escaping (_ response : JSON)->Void,
                               failture : @escaping (_ error : Error?)-> Void){
        
        /// 是否需要动态获取baseUrl
        let requestUrl = baseUrl + url
        
//        var header : HTTPHeaders?
        var paramDic:Parameters = parameters == nil ? [String: Any]() : parameters!
        
        if isToken {//统一传值，用户id
            if let token = userDefaults.string(forKey: "token") {
//                header = ["Authorization":token]
                paramDic["token"] = token
            }else{
                paramDic["token"] = ""
            }
        }
        if let model = userDefaults.data(forKey: CURRCITYINFO) {
            let currCityModel = NSKeyedUnarchiver.unarchiveObject(with: model) as? FSCityListModel
            paramDic["city_id"] = (currCityModel?.id)!
        }
        paramDic["app_id"] = API_APPID
        paramDic["app_key"] = API_APPKEY
        paramDic["time"] = Int(Date().timeIntervalSince1970)
        paramDic["sign"] = ""
        
        GYZLog(paramDic)
        
        Alamofire.request(requestUrl, method: method, parameters: paramDic,encoding:encoding,headers: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess{
                if let value = response.result.value {
                    let result = JSON(value)
                    let code = result["result"].intValue
                    if code == 10000 && url != "Member/MemberClient/add"{// 需要重新登录
                        GYZTool.removeUserInfo()
                        KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
                    }
                    success(result)
                }
            }else{
                failture(response.result.error)
            }
        })
    }
    
    /// 网络请求
    ///
    /// - parameter url:        请求URL 全路径url
    /// - parameter parameters: 请求参数
    /// - parameter method:     请求类型POST/GET
    /// - success: 上传成功的回调
    /// - failture: 上传失败的回调
    static func requestVersionNetwork(_ url : String,
                                      parameters : Parameters? = nil,
                                      method : HTTPMethod = .post,
                                      encoding: ParameterEncoding = URLEncoding.default,
                                      success : @escaping (_ response : JSON)->Void,
                                      failture : @escaping (_ error : Error?)-> Void){
        
        Alamofire.request(url, method: method, parameters: parameters,encoding:encoding,headers: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess{
                if let value = response.result.value {
                    
                    success(JSON(value))
                }
            }else{
                failture(response.result.error)
            }
        })
    }
    
    /// 图片上传
    ///
    /// - Parameters:
    ///   - url: 服务器地址
    ///   - parameters: 参数
    ///   - uploadParam: 上传图片的信息
    ///   - success: 上传成功的回调
    ///   - failture: 上传失败的回调
    static func uploadImageRequest(_ url : String,
                                   baseUrl: String = BaseRequestURL,
                                   parameters : [String:String]? = nil,
                                   uploadParam : [ImageFileUploadParam],
                                   success : @escaping (_ response : JSON)->Void,
                                   failture : @escaping (_ error : Error?)-> Void){
        
        let requestUrl = baseUrl + url
        
        let headers = ["content-type":"multipart/form-data"]
        
        var paramDic:[String: String] = parameters == nil ? [String: String]() : parameters!
        
        if let token = userDefaults.string(forKey: "token") {
            //                header = ["Authorization":token]
            paramDic["token"] = token
        }else{
            paramDic["token"] = ""
        }
        if let model = userDefaults.data(forKey: CURRCITYINFO) {
            let currCityModel = NSKeyedUnarchiver.unarchiveObject(with: model) as? FSCityListModel
            paramDic["city_id"] = (currCityModel?.id)!
        }
        paramDic["app_id"] = API_APPID
        paramDic["app_key"] = API_APPKEY
        paramDic["time"] = "\(Int(Date().timeIntervalSince1970))"
        paramDic["sign"] = ""
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if paramDic.count > 0{
                for param in paramDic{
                    multipartFormData.append( (param.value.data(using: String.Encoding.utf8)!), withName: param.key)
                }
            }
            for item in uploadParam{
                multipartFormData.append(item.data!, withName: item.name!, fileName: item.fileName!, mimeType: item.mimeType!)
            }
        }, to: requestUrl,
           headers: headers,
           encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let result = JSON(value)
                        let code = result["result"].intValue
                        if code == 10000 {// 需要重新登录
                            GYZTool.removeUserInfo()
                            KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
                        }
                        success(result)
                    }
                })
            case .failure(let encodingError):
                failture(encodingError)
            }
        })
    }
    
    /// 视频上传
    ///
    /// - Parameters:
    ///   - url: 服务器地址
    ///   - parameters: 参数
    ///   - uploadParam: 上传图片的信息
    ///   - success: 上传成功的回调
    ///   - failture: 上传失败的回调
    static func uploadVideoRequest(_ url : String,
                                   baseUrl: String = BaseRequestURL,
                                   parameters : [String:Any]? = nil,
                                   fileUrl : URL,
                                   keyName: String,
                                   success : @escaping (_ response : JSON)->Void,
                                   failture : @escaping (_ error : Error?)-> Void){
        
        let requestUrl = baseUrl + url
        
        let headers = ["content-type":"multipart/form-data"]
        
        var paramDic:[String: Any] = parameters == nil ? [String: Any]() : parameters!
        
        if let token = userDefaults.string(forKey: "token") {
            //                header = ["Authorization":token]
            paramDic["token"] = token
        }else{
            paramDic["token"] = ""
        }
        if let model = userDefaults.data(forKey: CURRCITYINFO) {
            let currCityModel = NSKeyedUnarchiver.unarchiveObject(with: model) as? FSCityListModel
            paramDic["city_id"] = (currCityModel?.id)!
        }
        paramDic["app_id"] = API_APPID
        paramDic["app_key"] = API_APPKEY
        paramDic["time"] = "\(Int(Date().timeIntervalSince1970))"
        paramDic["sign"] = ""
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if paramDic.count > 0{
                for param in paramDic{
                    multipartFormData.append( ((param.value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: param.key)
                }
            }
            multipartFormData.append(fileUrl, withName: keyName, fileName: "video.mp4", mimeType: "video/mp4")
        }, to: requestUrl,
           headers: headers,
           encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let result = JSON(value)
                        let code = result["result"].intValue
                        if code == 10000 {// 需要重新登录
                            GYZTool.removeUserInfo()
                            KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
                        }
                        success(result)
                    }
                })
            case .failure(let encodingError):
                failture(encodingError)
            }
        })
    }
    
    /// 下载文件网络请求
    ///
    /// - Parameters:
    /// - url: 请求URL
    /// - parameters: 请求参数
    /// - method:     请求类型POST/GET
    /// - success: 上传成功的回调
    /// - failture: 上传失败的回调
    static func downLoadRequest(_ url : String,
                                parameters : Parameters? = nil,
                                method : HTTPMethod = .get,
                                success : @escaping (_ response : JSON)->Void,
                                failture : @escaping (_ error : Error?)-> Void){
        
        ///下载到用户文档目录下
        let destination = DownloadRequest.suggestedDownloadDestination(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        
        Alamofire.download(url, method: method, parameters: parameters, to: destination).response { (response) in
            if response.error == nil{
                success(JSON(""))
            }else{
                failture(response.error)
            }
        }
        
            
//            .responseJSON { (response) in
//            if response.result.isSuccess{
//                if let value = response.result.value {
//
//                    success(JSON(value))
//                }
//            }else{
//                failture(response.result.error)
//            }
//        }
       
    }
    
}

class ImageFileUploadParam: NSObject {
    
    /// 图片的二进制数据
    var data : Data?
    
    /// 服务器对应的参数名称
    var name : String?
    
    /// 文件的名称(上传到服务器后，服务器保存的文件名)
    var fileName : String?
    
    /// 文件的MIME类型(image/png,image/jpg等)
    var mimeType : String?
}
