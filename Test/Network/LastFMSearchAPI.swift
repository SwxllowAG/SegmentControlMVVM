//
//  LastFMSearchAPI.swift
//  Test
//
//  Created by Galym Anuarbek on 10/17/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import Foundation

struct LastFMSearchAPI {
    
    static var apiKey = "eb20279fad763c0e7c56b58ee8cceb9c"
    static var baseURL = "http://ws.audioscrobbler.com/2.0/"
    
    static func search(text: String, responseHandler: @escaping ([Track]) -> Void, errorHandler: @escaping (Error?) -> Void) {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { errorHandler(nil); return }
        let urlString = "\(baseURL)?method=track.search&track=\(encodedText)&api_key=\(apiKey)&format=json&limit=50"
        guard let url = URL(string: urlString) else { errorHandler(nil); return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let dataResult = data else { errorHandler(error); return }
            
            if error != nil {
                errorHandler(error)
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                errorHandler(nil)
                return
            }

            do {
                let parsedResponse = try JSONDecoder().decode(LastFMResponse.self, from: dataResult)
                responseHandler(parsedResponse.results.trackmatches.track as [Track])
            } catch let error {
                errorHandler(error)
            }
        }).resume()
    }
    
}
