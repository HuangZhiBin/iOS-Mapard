//
//  MapardMapper.swift
//  Mapard
//
//  Created by bin on 2018/12/27.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

private var arrayTypeNamesKey: Void?

let SPACE_NAME = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
/**
 ViewController的View的扩展方法
 */
extension BaseModel {
    
    var arrayTypeNames : [String : String]? {
        get {
            return objc_getAssociatedObject(self, &arrayTypeNamesKey) as? [String : String] ;
        }
        set(newValue) {
            objc_setAssociatedObject(self, &arrayTypeNamesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
     };
    
    private func mapForProperty(obj: AnyObject, dict: Dictionary<String, Any>, typeName : String, propertyName: String){
        var propertyValue = dict[propertyName];
        
        
        if(propertyName.hasPrefix(TMP_VAR_NAME_PREFIX)){
            propertyValue = dict[propertyName.replacingOccurrences(of: TMP_VAR_NAME_PREFIX, with: "")];
        }
        
        if propertyValue == nil || propertyValue is NSNull {
            return;
        }
        
        if(typeName == "NSString") {
            obj.setValue(propertyValue, forKey: propertyName);
        }
        else if(typeName == "NSNumber") {
            if(propertyValue is Bool){
                obj.setValue((propertyValue as! Bool) ? NSNumber.init(value: true) : NSNumber.init(value: false) , forKey: propertyName);
                return;
            }
            obj.setValue(propertyValue, forKey: propertyName);
        }
        else if(typeName == "NSDecimalNumber") {
            obj.setValue(propertyValue, forKey: propertyName);
        }
        else if(typeName == "NSDate") {
            let dateStr :String = propertyValue as! String;
            if(dateStr.count == 10){
                let date : Int = Int(dateStr)!;
                obj.setValue(Date.init(timeIntervalSince1970: TimeInterval(date)), forKey: propertyName);
            }
            else if(dateStr.count == 13){
                let date : Double = Double(dateStr)!/1000;
                obj.setValue(Date.init(timeIntervalSince1970: TimeInterval(date)), forKey: propertyName);
            }
        }
        else if(typeName == "NSArray"){
            var array : [AnyObject] = [];
            
            guard let arr : [Any] = propertyValue as? Array else {
                return;
            }
            
//            obj.setValue([], forKey: propertyName);
//            let arrayType : Array.Type = type(of: obj.value(forKey: propertyName) as! Array<Any>)
//            let carType = arrayType.Element.self  // Car.Type
//            print("arr type = " + String(describing: carType))           // "Car"
            
            for arrItem in arr{
                let modelDict : Dictionary<String,Any> = arrItem as! Dictionary<String, Any>;
                
                guard ((obj as! BaseModel).arrayTypeNames != nil) else {
                    fatalError("should add arrayTypeName for array " + propertyName);
                    break;
                }
                
                let arrTypeName : String = (obj as! BaseModel).arrayTypeNames![propertyName]!;
                //self.arrayTypeNames[propertyName]!;
                let vcClass: AnyClass? = NSClassFromString(SPACE_NAME + "." + arrTypeName) //VCName:表示试图控制器的类名
                // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
                let typeClass : BaseModel.Type = vcClass as! BaseModel.Type;
                let model = typeClass.init(coder: nil);
                
                let properties : [String:String] = self.getProperties(obj: model);
                for item in properties.keys{
                    let typeName : String = properties[item]!;
                    let propertyName : String = item;
                    
                    self.mapForProperty(obj: model, dict:modelDict, typeName: typeName, propertyName: propertyName);
                }
                
                array.append(model);
            }
            
            obj.setValue(array, forKey: propertyName);
        }
        else if(typeName.hasSuffix("Model")){
            guard let modelDict : Dictionary<String,Any> = propertyValue as? Dictionary<String, Any> else {
                return;
            };
            
            let vcClass: AnyClass? = NSClassFromString(typeName) //VCName:表示试图控制器的类名
            // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
            let typeClass : BaseModel.Type = vcClass as! BaseModel.Type;
            let model = typeClass.init(coder: nil);
            
            let properties : [String:String] = self.getProperties(obj: model);
            for item in properties.keys{
                let typeName : String = properties[item]!;
                let propertyName = item;
                
                self.mapForProperty(obj: model, dict:modelDict, typeName: typeName, propertyName: propertyName);
            }
            
            obj.setValue(model, forKey: propertyName);
        }
    }
    
    func modelFrom(dataDict : Dictionary<String,Any>){
        let properties : [String:String] = self.getProperties(obj: self);
        for item in properties.keys{
            let typeName : String = properties[item]!;
            let propertyName : String = item;
            self.mapForProperty(obj: self, dict: dataDict, typeName: typeName, propertyName: propertyName);
        }
    }
    
    func getAllProperties(obj : AnyObject) -> [String]{
        var properties : [String] = [];
        var count: UInt32 = 0
        //获取类的属性列表,返回属性列表的数组,可选项
        
        let list = class_copyPropertyList(obj.classForCoder, &count)
        //print("属性个数:\(count)")
        //遍历数组
        for i in 0..<Int(count) {
            //根据下标获取属性
            let pty = list?[i]
            //获取属性的名称<C语言字符串>
            //转换过程:Int8 -> Byte -> Char -> C语言字符串
            let cName = property_getName(pty!)
            //转换成String的字符串
            let name = String(utf8String: cName)
            //            //print(name!);
            properties.append(name!);
        }
        free(list) //释放list
        return properties;
    }
    
    func getProperties(obj : AnyObject) -> [String:String]{
        var properties : [String:String] = [:];
        var count: UInt32 = 0
        //获取类的属性列表,返回属性列表的数组,可选项
        
        let list = class_copyPropertyList(obj.classForCoder, &count)
        //print("属性个数:\(count)")
        //遍历数组
        for i in 0..<Int(count) {
            //根据下标获取属性
            let pty : objc_property_t? = list?[i]
            //获取属性的名称<C语言字符串>
            //转换过程:Int8 -> Byte -> Char -> C语言字符串
            let cName = property_getName(pty!)
            let tName = property_copyAttributeValue(pty!, "T");
            //转换成String的字符串
            let name : String = String(utf8String: cName)!
            let typeName : String = String(utf8String: tName!)!
//            let pattern = "[A-Z_][A-Za-z]*";
//            let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue:0));
//            let res = regex.matches(in: typeName!, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, (typeName?.count)!));
            
            //print(name);
            
            
//            let range = res[res.count-1].range;
            let realTypeName = String((typeName as NSString).replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "\"", with: ""));
            //print(realTypeName);
            properties[name] = realTypeName;
//            properties[name!] = String(typeName!);
//            //print(properties[name]);
            //print("========");
            /*
            var count2: UInt32 = 0
            let list2 = property_copyAttributeList(pty!, &count2)
            //print("属性个数:\(count2)")
            //遍历数组
            for i in 0..<Int(count2) {
                //根据下标获取属性
                let attribute : objc_property_attribute_t = list2![i]
                //const char *name = attribute.name;
                //const char *value = attribute.value;
                //NSLog(@"attribute name: %s, value: %s", name, value);
                let name = String(utf8String: attribute.name);
                let value = String(utf8String: attribute.value);
                //print(name);
                //print(value);
            }
            free(list2) //释放list
            //print(">>>>>>>");
 */
        }
        free(list) //释放list
        return properties;
    }

}
