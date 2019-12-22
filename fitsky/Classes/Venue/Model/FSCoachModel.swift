//
//  FSCoachModel.swift
//  fitsky
//  场馆教练model
//  Created by gouyz on 2019/9/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCoachModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 场馆ID
    var store_id : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 教练姓名
    var name : String? = ""
    /// 性别（0-女 1-男 2-保密）
    var sex : String? = ""
    /// 头像
    var material : String? = ""
    /// 视频
    var video : String? = ""
    /// 教练等级（1-私人教练 2-高级私人教练）
    var coach_rank : String? = ""
    /// 标签（多个用英文逗号隔开）
    var tags : [String] = [String]()
    /// 工作年限（单位：年）
    var working_life : String? = ""
    /// 自我介绍
    var self_introduction : String? = ""
    /// 打回备注
    var remark : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 用户id
    var user_id : String? = ""
    /// 用户名
    var user_name : String? = ""
    /// 添加时间
    var create_time : String? = ""
    /// ip
    var ip : String? = ""
    /// 更新时间
    var update_time : String? = ""
    /// 缩略图
    var thumb : String? = ""
    /// 教练等级文本说明
    var coach_rank_text : String? = ""
    ///
    var display_create_time : String? = ""
    /// 停职（0-否 1-是）
    var is_suspension : String? = ""
    /// 用户授权ID
    var unique_id : String? = ""
    /// 身份证号
    var identity_card_id : String? = ""
    /// 缩略图 URL 用于我的教练详情
    var thumb_url : String? = ""
    /// 头像
    var material_url : String? = ""
    /// 照片
    var photo_thumb_url : String? = ""
    /// 视频
    var video_url : String? = ""
    /// 身份证半身照
    var identity_card_half_thumb_url : String? = ""
    /// 身份证正面
    var identity_card_front_thumb_url : String? = ""
    /// 身份证反面
    var identity_card_backend_thumb_url : String? = ""
    /// 资格证
    var qualification_certificate_thumb_url : String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "tags"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                tags.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
