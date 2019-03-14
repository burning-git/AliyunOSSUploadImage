//
//  ViewController.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/13.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

extension String {

    
    
    /// 随机生成UUID
    ///
    /// - Returns: <#return value description#>
    static func randomUUID() -> String{
        let uuid_ref = CFUUIDCreate(kCFAllocatorDefault)
        let uuid_string_ref = CFUUIDCreateString(kCFAllocatorDefault , uuid_ref)
        let uuid = uuid_string_ref! as String
        print(uuid + "UUID:")
        return uuid
    }
    
}
   
class ViewController: UIViewController {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    let help = BRAliyunOSSUploadHelp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func br_uploadGrounpImg(datas:[Data]?,info:[AnyHashable:Any]?,businessCode:String?) {
        if let datas = datas,datas.count > 0, let temp_dict = info {
            
            let group = DispatchGroup()

            let  dir = temp_dict["dir"] as? String
            let  SecurityToken = temp_dict["SecurityToken"] as? String ?? ""
            //let  Expiration = temp_dict["Expiration"] as? String ?? ""
            let  AccessKeySecret = temp_dict["AccessKeySecret"] as? String ?? ""
            let  AccessKeyId = temp_dict["AccessKeyId"] as? String ?? ""
            let  showPreUrl = temp_dict["showPreUrl"] as? String
            let  bucketName = temp_dict["bucketName"] as? String
            let  endPoint = temp_dict["endPoint"] as? String
            datas.enumerated().forEach { (index,obj) in
                
                let model = BRAliyunOSSUploadHelp.BRPutObjectModel()
                model.dir = dir
                model.SecurityToken = SecurityToken
                model.AccessKeySecret = AccessKeySecret
                model.AccessKeyId = AccessKeyId
                model.showPreUrl = showPreUrl
                model.bucketName = bucketName
                model.endPoint = endPoint
                model.businessCode = businessCode
                model.fileName = String.randomUUID() + ".png"
                model.br_configObjectKey()
                let full_url = model.br_getFullStr()
                group.enter()
                BRAliyunOSSUploadHelp.br_ossUploadAImage(imgData: obj, requestModel: model, successBlock: { (success, rsp, error) in
                    group.leave()
                    print(full_url)
                })
                
                
            }
            
            
            group.notify(queue: DispatchQueue.main) {
                print("上传完成")
            }
            
            
            
        }
    }
    

    @IBAction func br_uploadImgAction(_ sender: UIButton) {
        let img = UIImage(named: "tempImg")
        guard let img1 = img else {
            return
        }
        
        let img2 = UIImage(named: "wechat")
        guard let img3 = img2 else {
            return
        }
        
        let data1 = UIImage.jpegData(img1)
        let data2 = UIImage.jpegData(img3)

        activityView.startAnimating()
        
        let businessCode = "555-55"
        
        let url = "http://10.13.50.3:8182/hospital/image/getOssSignForApp?businessCode" + businessCode
        BRAliyunOSSUploadHelp.getOOSConfigToken(headerInfo: nil, url: url) { (success, info) in
            if let temp_dict_list = info as? [Any], let temp_dict = temp_dict_list.first as? [AnyHashable:Any]
            {
                
                self.br_uploadGrounpImg(datas: [data1(0.6)!,data2(0.6)!], info: temp_dict, businessCode: businessCode)
//                let  dir = temp_dict["dir"] as? String
//                let  SecurityToken = temp_dict["SecurityToken"] as? String ?? ""
//                //let  Expiration = temp_dict["Expiration"] as? String ?? ""
//                let  AccessKeySecret = temp_dict["AccessKeySecret"] as? String ?? ""
//                let  AccessKeyId = temp_dict["AccessKeyId"] as? String ?? ""
//                let  showPreUrl = temp_dict["showPreUrl"] as? String
//                let  bucketName = temp_dict["bucketName"] as? String
//                let  endPoint = temp_dict["endPoint"] as? String
//                let model = BRAliyunOSSUploadHelp.BRPutObjectModel()
//                model.dir = dir
//                model.SecurityToken = SecurityToken
//                model.AccessKeySecret = AccessKeySecret
//                model.AccessKeyId = AccessKeyId
//                model.showPreUrl = showPreUrl
//                model.bucketName = bucketName
//                model.endPoint = endPoint
//                model.businessCode = businessCode
//                model.fileName = String.random(32) + ".png"
//                model.br_configObjectKey()
//                let full_url = model.br_getFullStr()
//
//                BRAliyunOSSUploadHelp.br_ossUploadAImage(imgData: data1(0.6), requestModel: model, successBlock: { (success, info, error) in
//                    if success {
//                        print(full_url)
//                    }
//                })
                
            }
           
            
        }
    }
}

