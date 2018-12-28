//
//  ViewController.swift
//  Mapard
//
//  Created by bin on 2018/12/27.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let NETWORK_TIMEOUT : Int = 15;
    private func getManager() -> AFHTTPSessionManager{
        let manager = AFHTTPSessionManager();
        manager.requestSerializer.timeoutInterval = TimeInterval(NETWORK_TIMEOUT);
        var set = Set<String>();
        set.insert("application/json");
        manager.responseSerializer.acceptableContentTypes = set;
        return manager;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white;
        
        let urlString = "https://www.koudaikr.cn/ios/data.json";
        
        let parameters : [String : Any] = [:];
        
        self.getManager().get(urlString, parameters: parameters, progress: {(progress : Progress) -> Void in
            
        }, success: {(task : URLSessionDataTask, responseObj : Any?) -> Void in
            
            let responseDict = responseObj as! Dictionary<String, Any>;
            let test : TestModel = TestModel.init(coder: nil);
            test.modelFrom(dataDict: responseDict);
            print(test.time);
            test.data?.cities![1].latitude = 1111.21123213;
            print(test.time);
        }, failure: {(task : URLSessionDataTask?, error: Error) -> Void in
            
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

