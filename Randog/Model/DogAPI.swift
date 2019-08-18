//
//  DogAPI.swift
//  Randog
//
//  Created by Christopher Ponce Mendez on 8/15/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import UIKit
class DogAPI {
    enum Endpoint{
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL{
            return URL(string: self.stringValue)!
        }
        var stringValue: String{
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
                
            }

        }
        
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })

        task.resume()
    }
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomEndpoint ) { (data, response, error) in
            
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData,nil)
                print(imageData)
            }catch{
                print(error)
            }

        }
        task.resume()
    }
    class func requestAllBreedRequest(completionHandler: @escaping ([String], Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else{
                print("the data is missing")
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let breedsListResponse = try decoder.decode(BreedsListResponse.self, from: data)
                let breeds = breedsListResponse.message.keys.map({$0})
                completionHandler(breeds, nil)
            }catch{
                print(error)
            }

        }
        task.resume()
    }
}
