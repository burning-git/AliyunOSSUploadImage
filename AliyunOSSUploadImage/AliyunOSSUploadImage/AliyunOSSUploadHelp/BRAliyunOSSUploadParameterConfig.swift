//
//  BRAliyunOSSUploadParameterConfig.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/14.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

class BRAliyunOSSUploadParameterConfig: NSObject {
    
    enum kHttpMethod {
        case post
        case get
        
        func br_getNameStr() -> String {
            var name = ""
            switch self {
            case .post:
                name = "POST"
            default:
                name = "GET"
            }
            return name
        }
    }
    
    override init() {}
    static let `default` = BRAliyunOSSUploadParameterConfig()
    var mConfigHttpHeaderBlock:((_ otherInfo:Any?)->([String:String]?))?
    
    var mCustomParseReturnDataBlock:((_ otherInfo:Any?,_ dictData:Any?)->())?
    ///  获取 sts token url
    var mSTSTokenUrl:String?
    var mRootKey:String? = "data"
    var mEndpoint:String?
    var mBucketName:String?
    
    var httpMethod:kHttpMethod = kHttpMethod.post

}

