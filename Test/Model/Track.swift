//
//  Track.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import Foundation

protocol Track {
    var title: String { get set }
    var subtitle: String { get set }
    var thumbURL: String { get set }
}

struct ITunesResponse: Decodable {
    var resultCount: Int
    var results: [ITunesTrack]
}

struct ITunesTrack: Track, Decodable {
    var title: String
    var subtitle: String
    var thumbURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case subtitle = "artistName"
        case thumbURL = "artworkUrl100"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        thumbURL = try values.decode(String.self, forKey: .thumbURL)
    }
}

struct LastFMResponse: Decodable {
    
    struct LastFMResults: Decodable {
        
        struct LastFMTrackmatches: Decodable {
            var track: [LastFMTrack]
        }
        
        var trackmatches: LastFMTrackmatches
        
    }
    
    var results: LastFMResults
    
}

struct LastFMTrack: Track, Decodable {

    fileprivate struct LastFMImage: Decodable {
        var image: String
        var size: String
        
        enum CodingKeys: String, CodingKey {
            case image = "#text"
            case size
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            image = try values.decode(String.self, forKey: .image)
            size = try values.decode(String.self, forKey: .size)
        }
    }
    
    var title: String
    var subtitle: String
    var thumbURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case subtitle = "artist"
        case image
    }
    
    enum ImageKeys: String, CodingKey {
        case text = "#text"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        
        let images = try values.decode([LastFMImage].self, forKey: .image)
        thumbURL = images.first?.image ?? ""
    }
}
