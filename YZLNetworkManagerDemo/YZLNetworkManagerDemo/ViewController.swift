//
//  ViewController.swift
//  YZLNetworkManagerDemo
//
//  Created by Xu Chen on 2018/8/4.
//  Copyright © 2018年 xu.yzl. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        loadWebData()
    }

    func loadWebData() {
        let activityIndicatorView: UIActivityIndicatorView?
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView?.activityIndicatorViewStyle = .gray
        activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicatorView?.center = view.center
        activityIndicatorView?.startAnimating()
        view.addSubview(activityIndicatorView!)
        
        let urlString = "http://t.268xue.com/app/index/banner"
        let parameters: [String: Any] = ["id": "2203.2b ", "name": "萧山"]
        
        YZLNetworkManager.shared.request(urlString: urlString, parameterDict: parameters) { (json, isSuccess) in
            let result = json as? [String: Any]
            let resultDict = result?["entity"] as? [[String: Any]]
            print("接口返回结果为： \(String(describing: result)) - \(String(describing: resultDict)) = \(isSuccess)")

//            activityIndicatorView?.stopAnimating()
        }

    }

}

