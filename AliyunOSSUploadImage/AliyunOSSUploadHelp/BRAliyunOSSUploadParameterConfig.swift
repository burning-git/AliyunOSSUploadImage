//
//  BRAliyunOSSUploadParameterConfig.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/14.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

public class BRAliyunOSSUploadParameterConfig: NSObject {
    
    public enum kHttpMethod {
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
   public static let `default` = BRAliyunOSSUploadParameterConfig()
   public var mConfigHttpHeaderBlock:((_ otherInfo:Any?)->([String:String]?))?
    
   public var mCustomParseReturnDataBlock:((_ otherInfo:Any?,_ dictData:Any?)->())?
    ///  获取 sts token url
   public var mSTSTokenUrl:String?
   public var mRootKey:String? = "data"
   public var mEndpoint:String?
   public var mBucketName:String?
    
   public var httpMethod:kHttpMethod = kHttpMethod.post

}

public class BROSSPutObjectModel:Any{
    
   public var bucketName:String?
   public var dir:String?
   public var SecurityToken:String?
   public var Expiration:String?
   public var AccessKeySecret:String?
   public var AccessKeyId:String?
   public var endPoint:String?
   public var showPreUrl:String?
    
   public var objectKey:String?
   public var fileName:String?
   public var businessCode:String?
   public var otherInfo:Any?
   public var mData:Data?
   public var groupKey:String?
    
    
    /// 上传成功之后 的 url,过滤同次已上传的图片
   public var uploadSuccessPicUrl:String?
    
   public func br_getFullStr() -> String {
        //            businessCode + "/" + "\(dir ?? "")" + "asdhasjdkahsdjk1312.png"
        let full_url = (self.showPreUrl ?? "") + ( self.objectKey ?? "")
        return full_url
    }
    //MARK:改方法需要 调用
   public func br_configObjectKey() {
        
        objectKey = (self.businessCode ?? "") + "/" + "\(self.dir ?? "")" + (self.fileName ?? "")
    }
    
   public var mCustomDataUpdateBlock:((_ info:BROSSPutObjectModel?)->())?
   public var mUploadASuccessBlock:((_ info:BROSSPutObjectModel?)->())?
}

public extension String {
    /// 随机生成UUID
    ///
    /// - Returns: <#return value description#>
   public static func br_randomUUID() -> String{
        let uuid_ref = CFUUIDCreate(kCFAllocatorDefault)
        let uuid_string_ref = CFUUIDCreateString(kCFAllocatorDefault , uuid_ref)
        let uuid = uuid_string_ref! as String
        print(uuid + "UUID:")
        return uuid
    }
    
}

public extension NSData {
    
   public enum kBRDataType {
        case none
        case png
        case jpeg
        case gif
        case tiff
        func br_lastName() -> String {
            var name = "none"
            switch self {
            case .png:
                name = "png"
            case .gif:
                name = "gif"
            case .jpeg:
                name = "jpeg"
            case .tiff:
                name = "tiff"
            default:
                name = ""
            }
            return name
        }
    }
    
   public func br_getDataType() -> kBRDataType {
        
        var type = kBRDataType.none
        var  c:UInt32?
        self.getBytes(&c, length: 1)
        switch c {
        case 0xFF:
            print("jpeg")
            type = .jpeg
        case 0x89:
            print("png")
            type = .png
            
        case 0x47:
            print("gif")
            type = .gif
            
        case 0x49,
             0x4D:
            print("tiff")
            type = .tiff
            
        default:
            print("none")
        }
        return type
    }
    
}
