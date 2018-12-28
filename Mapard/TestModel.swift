//
//  TestModel.swift
//  Mapard
//
//  Created by bin on 2018/12/27.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

// [Mapard] Model类必须继承BaseModel,如已有原AbcBaseModel,使AbcBaseModel继承BaseModel
class TestModel: BaseModel {
    @objc var title : String?;// [Mapard] 属性必须支持objc，否则转化失败
    @objc var time : Date?;
    @objc var data : DataModel?;
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
    }
}

class DataModel: BaseModel {
    @objc var cities : [CityModel]?; // 必须为数组变量定义其类型，代码如下
    @objc var info : String?;
    @objc var type : NSNumber?;
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
        // [Mapard] 为数组变量定义其类型
        self.arrayTypeNames = ["cities":"CityModel"];
    }
}

class CityModel: BaseModel {
    
    @objc var id : NSNumber?;
    @objc var name : String?;
    @objc var population : NSNumber?;
    
    //@objc var latitude : NSNumber?;
    // [Mapard] 当属性必须不支持objc时,如Int/Float/Double/Bool，在考虑新增变量的基础上，可借助辅助变量__latitude支持objc，并设置原变量的getter和setter，变量名前缀'___'须与Mapard的TMP_VAR_NAME_PREFIX定义的值一致；如不增加辅助变量，则需要把Int/Float/Double/Bool类型定义为objc支持的类型
    @objc var ___latitude : NSNumber?;
    var latitude : Double?{
        set{
            ___latitude = NSNumber.init(value: newValue!);
        }
        get{
            return ___latitude?.doubleValue;
        }
    };
    
    //@objc var longitude : NSNumber?;
    @objc var ___longitude : NSNumber?;
    var longitude : Double?{
        set{
            ___longitude = NSNumber.init(value: newValue!);
        }
        get{
            return ___longitude?.doubleValue;
        }
    };
    
    //@objc var isHot : NSNumber?;
    @objc var ___isHot : NSNumber?;
    var isHot : Bool?{
        set{
            ___isHot = NSNumber.init(value: newValue!);
        }
        get{
            return ___isHot?.boolValue;
        }
    };
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
    }
    
}
