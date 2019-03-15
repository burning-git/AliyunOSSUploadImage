//
//  BRAliyunOSSUploadGroupHelp.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/15.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

class BRAliyunOSSUploadGroupHelp: BRAliyunOSSUploadHelp {
    
    class func br_uploadGrounpImg(datas:[Data]?,ossInfo:[AnyHashable:Any]?,businessCode:String?,max:Int = 6) {
        
        if let datas = datas,datas.count > 0, let temp_dict = ossInfo {
            let quene = BROperationQueueFinish.init()
            quene.maxConcurrentOperationCount = max
            quene.isSuspended = true
            
            let  dir = temp_dict["dir"] as? String
            let  SecurityToken = temp_dict["SecurityToken"] as? String ?? ""
            //let  Expiration = temp_dict["Expiration"] as? String ?? ""
            let  AccessKeySecret = temp_dict["AccessKeySecret"] as? String ?? ""
            let  AccessKeyId = temp_dict["AccessKeyId"] as? String ?? ""
            let  showPreUrl = temp_dict["showPreUrl"] as? String
            let  bucketName = temp_dict["bucketName"] as? String
            let  endPoint = temp_dict["endPoint"] as? String
            datas.enumerated().forEach { (index,obj) in
                
                let op = BlockOperation(block: {
                    let model = BRAliyunOSSUploadHelp.BRPutObjectModel()
                    model.dir = dir
                    model.SecurityToken = SecurityToken
                    model.AccessKeySecret = AccessKeySecret
                    model.AccessKeyId = AccessKeyId
                    model.showPreUrl = showPreUrl
                    model.bucketName = bucketName
                    model.endPoint = endPoint
                    model.businessCode = businessCode
                    model.fileName = String.br_randomUUID() + "." + ((obj as NSData).br_getDataType().br_lastName() )
                    model.br_configObjectKey()
                    let full_url = model.br_getFullStr()
                    BRAliyunOSSUploadHelp.br_ossUploadAImage(imgData: obj, customInfo: nil, requestModel: model, successBlock: { (success, rsp,customInfo, error) in
                        print(full_url)
                    })

                })
                quene.addOperation(op)
                
                
                
            }
            
            quene.isSuspended = false
        }

    }
   
    class BROperationQueueFinish: OperationQueue {
        
        var mFinishBlock:(()->())?
        
        override init() {
            super.init()
            self.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions.new, context: nil)
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if (object as?BROperationQueueFinish)  === self && keyPath == "operations"{
                print(self.operationCount)
            }
            else{
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
        
    }
}
