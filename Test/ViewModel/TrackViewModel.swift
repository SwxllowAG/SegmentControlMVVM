//
//  TrackViewModel.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import Foundation

protocol TrackViewModelProtocol {
    
    var itunesTrackDidChange: (([Track]) -> Void)? { get set }
    var lastFMTrackDidChange: (([Track]) -> Void)? { get set }
    var itunesSearchError: ((Error?) -> Void)? { get set }
    var lastFMSearchError: ((Error?) -> Void)? { get set }
    
    func searchTracks(text: String)
}

class TrackViewModel: TrackViewModelProtocol {
    
    var itunesTrackDidChange: (([Track]) -> Void)?
    var lastFMTrackDidChange: (([Track]) -> Void)?
    var itunesSearchError: ((Error?) -> Void)?
    var lastFMSearchError: ((Error?) -> Void)?
    
    var itunesTracks: [Track] = [] {
        didSet {
            self.itunesTrackDidChange!(itunesTracks)
        }
    }
    
    var lastfmTracks: [Track] = [] {
        didSet {
            self.lastFMTrackDidChange!(lastfmTracks)
        }
    }
    
    func searchTracks(text: String) {
        AppleSearchAPI.search(text: text, responseHandler: { (tracks) in
            self.itunesTracks = tracks
        }, errorHandler: { (error) in
            self.itunesSearchError?(error)
        })
        
        LastFMSearchAPI.search(text: text, responseHandler: { (tracks) in
            self.lastfmTracks = tracks
        }, errorHandler: { (error) in
            self.lastFMSearchError?(error)
        })
    }
    
}
