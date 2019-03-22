//
//  BRAliyunOSSUploadGroupHelp.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/15.
//  Copyright © 2019年 git burning. All rights reserved.
//  test1

import UIKit

public class BRAliyunOSSUploadGroupHelp: BRAliyunOSSUploadHelp {
    
   public class func br_uploadGrounpImg(
        datas:[BROSSPutObjectModel]?,
        ossInfo:[AnyHashable:Any]?,
        businessCode:String?,
        uploadSuccessBlock:((_ success:Bool, _ error:Error?)->())? = nil,
        max:Int = 6)
    {
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
            
            //有data，同时 uploadSuccessPicUrl = nil,代表未上传数据
            
            let data_array = datas.filter({$0.mData != nil && $0.uploadSuccessPicUrl == nil})
            
            quene.mFinishBlock = { ()in
                uploadSuccessBlock?(true,nil)
            }
            data_array.enumerated().forEach { (index,obj) in
                if let mData = obj.mData {
                    let op = BlockOperation(block: {
                        let model = obj
                        model.dir = dir
                        model.SecurityToken = SecurityToken
                        model.AccessKeySecret = AccessKeySecret
                        model.AccessKeyId = AccessKeyId
                        model.showPreUrl = showPreUrl
                        model.bucketName = bucketName
                        model.endPoint = endPoint
                        if businessCode != nil {
                            model.businessCode = businessCode
                        }
                        
                        model.fileName = String.br_randomUUID() + "." + ((mData as NSData).br_getDataType().br_lastName())
                        model.br_configObjectKey()
                        model.mCustomDataUpdateBlock?(model)
                        
//                        let full_url = model.br_getFullStr()
                        BRAliyunOSSUploadHelp.br_ossUploadAImage(imgData: mData, customInfo: obj, requestModel: model, successBlock: { (success, rsp,customInfo, error) in
                            if success {
                                model.uploadSuccessPicUrl = model.br_getFullStr()
                                model.mUploadASuccessBlock?(customInfo as? BROSSPutObjectModel)
                            }
                            else{
                                quene.cancelAllOperations()
                                uploadSuccessBlock?(false,error)
                            }
                        })
                    })
                    quene.addOperation(op)
                }
            }
            
            
            if data_array.count <= 0 {
                let error = NSError.init(domain: "无需上传图片", code: 0, userInfo: nil)
                uploadSuccessBlock?(false,error)
            }
            else{
                quene.isSuspended = false

            }
        }
        else{
            let msg = NSError(domain: "无图片或者无ossinfo", code: -10, userInfo: nil)
            uploadSuccessBlock?(false,msg)
        }
    }
   
   public class BROperationQueueFinish: OperationQueue {
        
        var mFinishBlock:(()->())?
        
        override init() {
            super.init()
            self.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions.new, context: nil)
        }
        
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if (object as?BROperationQueueFinish)  === self && keyPath == "operations"{
                print(self.operationCount)
                if self.operationCount == 0{
                    self.mFinishBlock?()
                    self.cancelAllOperations()
                }
            }
            else{
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
        
    }
}
