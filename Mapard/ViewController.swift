//
//  ViewController.swift
//  Mapard
//
//  Created by bin on 2018/12/27.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private func getManager() -> AFHTTPSessionManager{
        let NETWORK_TIMEOUT : Int = 15;
        let manager = AFHTTPSessionManager();
        manager.requestSerializer.timeoutInterval = TimeInterval(NETWORK_TIMEOUT);
        var set = Set<String>();
        set.insert("application/json");
        manager.responseSerializer.acceptableContentTypes = set;
        return manager;
    }
    
    lazy var label : UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 120, width: 400, height: 500));
        label.text = "在这里显示model的值";
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: 14);
        label.textColor = UIColor.black
        return label;
    }();
    
    lazy var btn : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 50, width: 80, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("加载data1", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 100, y: 50, width: 80, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("加载data2", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.red;
        return btn;
    }();
    
    lazy var btn3 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 190, y: 50, width: 80, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("加载data3", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.orange;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white;
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        self.view.addSubview(self.btn2);
        self.view.addSubview(self.btn3);
        
        self.btn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside);
        self.btn2.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside);
        self.btn3.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside);
    }
    
    @objc func btnAction(_ sender: UIButton){
        var jsonName = "data.json";
        if(sender == self.btn2){
            jsonName = "data2.json";
        }
        else if(sender == self.btn3){
            jsonName = "data3.json";
        }
        let urlString = "https://www.koudaikr.cn/ios/" + jsonName;
        
        let parameters : [String : Any] = [:];
        
        self.getManager().get(urlString, parameters: parameters, progress: {(progress : Progress) -> Void in
            
        }, success: {(task : URLSessionDataTask, responseObj : Any?) -> Void in
            
            let dict = responseObj as! Dictionary<String, Any>;
            let testModel : TestModel = TestModel.init(coder: nil);
            /*
                [Mapard] model初始化之后调用转化方法，转化之前记得遵循model的编写规则：
                    1. Model类必须继承BaseModel,如已有原AbcBaseModel,使AbcBaseModel继承BaseModel
                    2. Model类的所有属性必须支持@objc，否则转化失败
                    3. Model类的数组变量必须为其定义其类型
            */
            testModel.modelFrom(dataDict: dict);
            self.printModel(model: testModel);
        }, failure: {(task : URLSessionDataTask?, error: Error) -> Void in
            
        });
    }
    
    func printModel(model : TestModel){
        var str = "";
        str = str + "title : " + (model.title ?? "nil") + "\n";
        str = str + "time : " + ((model.time != nil) ? "\(model.time!)":  "nil") + "\n";
        str = str + "data : " + ((model.data != nil) ? "":  "nil") + "\n";
        if(model.data != nil){
            
            str = str + "       - info : " + ((model.data?.info != nil) ? (model.data!.info)!:  "nil") + "\n";
            str = str + "       - type : " + ((model.data?.type != nil) ? "\((model.data!.type)!)":  "nil") + "\n";
            
            str = str + "       - cities : " + ((model.data?.cities != nil) ? "("+String(describing: model.data!.cities!.count)+")":  "nil") + "\n";
            
            if(model.data?.cities != nil){
                for (index,item) in (model.data?.cities)!.enumerated(){
                    str = str + "              - (item " + String(index) + ")\n";
                    str = str + "                     - id : " + ((item.id != nil) ? "\((item.id)!)":  "nil") + "\n";
                    str = str + "                     - name : " + ((item.name != nil) ? "\((item.name)!)":  "nil") + "\n";
                    str = str + "                     - latitude : " + ((item.latitude != nil) ? "\((item.latitude)!)":  "nil") + "\n";
                    str = str + "                     - longitude : " + ((item.longitude != nil) ? "\((item.longitude)!)":  "nil") + "\n";
                    str = str + "                     - population : " + ((item.population != nil) ? "\((item.population)!)":  "nil") + "\n";
                    str = str + "                     - isHot : " + ((item.isHot != nil) ? "\((item.isHot)!)":  "nil") + "\n";
                }
                
            }
        }
        print(str);
        self.label.text = str;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

