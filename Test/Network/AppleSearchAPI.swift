//
//  AppleSearchAPI.swift
//  Test
//
//  Created by Galym Anuarbek on 10/17/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import Foundation

struct AppleSearchAPI {
    
    static var baseURL = "https://itunes.apple.com/search"
    
    static func search(text: String, responseHandler: @escaping ([Track]) -> Void, errorHandler: @escaping (Error?) -> Void) {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { errorHandler(nil); return }
        let urlString = "\(baseURL)?term=\(encodedText)&media=music"
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
                let parsedResponse = try JSONDecoder().decode(ITunesResponse.self, from: dataResult)
                responseHandler(parsedResponse.results as [Track])
            } catch let error {
                errorHandler(error)
            }
        }).resume()
    }
    
}
