//
//  AlbumApiService.swift
//  Pokemon
//
//  Created by Evgeny on 8/31/16.
//  Copyright © 2016 Evgeny. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class AlbumApiService {
    
    func getAllAlbums () -> Observable<[Album]> {
        
        let pathAlbums = NSBundle.mainBundle().pathForResource("albums", ofType: "json")
        let dataAlbums = NSData(contentsOfFile: pathAlbums!)
        let jsonAlbums = try! NSJSONSerialization.JSONObjectWithData(dataAlbums!, options: [])
        
        var albumList : [Album] = []
        
        for anItem in jsonAlbums as! [Dictionary <String, AnyObject>] {
            
            let album = Album()
            let albumId = anItem ["id"] as! Int
            let title = anItem ["title"] as! String
            let userId = anItem ["userId"] as! Int
            
            album.albumId = albumId
            album.title = title
            album.userId = userId
            albumList.append(album)
        }
        return Observable.just(albumList)
    }
    
    
    func getUserName () -> Observable<[User]> {
        
        let pathUsers = NSBundle.mainBundle().pathForResource("users", ofType: "json")
        let dataUsers = NSData(contentsOfFile: pathUsers!)
        let jsonUsers = try! NSJSONSerialization.JSONObjectWithData(dataUsers!, options: [])
        
        var userList : [User] = []
        
        for anItem in jsonUsers as! [Dictionary <String, AnyObject>] {
            
            let user = User()
            let userId = anItem["id"] as? Int
            let userName = anItem["username"] as? String
            
            user.userId = userId
            user.name = userName
            userList.append(user)
        }
        return Observable.just(userList)       
    }
    
    
    func getAlbumDetails (albumId : Int) -> Observable<[Photo]> {
        
        let pathPhotos = NSBundle.mainBundle().pathForResource("photos", ofType: "json")
        let dataPhotos = NSData(contentsOfFile: pathPhotos!)
        let jsonPhotos = try! NSJSONSerialization.JSONObjectWithData(dataPhotos!, options: [])
        
        var albumDetails : [Photo] = []
        
        for anItem in jsonPhotos as! [Dictionary <String, AnyObject>] {
            
            let photo = Photo()
            let photoAlbumId = anItem ["albumId"] as? Int
            let photoUrl = anItem["url"] as? String
            let photoTitle = anItem ["title"] as? String
            
            if photoAlbumId == albumId {
                photo.url = photoUrl
                photo.title = photoTitle
                albumDetails.append(photo)}
            else { }
        }
        return Observable.just(albumDetails)
    }

    
    func getLikedAlbums (likedAlbumList : Set <Int>) -> Observable<[Album]> {
       
        return self.getAllAlbums()
            .map{ (allAlbums : [Album]) -> [Album] in
                return allAlbums.filter { (album) -> Bool in
                    return likedAlbumList.contains(album.albumId!)
                }
        }
    }
 
    func getUserNameByAlbum (album : Album) -> Observable<User> {
        
        return getUserName().map{ (users : [User]) -> User in
            return (users.filter{ (user : User) -> Bool in
                return user.userId! == album.userId!
                }
                ).first!
        }
    }
    
}







