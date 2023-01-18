//
//  YoutubeSearchResponse.swift
//  VuduTV
//
//  Created by Mcbook Pro on 11.09.22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
