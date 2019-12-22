//
//  FSOrderModel.swift
//  fitsky
//  订单model
//  Created by gouyz on 2019/9/20.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSOrderModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 订单类型（1-商家服务）
    var order_type : String? = ""
    /// 订单编号
    var order_sn : String? = ""
    /// 订单金额
    var order_amount : String? = ""
    /// 优惠金额
    var discount_price : String? = ""
    /// 支付金额 = 订单金额 - 优惠金额
    var order_payed : String? = ""
    /// 支付状态（0-未支付 1-已支付 2-支付失败）
    var pay_status : String? = ""
    /// 支付时间
    var pay_time : String? = ""
    /// 支付ID（1-支付宝 2-微信支付）
    var pay_id : String? = ""
    /// 支付方式（1-支付宝 2-微信支付）
    var pay_name : String? = ""
    /// 退款状态（0-否 1-是）
    var refund_status : String? = ""
    /// 退款时间
    var refund_time : String? = ""
    /// 退款金额
    var refund_price : String? = ""
    /// 退款备注
    var refund_remark : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 场馆名称
    var store_name : String? = ""
    /// 会员id
    var member_id : String? = ""
    /// 会员名称
    var member_name : String? = ""
    /// 会员昵称
    var nick_name : String? = ""
    /// 会员头像
    var avatar : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 支付状态文本说明
    var pay_status_text : String? = ""
    ///
    var pay_btn_text : String? = ""
}

/// 支付方式model
@objcMembers
class FSPaymentModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 支付方式（alipay、wxpay）
    var payment : String? = ""
    /// 支付名称
    var pay_name : String? = ""
    
}
