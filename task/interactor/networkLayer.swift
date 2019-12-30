//
//  networkLayer.swift
//  task
//
//  Created by Mina Gamil  on 12/24/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Api {
    
    public static var ownerArray = [Owner]()
      
    class func parsers(page:Int,completionHandler:@escaping(_ error:Error?,_ task:[WelcomeElement]?,_ lastPage:Int)-> Void){
         let url:String = "https://api.github.com/users/square/repos"
        let parameters = ["?page":page,"per_page":10]
          Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
              switch response.result{
              case .failure(let error):
                  print(error)
                  completionHandler(nil,nil, page)
              case .success(let value):
                  print(value)
              let json = JSON(value)
                  guard let dataArray = json.array else {
                      print("yaaaaaaaaaaaaaaaaaaaaraaaaaaab")
                      completionHandler(nil,nil,page)
                      return
                  }
                 
                  var task = [WelcomeElement]()
                  for data in dataArray{
                      var instnace = WelcomeElement()
                      var owner = Owner()
                      instnace.name = data["name"].string ?? ""
                      instnace.fullName = data["full_name"].string ?? ""
                      owner.avatarURL = data["owner"]["avatar_url"].string ?? ""
                      instnace.welcomeDescription = data["description"].string ?? ""
                      Api.ownerArray.append(owner)
                      task.append(instnace)
                  }
                  print("\(task)")
                  print("samo 3alikooooooooooooooo")
                  print(Api.ownerArray)
                  completionHandler(nil,task,page)
              }
          }
      }
  }

