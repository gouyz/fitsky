//
//  FSReplyModel.swift
//  fitsky
//  评论回复model
//  Created by gouyz on 2019/8/30.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSReplyModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 评论ID
    var comment_id : String? = ""
    /// 内容ID
    var content_id : String? = ""
    /// 回复ID
    var reply_id : String? = ""
    /// 回复类型（1-评论 2-回复）
    var reply_type : String? = ""
    /// 内容
    var content : String? = ""
    /// 回复会员ID
    var from_member_id : String? = ""
    /// 回复会员名
    var from_member_name : String? = ""
    /// 回复昵称
    var from_nick_name : String? = ""
    /// 回复会员头像
    var from_avatar : String? = "0"
    /// 会员类型（1-普通 2-达人 3-场馆）
    var from_member_type : String? = ""
    /// 目标会员ID
    var to_member_id : String? = ""
    /// 目标会员名
    var to_member_name : String? = ""
    /// 目标昵称
    var to_nick_name : String? = ""
    /// 目标会员头像
    var to_avatar : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 创建者IP
    var ip : String? = ""
    /// 阅读次数
    var read_count : String? = "0"
    /// 分享次数
    var share_count : String? = "0"
    /// 评论次数
    var comment_count : String? = "0"
    ///  收藏数
    var collect_count : String? = "0"
    /// 点赞数
    var like_count : String? = "0"
    /// 排序ID
    var sort_id : String? = ""
    /// 回复数
    var reply_count : String? = "0"
    /// 举报数
    var report_count : String? = "0"
    ///
    var _id : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 索引图
    var material : String? = ""
    /// 类型（1-动态 2-话题 3-课程 4-器材 5-饮食 6-菜谱 7-食材库 8-活力 9-评论 10-评论回复）
    var more_type : String? = ""
    /// "06/04 15:45" 时间显示
    var display_create_time : String? = ""
    /// 是否点赞、收藏等
    var moreModel: FSDynamicMoreModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "more"{
            guard let datas = value as? [String : Any] else { return }
            moreModel = FSDynamicMoreModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
