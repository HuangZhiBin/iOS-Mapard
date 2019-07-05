# Mapard
代码不再更新，最新代码请参考https://github.com/HuangZhiBin/Mapard
### 将Dictionary转为Model的iOS工具

网络请求中很多返回数据都是Dictionary的格式，提供Dictionary转为Model的工具，将省去写mapper的时间，让开发更高效。

> Mapard is an iOS Utility that converts Dictionary to Model.

![](http://wxtopik.oss-cn-shanghai.aliyuncs.com/app/images/1545988181497.jpg)

### Ausbin框架实现语言
`Swift4`

### Ausbin框架核心技术
`KVO` `反射` `runtime`

### Ausbin框架版本
`1.0.0`

### 例子
（1）以TestModel作为例子，在使用Mapard转化model之前，保证被转化的model的类遵循下面的3条规则：

```swift
// [Mapard] 1. Model类必须继承BaseModel,如已有原AbcBaseModel,使AbcBaseModel继承BaseModel
class TestModel: BaseModel {
    @objc var title : String?;// [Mapard] 2. 属性必须支持objc，否则转化失败
    @objc var cities : [CityModel]?; // [Mapard] 3. 必须为数组变量定义其类型，代码如下
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: nil);
        // 为数组变量定义其类型,key为数组的变量名,value为数组元素的类名
        self.arrayTypeNames = ["cities":"CityModel"];
    }
}
```
（2）将Dictionary转为Model，只需要在初始化model后执行代码`testModel.modelFrom();`
```swift
    let testModel : TestModel = TestModel.init(coder: nil);
    testModel.modelFrom(dataDict: dict);
```

##### 最终效果
![](http://wxtopik.oss-cn-shanghai.aliyuncs.com/app/images/1545990189420.gif)
------------

### 关于@objc不支持Int/Float/Double/Bool的情况
当model的属性不支持objc时,如变量是Int/Float/Double/Bool时，将无法成功转化（KVO）。<br>在考虑新增变量的基础上，可借助辅助变量支持objc，并设置原变量的getter和setter。变量名前缀(例如'___')须与Mapard的TMP_VAR_NAME_PREFIX定义的值一致；如不增加辅助变量，则需要把Int/Float/Double/Bool类型定义为objc支持的类型，比如NSNumber类型。<br>下面以latitude(纬度，值为Double):
```swift
    @objc var ___latitude : NSNumber?; // 辅助变量
    var latitude : Double?{
        set{
            // 重写setter
            ___latitude = NSNumber.init(value: newValue!);
        }
        get{
            // 重写getter
            return ___latitude?.doubleValue;
        }
    };
```

### 扩展
分析一下实际业务应用时可能遇到的情况。
- 1.&nbsp;Mapard的测试案例分为三种，data.json、data2.json、data3.json(参考文件夹/Mapard/Json/),针对不同的数据情况进行测试
- 2.&nbsp;Mapard当前支持的json变量涵盖大部分的常用类型，包括int/string/boolean/date/double/等类型
- 3.&nbsp;Mapard兼容**model互相嵌套**的情况
- 4.&nbsp;Mapard兼容数组为空数组、为nil的情况
- 5.&nbsp;Mapard兼容变量不存在，以及变量值为nil的情况

### 讨论
项目还存在以下的问题，欢迎批评指正：
- 1.&nbsp;如何更加方便地引入Mapard？（代码更精简）
- 2.&nbsp;除了runtime和KVO外，有其他更好的转化思想吗？
- 3.&nbsp;Mapard存在哪些问题？

待续……

| Item      | Value |
| --------- | -----:|
| 作者  | **黄智彬** |
| 原创  | **YES** |
| 微信  | **ikrboy** |
| 邮箱  |   **ikrboy@163.com** |
