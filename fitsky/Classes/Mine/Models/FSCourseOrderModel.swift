//
//  FSCourseOrderModel.swift
//  fitsky
//  课程订单 model
//  Created by gouyz on 2019/11/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCourseOrderModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 订单商品主键ID
    var order_goods_id : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 订单ID
    var order_id : String? = ""
    /// 订单编号
    var order_sn : String? = ""
    /// 商品ID
    var goods_id : String? = ""
    /// 核销码
    var write_off_code : String? = ""
    /// 核销状态（0-待核销 1-已核销）
    var write_off_status : String? = ""
    /// 核销时间
    var write_off_time : String? = ""
    /// 备注
    var remark : String? = ""
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
    /// 支付金额
    var order_payed : String? = ""
    /// 手续费
    var commission : String? = ""
    
    /// 结算金额 = 支付金额 - 手续费
    var settle_price : String? = ""
    /// 结算状态（0-未结算 1-已结算）
    var settle_status : String? = ""
    /// 结算时间
    var settle_time : String? = ""
    /// 结算人ID
    var settle_user_id : String? = ""
    /// 结算人
    var settle_user_name : String? = ""
    /// 反馈内容
    var feedback : String? = ""
    /// 反馈状态（0-未反馈 1-已反馈）
    var feedback_status : String? = ""
    /// 反馈时间
    var feedback_time : String? = ""
    /// 状态（0-待使用 1-已使用 2-已取消 3-已删除 4-已完成）
    var status : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 服务名称
    var goods_name : String? = ""
    /// 图片
    var material : String? = ""
    /// 视频
    var video : String? = ""
    /// 视频时长（单位：秒）
    var video_duration : String? = ""
    /// 难度（1-零基础 2-入门级 3-中级 4-高级 5-加强版）
    var difficulty : String? = ""
    /// 教练5
    var coach_id_text : String? = ""
    /// 健身馆名称
    var store_name : String? = ""
    ///
    var member_id : String? = ""
    ///
    var member_name : String? = ""
    ///
    var nick_name : String? = ""
    ///
    var avatar : String? = ""
    /// 状态文本 如待使用
    var status_text : String? = ""
    /// 核销状态文本 如待核销
    var write_off_status_text : String? = ""
    /// 支付状态文本
    var pay_status_text : String? = ""
    /// 退款状态文本
    var refund_status_text : String? = ""
    /// 反馈状态文本
    var feedback_status_text : String? = ""
    ///
    var thumb : String? = ""
    ///
    var display_pay_time : String? = ""
    ///
    var display_create_time : String? = ""
    /// 取消按钮
    var cancel_btn_text : String? = ""
    /// 支付按钮
    var pay_btn_text : String? = ""
    /// 反馈按钮
    var feedback_btn_text : String? = ""
    
    /// 中级
    var difficulty_text : String? = ""
    /// 场馆首页id
    var friend_id : String? = ""
    
    /// 购买
    var display_pay_status_text : String? = ""
    /// 退课
    var display_refund_status_text : String? = ""
    /// +￥260.00
    var display_order_payed : String? = ""
}
