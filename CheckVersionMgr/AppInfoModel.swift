//
//  AppInfoModel.swift
//  checkupdate
//
//  Created by XingfuQiu on 2018/5/29.
//  Copyright © 2018年 XingfuQiu. All rights reserved.
//

import Foundation

public struct AppInfoModel : Codable {
    
    let resultCount : Int?
    let results : [Result]?
}

public struct Result : Codable {
    let advisories : [String]?
    let appletvScreenshotUrls : [String]?
    let artistId : Int?
    let artistName : String?
    let artistViewUrl : String?
    let artworkUrl100 : String?
    let artworkUrl512 : String?
    let artworkUrl60 : String?
    let averageUserRating : Float?
    let bundleId : String?
    let contentAdvisoryRating : String?
    let currency : String?
    let currentVersionReleaseDate : String?
    let descriptionField : String?
    let features : [String]?
    let fileSizeBytes : String?
    let formattedPrice : String?
    let genreIds : [String]?
    let genres : [String]?
    let ipadScreenshotUrls : [String]?
    let isGameCenterEnabled : Bool?
    let isVppDeviceBasedLicensingEnabled : Bool?
    let kind : String?
    let languageCodesISO2A : [String]?
    let minimumOsVersion : String?
    let price : Float?
    let primaryGenreId : Int?
    let primaryGenreName : String?
    let releaseDate : String?
    let releaseNotes : String?
    let screenshotUrls : [String]?
    let sellerName : String?
    let supportedDevices : [String]?
    let trackCensoredName : String?
    let trackContentRating : String?
    let trackId : Int?
    let trackName : String?
    let trackViewUrl : String?
    let userRatingCount : Int?
    let version : String?
    let wrapperType : String?
}
