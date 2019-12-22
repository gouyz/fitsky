//
//  FSCoinGoodsModel.swift
//  fitsky
//  积分商品 model
//  Created by gouyz on 2019/11/14.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCoinGoodsModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 商品名称
    var goods_name : String? = ""
    /// 图片地址
    var material : String? = ""
    /// 积分
    var point : String? = "0"
    /// 限制兑换份数
    var limit_exchange_number : String? = "0"
    /// 状态
    var status : String? = ""
    /// 排序id
    var sort_id : String? = ""
    /// 用户ID
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 创建者IP
    var ip : String? = ""
    ///
    var thumb : String? = ""
    /// 10/30 23:08
    var display_create_time : String? = ""
}
