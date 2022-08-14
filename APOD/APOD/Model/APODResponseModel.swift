//
//  APODResponseModel.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import Foundation
/// Response model structure of APOD API
struct APODResponseModel: Decodable {
    let date: String?
    let explanation: String?
    let media_type: String?
    let title: String?
    let url: String?
    let hdurl: String?
    let thumbnail_url: String?
}
