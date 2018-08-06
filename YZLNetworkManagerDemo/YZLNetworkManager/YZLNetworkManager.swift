//
//  YZLNetworkManager.swift
//  YZLNetworkManagerDemo
//
//  Created by Xu Chen on 2018/8/4.
//  Copyright © 2018年 xu.yzl. All rights reserved.
//  网络管理工具

import UIKit

class YZLNetworkManager: AFHTTPSessionManager {
    /// 单例创建对象 - 在第一次访问时，执行闭包，并且将结果保存在常量 shared 中
    static let shared = { ()->YZLNetworkManager in
        let instance = YZLNetworkManager()
        // 响应反序列化支持的类型
        instance.responseSerializer.acceptableContentTypes = ["text/plain","text/json","text/html","text/javascript","application/json"]
        // 设置请求头
        instance.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        // 请求超时时间，默认为 60 s
        instance.requestSerializer.timeoutInterval = 20.0
        return instance
    }()
    
    /// 封装网络请求
    ///
    /// - Parameters:
    ///   - isPost: 是否为 post 请求，默认为 true
    ///   - urlString: urlString
    ///   - parameterDict: 参数字典，可以为 nil
    ///   - completion: 完成回调
    func request(isPost: Bool = true,
                 urlString: String,
                 parameterDict: [String: Any]?,
                 completion: @escaping (_ resultData: Any?, _ isSuccess: Bool)->()) {
        // 打印接口地址
        printRequestUrlString(urlString: urlString, parameterDict: parameterDict)
        
        // 创建请求成功、失败回调的闭包
        let successClosure = { (task: URLSessionDataTask, resultData: Any?)->() in
            completion(resultData, true)
        }
        let failureClosure = { (task: URLSessionDataTask?, error: Error)->() in
            print("网络请求失败 - \(error) \n失败描述 - \(error.localizedDescription)")
            if let errorCode = (task?.response as? HTTPURLResponse)?.statusCode {
                print("网络请求失败错误码 - \(errorCode)")
            }
            completion(nil, false)
        }
        
        // 发送请求
        if isPost { // post 请求
            self.post(urlString, parameters: parameterDict, progress: nil, success: successClosure, failure: failureClosure)
        } else { // get 请求
            self.get(urlString, parameters: parameterDict, progress: nil, success: successClosure, failure: failureClosure)
        }
        
    }
    
    /// 打印接口地址
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - parameterDict: parameterDict
    private func printRequestUrlString(urlString: String, parameterDict: [String: Any]?) {
        // 设置默认的接口地址
        var requestUrlString = urlString
        // 拼接参数字典中的 key value
        if parameterDict != nil {
            requestUrlString += "?"
            var tmpKeyValues = [String]()
            for key in parameterDict!.keys {
                var valueString: String = ""
                // 当 value 值不是 String 类型时，需要转化一下类型
                if let value = parameterDict![key] as? String {
                    valueString = value
                } else {
                    valueString = "\(String(describing: (parameterDict![key]) ?? ""))"
                }
                let keyValueString = key + "=" + valueString
                tmpKeyValues.append(keyValueString)
            }
            requestUrlString += (tmpKeyValues as NSArray).componentsJoined(by: "&")
        }
        print("接口地址: \n\(requestUrlString)")
    }
    
    // FIXME: xu - 待加入网络缓存功能
}
