//
//  FSCoinDetailModel.swift
//  fitsky
//  积分明细 model
//  Created by gouyz on 2019/11/15.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSCoinDetailModel: LHSBaseModel {

    /// id
    var id : String? = ""
    ///
    var type : String? = ""
    ///
    var content_id : String? = ""
    /// 标题
    var title : String? = ""
    /// 符号（1-加 2-减）
    var symbol : String? = "1"
    /// 积分（+表示加积分 -表示减积分）
    var point : String? = ""
    ///
    var remark : String? = ""
    ///
    var status : String? = ""
    ///
    var member_id : String? = ""
    ///
    var member_name : String? = ""
    /// 创建时间
    var create_time : String? = ""
    /// 创建者IP
    var ip : String? = ""
    /// 显示积分
    var point_text : String? = ""
    /// 10/30 23:08 添加时间
    var display_create_time : String? = ""
}
