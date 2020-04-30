//
//  Shows.swift
//  Watchlist
//
//  Created by Noah Korner on 4/7/20.
//  Copyright © 2020 asu. All rights reserved.
//
import UIKit
import CoreData

class Shows
{
    var shows:[Show] = []
    
    init(){
    }
    
    func getCount() -> Int{
        return shows.count
    }
    
    func addShowObject(name:String, priorityLevel:Int, rating:Int, review:String, type:Int, hasSeen:Bool, image:UIImage, subscriptions:[String]){
        let newShow = Show(n:name,pl:priorityLevel,ra:rating,re:review,t:type,seen:hasSeen,img:image, subs: subscriptions)
        shows.append(newShow)
    }
    
    func addShowObject(newShow:Show) {
        shows.append(newShow)
    }
    
    func getShowObject(item:Int) -> Show{
        return shows[item]
    }
    
    func getShowObject(search:String) -> Show{
        let tempShow = Show(n:"temp",pl:0,ra:0,re:"temp",t:0,seen:false,img:UIImage(named:"default.jpg")!, subs: ["temp"])
        for show in shows {
            if show.name == search{
                return show
            }
        }
        return tempShow
    }
}

class Show{
       var name: String
       var priorityLevel: Int
       var rating: Int
       var review: String
       var type: Int
       var hasSeen: Bool
       var image: UIImage
       var subscriptions: [String]
       
    init(n:String,pl:Int,ra:Int,re:String,t:Int,seen:Bool,img:UIImage,subs:[String]){
        name = n
        priorityLevel = pl
        rating = ra
        review = re
        type = t
        hasSeen = seen
        image = img
        subscriptions = subs
    }
}


