//
//  TestModel.swift
//  Mapard
//
//  Created by bin on 2018/12/27.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class TestModel: BaseModel {
    @objc var time : String?;
    @objc var data : DataModel?;
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
    }
}

class DataModel: BaseModel {
    @objc var cities : [CityModel]?;
    @objc var info : String?;
    @objc var type : NSNumber?;
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
        self.arrayTypeNames = ["cities":"CityModel"];
    }
}

class CityModel: BaseModel {
    
    @objc var id : NSNumber?;
    @objc var name : String?;
    
    @objc var __latitude : NSNumber?;
    var latitude : Double?{
        set{
            __latitude = NSNumber.init(value: newValue!);
        }
        get{
            return __latitude?.doubleValue;
        }
    };
    
    @objc var __longitude : NSNumber?;
    var longitude : Double?{
        set{
            __longitude = NSNumber.init(value: newValue!);
        }
        get{
            return __longitude?.doubleValue;
        }
    };
    
    @objc var population : NSNumber?;
    
    @objc var __isHot : NSNumber?;
    var isHot : Bool?{
        set{
            __isHot = NSNumber.init(value: newValue!);
        }
        get{
            return __isHot?.boolValue;
        }
    };
    
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
    }
    
}
