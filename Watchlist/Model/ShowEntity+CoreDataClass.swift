//
//  ShowEntity+CoreDataClass.swift
//  Watchlist
//
//  Created by Noah Korner on 4/8/20.
//  Copyright © 2020 asu. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(ShowEntity)
public class ShowEntity: NSManagedObject {
    func convertToShow() -> Show{
        let convertedShow = Show.init(n: self.name!, pl: Int(self.priorityLevel), ra: Int(self.rating), re: self.review!, t: Int(self.type), seen: hasSeen, img: UIImage(data: self.image!, scale: 1.0)!, subs: convertStringToArray(subs: self.subscriptions!))
        
        return convertedShow
    }
    
    func convertStringToArray(subs:String) -> [String]{
        var subscriptions = [String]()
        var newString:String = ""
        
        for char in subs{
            if char != "+"{
                newString += String(char)
            }
            else{
                subscriptions.append(newString)
                newString = ""
            }
        }
        
        return subscriptions
    }
}
