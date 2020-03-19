//
//  FSIMCircleModel.swift
//  fitsky
//  社圈model
//  Created by gouyz on 2020/3/17.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSIMCircleModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 分类ID
    var category_id : String? = ""
    /// 社圈名称
    var name : String? = ""
    /// 图片
    var material : String? = ""
    /// 简介
    var brief : String? = ""
    /// 省
    var province : String? = ""
    ///
    var city : String? = ""
    /// 县区
    var county : String? = ""
    /// ID
    var unique_id : String? = ""
    /// 二维码
    var qrcode : String? = ""
    /// 最大成员数
    var max_member_count : String? = "0"
    /// 成员数
    var member_count : String? = "0"
    /// 邀请确认（0-否 1-是）
    var is_invitation_confirmation : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    ///
    var lng : String? = ""
    ///
    var lat : String? = ""
    /// 地图兴趣点名称
    var position : String? = ""
    /// 地址
    var address : String? = ""
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
    /// 分类名称
    var category_id_text : String? = ""
    /// 缩略图
    var thumb : String? = ""
    var memberModel:FSIMCircleMemberModel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "circle_member"{
            guard let datas = value as? [String : Any] else { return }
            memberModel = FSIMCircleMemberModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
