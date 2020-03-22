//
//  FSIMCircleNoticeModel.swift
//  fitsky
//  社圈公告
//  Created by gouyz on 2020/3/22.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSIMCircleNoticeModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 社圈ID
    var circle_id : String? = ""
    /// 内容
    var content : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 会员ID（创建人）
    var member_id : String? = ""
    /// 会员名
    var member_name : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 头像
    var avatar : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 用户类型（1-普通 2-达人 3-场馆）
    var member_type : String? = ""
    /// 群主（0-否 1-是）1个
    var is_group : String? = ""
    /// 管理员（0-否 1-是）2个
    var is_admin : String? = ""
    ///  状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 分类名称
    var sex : String? = ""
    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
    var friend_type : String? = ""
    ///
    var display_create_time : String? = ""
}
