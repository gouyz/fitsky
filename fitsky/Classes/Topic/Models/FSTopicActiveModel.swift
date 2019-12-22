//
//  FSTopicActiveModel.swift
//  fitsky
//  话题 活跃度model
//  Created by gouyz on 2019/9/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSTopicActiveModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 话题ID
    var topic_id : String? = ""
    /// 参与（0-否 1-是）
    var status : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 昵称
    var nick_name : String? = ""
    /// 会员名
    var member_name : String? = ""
    /// 会员头像
    var avatar : String? = ""
    /// 会员类型（1-普通 2-达人 3-场馆）
    var member_type : String? = ""
    /// （0-女 1-男 2-保密）
    var sex : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 阅读次数
    var read_count : String? = "0"
    /// 分享次数
    var share_count : String? = "0"
    /// 评论次数
    var comment_count : String? = "0"
    /// 收藏数
    var collect_count : String? = "0"
    /// 点赞数
    var like_count : String? = "0"
    /// 动态数
    var dynamic_count : String? = "0"
    /// 活跃度
    var activity_count : String? = "0"
    /// 好友关系（0-未关注 1-已关注 2-相互关注 3-自己）
    var friend_type : String? = ""
}

