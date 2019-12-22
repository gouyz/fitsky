//
//  FSMsgZanModel.swift
//  fitsky
//  点赞 消息model
//  Created by gouyz on 2019/12/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMsgZanModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 推送类型（1-点赞 2-收藏 3-评论 4-回复 5-通知 6-订阅号）
    var push_type : String? = ""
    /// 用户标识ID
    var client_id : String? = ""
    /// 推送ID
    var push_id : String? = ""
    /// 推送标题
    var title : String? = ""
    /// 图片
    var material : String? = ""
    /// 推送内容
    var content : String? = ""
    /// 内容ID
    var content_id : String? = ""
    /// 内容类型（1-动态（作品）13-场馆服务商品 15-系统通知 16-订阅号）
    var content_type : String? = ""
    /// 评论ID
    var comment_id : String? = "0"
    /// 评论内容（push_type = 4 时有值）
    var comment_content : String? = ""
    /// 回复ID
    var reply_id : String? = ""
    /// 回复内容
    var reply_content : String? = ""
    /// 透传内容
    var payload : String? = ""
    /// 推送参数
    var param : String? = ""
    /// 返回数据
    var callback_data : String? = ""
    /// 状态（0-等待推送 1-推送成功 2-推送失败）
    var send_status : String? = ""
    /// 已读（0-未读 1-已读）
    var is_read : String? = ""
    /// 已读时间
    var read_time : String? = ""
    /// 会员ID（发送人）
    var from_member_id : String? = ""
    /// 会员名
    var from_member_name : String? = ""
    ///
    var from_nick_name : String? = ""
    ///
    var from_avatar : String? = ""
    /// 会员ID（接收人）
    var to_member_id : String? = ""
    ///
    var to_member_name : String? = ""
    ///
    var to_nick_name : String? = ""
    ///
    var to_avatar : String? = ""
    /// 1
    var create_time : String? = ""
    ///
    var thumb : String? = ""
    /// 10/30 23:08
    var display_create_time : String? = ""
    /// 用户类型-v标（1-普通 2-达人 3-场馆）
    var from_member_type : String? = ""
    /// 是否作品
    var is_opus : String? = ""
}
