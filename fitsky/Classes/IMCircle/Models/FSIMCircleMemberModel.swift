//
//  FSIMCircleMemberModel.swift
//  fitsky
//  社圈成员model
//  Created by gouyz on 2020/3/19.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSIMCircleMemberModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 社圈ID
    var circle_id : String? = ""
    /// 社圈昵称
    var circle_nick_name : String? = ""
    /// 群主（0-否 1-是）1个
    var is_group : String? = ""
    /// 管理员（0-否 1-是）2个
    var is_admin : String? = ""
    /// 消息免打扰（0-否 1-是）
    var is_message_free : String? = ""
    /// 置顶消息（0-否 1-是）
    var is_top_message : String? = ""
    /// 状态（0-新申请 1-已同意 2-已拒绝 3-用户退出 4-管理员踢出 5-圈主解散）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 会员ID（创建人）
    var member_id : String? = ""
    /// 用户类型（1-普通 2-达人 3-场馆）
    var member_type : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 头像
    var avatar : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 分类名称
    var sex : String? = ""
    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
    var friend_type : String? = ""
    /// 状态名称
    var status_text : String? = ""
}
