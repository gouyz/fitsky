//
//  FSSubscriptionModel.swift
//  fitsky
//  订阅号model
//  Created by gouyz on 2019/12/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSSubscriptionModel: LHSBaseModel {
    
    /// id
    var id : String? = ""
    /// 订阅号标题
    var title : String? = ""
    /// 发送时间
    var send_time : String? = ""
    /// 订阅号图片
    var material : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 场馆名称
    var store_name : String? = ""
    /// 场馆头像图片
    var store_logo : String? = ""
    /// 发送显示时间
    var display_send_time : String? = ""
    ///
    var thumb : String? = ""
    ///
    var content : String? = ""
    /// 场馆头像图片缩略图
    var store_logo_thumb : String? = ""
}
