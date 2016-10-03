//
//  fileTransferHandler.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/1/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import Foundation
import AWSS3
import AWSMobileHubHelper

class fileTransferHandler{
    let S3BucketName = "solarrecipes-userfiles-mobilehub-623139932"
    
    init(){
        
    }
    fileprivate func uploadWithData(_ data: Data, forKey key: String) {
        
        let manager = AWSUserFileManager() //.default()
        let localContent = manager.localContent(with: data, key: key)
        print("about to upload picture rn ")
        localContent.uploadWithPin(
            onCompletion: false,
            progressBlock: {[weak self](content: AWSLocalContent?, progress: Progress?) -> Void in
                guard let strongSelf = self else { return }
                /* Show progress in UI. */
                DispatchQueue.main.async(execute: { () -> Void in
                    print("not sure when this happens")
                    print(progress?.fractionCompleted)
                })
            },
            completionHandler: {[weak self](content: AWSContent?, error: Error?) -> Void in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("Failed to upload an object. \(error)")
                } else {
                    print("Object upload complete. \(error)")
                }
            })
    }
    func upload(_ picName: String, picture: UIImage) {
        let imageData: Data = UIImagePNGRepresentation(picture)!
        
        //uploadWithData(imageData, forKey: picName)
        S3Upload(picName, picture: picture)
    } //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    func S3Upload(_ picName: String, picture: UIImage){
        
        print("in s3 upload about to upload a picture")
        let fileName = picName
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let filePath = fileURL?.path
        var imageData = UIImageJPEGRepresentation(picture, 0.01)
    
        do {
            try imageData?.write(to: fileURL!, options: .atomic)
        } catch {
            print(error)
        }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = fileURL
        uploadRequest?.key = fileName
        uploadRequest?.bucket = S3BucketName
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .usEast1,
            identityPoolId: "us-east-1:0f8aff81-0c9c-41f4-bd2a-e9083e706388")
        let configuration = AWSServiceConfiguration(
            region: .usEast1,
            credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
 
        let transferManager = AWSS3TransferManager.default()
        
        transferManager?.upload(uploadRequest).continue ({ (task) -> AnyObject! in
            if let error = task.error {
                /*
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .Cancelled, .Paused:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                print("not sure when this happens")
                            })
                            break;
                            
                        default:
                            print("upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print("upload() failed: [\(error)]")
                    }
                } else {
                    print("upload() failed: [\(error)]")
                }*/
                print("upload() failed: [\(error)]")
            }
            
            if let exception = task.exception {
                print("upload() failed: [\(exception)]")
            }
            
            if task.result != nil {
                    print("upload complete")
            }
            return nil
        })
        showUploadState(uploadRequest!)
    }
    
    //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    func showUploadState(_ uploadRequest: AWSS3TransferManagerUploadRequest){
        switch uploadRequest.state {
        case .running:
            uploadRequest.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if totalBytesExpectedToSend > 0 {
                        print("----------------------------------running")
                        print("\( Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend))*100)%")
                    }
                })
            }
            
            break
            
        default:
            //picture downloaded do stuff
            
            print("-------------------------------not running")
            
        }
    }//----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//

}
let glblFileTransferHandler = fileTransferHandler()
