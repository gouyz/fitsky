//
//  FSMessageHomeModel.swift
//  fitsky
//  消息主页 model
//  Created by gouyz on 2019/12/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMessageHomeModel: LHSBaseModel {

    /// 订阅号信息
    var subscriptionData: FSSubscriptionModel?
    /// 点赞
    var like : String? = "0"
    /// 收藏
    var collect : String? = "0"
    /// 评论
    var comment : String? = "0"
    /// 系统通知
    var notice : String? = "0"
    /// 订阅号
    var subscription : String? = "0"
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "subscription_info"{
            guard let datas = value as? [String : Any] else { return }
            subscriptionData = FSSubscriptionModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
