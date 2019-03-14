//
//  ViewController.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/13.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

extension String {
    /// 生成随机字符串 /// /// - Parameters: ///   - count: 生成字符串长度 ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false /// - Returns: String
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
            if num>57 && num<65 && isLetter==false
            { num = num%57+48 }
            else if num>90 && num<97 {
                num = num%90+65
                
            }
            ch[index] = CChar(num)
            
        }
        return String(cString: ch)
        
    }
    
}
   
class ViewController: UIViewController {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    let help = BRAliyunOSSUploadHelp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        help.br_configOSS()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func br_uploadImgAction(_ sender: UIButton) {
        let img = UIImage(named: "tempImg")
        guard let img1 = img else {
            return
        }
        let data1 = UIImage.jpegData(img1)
    
        activityView.startAnimating()
        
        let businessCode = "555-55"
        
        let url = "http://10.13.50.3:8182/hospital/image/getOssSignForApp?businessCode" + businessCode
        BRAliyunOSSUploadHelp.getOOSConfigToken(headerInfo: nil, url: url) { (success, info) in
            if let temp_dict_list = info as? [Any], let temp_dict = temp_dict_list.first as? [AnyHashable:Any]
            {
                let  dir = temp_dict["dir"] as? String
                let  SecurityToken = temp_dict["SecurityToken"] as? String ?? ""
                //let  Expiration = temp_dict["Expiration"] as? String ?? ""
                let  AccessKeySecret = temp_dict["AccessKeySecret"] as? String ?? ""
                let  AccessKeyId = temp_dict["AccessKeyId"] as? String ?? ""
                let  showPreUrl = temp_dict["showPreUrl"] as? String
                let  bucketName = temp_dict["bucketName"] as? String
                let  endPoint = temp_dict["endPoint"] as? String
                let model = BRAliyunOSSUploadHelp.BRPutObjectModel()
                model.dir = dir
                model.SecurityToken = SecurityToken
                model.AccessKeySecret = AccessKeySecret
                model.AccessKeyId = AccessKeyId
                model.showPreUrl = showPreUrl
                model.bucketName = bucketName
                model.endPoint = endPoint
                model.businessCode = businessCode
                model.fileName = String.random(32) + ".png"
                model.br_configObjectKey()
                let full_url = model.br_getFullStr()
                
                BRAliyunOSSUploadHelp.br_ossUploadAImage(imgData: data1(0.6), requestModel: model, successBlock: { (success, info, error) in
                    if success {
                        print(full_url)
                    }
                })
                
            }
           
            
        }
    }
}

