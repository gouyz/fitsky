//
//  FSDynamicMaterialModel.swift
//  fitsky
//  动态素材model
//  Created by gouyz on 2019/8/28.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSDynamicMaterialModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 会员ID
    var member_id : String? = ""
    /// 动态ID
    var dynamic_id : String? = ""
    /// 类型（1-图片 2-视频）
    var material_type : String? = ""
    /// 素材地址
    var material : String? = ""
    /// 封面（0-否 1-是）
    var is_cover : String? = ""
    /// 状态（0-待审核 1-已审核 2-被打回 3-已删除）
    var status : String? = ""
    /// 排序ID
    var sort_id : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 缩略图
    var thumb : String? = ""
}
