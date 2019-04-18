//
//  BRAliyunOSSUploadHelp.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/13.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit
//import AliyunOSSSwiftSDK
import AliyunOSSiOS
public class BRAliyunOSSUploadHelp: NSObject {
    
    
    
    /// 主线程
    ///
    /// - Parameter block: <#block description#>
   public class func br_uploadHelpOnMain(block:(()->())?) {
        if Thread.isMainThread {
            block?()
        }
        else{
            DispatchQueue.main.async {
                block?()
            }
        }
    }

    /// 自己需要的,其他地方使用忽略
    ///
    /// - Parameters:
    ///   - headerInfo: <#headerInfo description#>
    ///   - url: <#url description#>
    ///   - block: <#block description#>
   public class func getOOSConfigToken(headerInfo:[String:String]?,url:String?,block:((_ success:Bool,_ dict:Any?)->())?) {
        var tempUrl = url
        if tempUrl == nil {
            tempUrl = BRAliyunOSSUploadParameterConfig.default.mSTSTokenUrl
        }
        
        let tcs = OSSTaskCompletionSource<AnyObject>()

        let url1: URL? = URL(string: tempUrl ?? "")
        guard let url = url1 else {
            block?(false,"url 获取失败")
            return
        }
        let config: URLSessionConfiguration = URLSessionConfiguration.default;
        
        let session: URLSession = URLSession(configuration: config, delegate: nil, delegateQueue: nil);
        var request = URLRequest(url: url)
        request.httpMethod = BRAliyunOSSUploadParameterConfig.default.httpMethod.br_getNameStr()
        
        let header_dict = BRAliyunOSSUploadParameterConfig.default.mConfigHttpHeaderBlock?(headerInfo)
        if request.allHTTPHeaderFields == nil {
            request.allHTTPHeaderFields = [String:String]()
        }
        header_dict?.forEach({ (arg) in
            let (key, value) = arg
            request.allHTTPHeaderFields?[key] = value
        })
        
        let rootKey = BRAliyunOSSUploadParameterConfig.default.mRootKey
        let task = session.dataTask(with: request) { (data, response, error) in
            
            
            BRAliyunOSSUploadHelp.br_uploadHelpOnMain(block: {
                
                if error == nil {
                    if let data = data {
                        tcs.setResult(data as AnyObject)
                        let json = try? JSONSerialization.jsonObject(with: tcs.task.result as! Data,
                                                                     options:.allowFragments)
                        if let rootKey = rootKey{
                            let relust_dict  =  (json as? [AnyHashable: Any])
                            block?(true,relust_dict?[rootKey])
                        }
                        else{
                            block?(true,json)
                        }
                        //print(json)
                        return
                    }
                }
                block?(false,error)
            })
          
        }
        task.resume()
    }

    //https://help.aliyun.com/document_detail/32063.html?spm=a2c4g.11186623.6.983.39569e0a0u7UBc
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - imgData: 文件data
    ///   - requestModel: 数据model
    ///   - updateProgressBlock: 进度回调
    ///   - customInfo :  自定义参数
    ///   - successBlock: 成功回调
   public class  func br_ossUploadAImage(imgData:Data?,customInfo:Any?,requestModel:BROSSPutObjectModel?,successBlock:((_ success:Bool,_ dataInfo:Any? ,_ customInfo:Any?,_ error:Error?)->())?,updateProgressBlock:((_ bytesSent: Int64, _ totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64,_ customInfo:Any?)->())? = nil) {
        
        if let imgData = imgData{
            
            let config = BRAliyunOSSUploadParameterConfig.default
            var bucketName_temp = requestModel?.bucketName
            if bucketName_temp == nil {
                bucketName_temp = config.mBucketName
            }
            var endPoint_temp = requestModel?.endPoint
            if endPoint_temp == nil {
                endPoint_temp = config.mEndpoint
            }
            guard let bucketName = bucketName_temp ,let endPoint = endPoint_temp else {
                successBlock?(false,"bucketName、endPoint没有数据",customInfo,nil)
                return
            }
            guard let objectKey = requestModel?.objectKey else {
                successBlock?(false,"文件名称没有传",customInfo,nil)
                return
            }
            let request = OSSPutObjectRequest()
            request.bucketName = bucketName
            request.uploadingData = imgData
            request.objectKey = objectKey
            var provider:OSSCredentialProvider?
            if requestModel?.AccessKeySecret == nil{//自签名、STS 签名
                provider = OSSAuthCredentialProvider(authServerUrl: config.mSTSTokenUrl ?? "")
            }
            else{
                if let accessKeyId = requestModel?.AccessKeyId,let secretKeyId = requestModel?.AccessKeySecret,let securityToken = requestModel?.SecurityToken{
                     provider = OSSStsTokenCredentialProvider(accessKeyId: accessKeyId, secretKeyId: secretKeyId, securityToken: securityToken)
                }
            }
            if let provider = provider{
                let client = OSSClient(endpoint: endPoint, credentialProvider: provider)
                
                request.uploadProgress = { (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
                    print("bytesSent:\(bytesSent),totalBytesSent:\(totalBytesSent),totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
                    updateProgressBlock?(bytesSent,totalBytesSent,totalBytesExpectedToSend,customInfo)
                };
                let task = client.putObject(request)
                task.continue({ (t) -> Any? in
                    //self.showResult(task: t)
                    
                    BRAliyunOSSUploadHelp.br_uploadHelpOnMain(block: {
                        if task.error != nil {
                            successBlock?(false,nil,customInfo,task.error)
                        }
                        else{
                            successBlock?(true,task.result,customInfo,nil)
                        }
                    })
                    return nil

                    
                }).waitUntilFinished()

            }
            
        }
    }
    
}
