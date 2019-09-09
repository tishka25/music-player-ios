//
//  Music.swift
//  Music Player-iOS
//
//  Created by Teodor Stanishev on 23.07.19.
//  Copyright © 2019 Teodor Stanishev. All rights reserved.
//

import UIKit

class Music: NSObject {
    let name:String!
    let duration:TimeInterval!
    let songURL:URL!
    let coverArtURL:URL!
    init(name:String , songURL:URL , coverArtURL:URL, duration:TimeInterval) {
        self.name = name
        self.songURL = songURL
        self.coverArtURL = coverArtURL
        self.duration = duration
        
    }
}
