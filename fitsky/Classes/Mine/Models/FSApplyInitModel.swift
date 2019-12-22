//
//  FSApplyInitModel.swift
//  fitsky
//  认证申请主页初始化 model
//  Created by gouyz on 2019/11/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSApplyInitModel: LHSBaseModel {

    /// 是否可以申请达人（0-否 1-是）
    var is_apply_daren : String? = "0"
    /// 是否可以申请社长（0-否 1-是）
    var is_apply_sz : String? = "0"
    /// 是否可以申请场馆（0-否 1-是）
    var is_apply_gym : String? = "0"
    /// 是否可以申请达人原因
    var is_apply_daren_text : String? = ""
    /// 是否可以申请社长原因
    var is_apply_sz_text : String? = ""
    /// 是否可以申请场馆原因
    var is_apply_gym_text : String? = ""
}
