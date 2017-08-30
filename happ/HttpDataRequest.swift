//
//  HttpDataRequest.swift
//  happ
//
//  Created by TokikawaTeppei on 01/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Foundation

class HttpDataRequest
 {
    var httpMethod: String = "POST"
    var language: String!
    var request: NSMutableURLRequest
    var api_url: String = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
    
    init(postData: [String: String]?) {
        self.request = NSMutableURLRequest(URL: NSURL (string: self.api_url)!)
        let setboundary = self.generateBoundaryString()
        self.request.HTTPMethod = self.httpMethod
        self.multipart(setboundary)
        self.request.HTTPBody = self.createBodyWithParameters(postData, boundary: setboundary)
    }
    
    func JsonAccept(){
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func EncodedURL(){
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    func multipart(boundary: String){
        self.request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
    }
    
    func createBodyWithParameters(parameters: [String: String]?,  boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func requestGet() -> NSMutableURLRequest{
        return self.request
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}