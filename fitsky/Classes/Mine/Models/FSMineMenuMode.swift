//
//  FSMineMenuMode.swift
//  fitsky
//  我的 menu model
//  Created by gouyz on 2019/10/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

@objcMembers
class FSMineMenuMode: LHSBaseModel {

    /// menu名称
    var title : String? = ""
    /// menu图片名称
    var image : String? = ""
    /// 跳转控制器
    var controller : String? = ""
}
