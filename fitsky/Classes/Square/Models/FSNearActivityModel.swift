//
//  FSNearActivityModel.swift
//  fitsky
//  附近 活动model
//  Created by gouyz on 2019/9/16.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSNearActivityModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 城市ID
    var city_id : String? = ""
    /// 名称
    var name : String? = ""
    /// 素材地址
    var material : String? = ""
    /// 报名开始时间
    var apply_stime : String? = ""
    /// 报名结束时间
    var apply_etime : String? = ""
    /// 活动开始时间
    var activity_stime : String? = ""
    /// 活动结束时间
    var activity_etime : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 用户ID
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 更新时间
    var update_time : String? = ""
    ///创建者IP
    var ip : String? = ""
    /// 详情
    var content: String? = ""
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
    /// 报名人数
    var apply_count : String? = "0"
    ///
    var _id : String? = ""
    ///
    var thumb : String? = ""
    /// 报名状态（0-未开始 1-报名中 2-已结束）
    var apply_status : String? = ""
    /// 报名状态文本（0-未开始 1-报名中 2-已结束）
    var apply_status_text : String? = ""
    ///  活动状态（0-未开始 1-活动中 2-已结束）
    var activity_status : String? = ""
    /// 活动状态文本（0-未开始 1-活动中 2-已结束）
    var activity_status_text : String? = ""
    /// 报名按钮（0-报名未开始 1-马上报名 2-报名结束 3-我已报名）
    var apply_btn_text : String? = ""
    /// 14
    var more_type : String? = ""
    ///
    var display_create_time : String? = ""
    
    ///
    var display_apply_stime : String? = ""
    ///
    var display_apply_etime : String? = ""
    ///
    var display_activity_stime : String? = ""
    ///
    var display_activity_etime : String? = ""
}

/// 活动详情model
@objcMembers
class FSActivityDetailModel: LHSBaseModel {
    
    /// 活动信息
    var formData: FSNearActivityModel?
    /// 分享model
    var sharedModel : FSSharedModel?
    /// 点赞、收藏、评论等数量
    var countModel: FSDynamicCountModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "formdata"{
            guard let datas = value as? [String : Any] else { return }
            formData = FSNearActivityModel(dict: datas)
        }else if key == "count"{
            guard let datas = value as? [String : Any] else { return }
            countModel = FSDynamicCountModel(dict: datas)
        }else if key == "share"{
            guard let datas = value as? [String : Any] else { return }
            sharedModel = FSSharedModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
