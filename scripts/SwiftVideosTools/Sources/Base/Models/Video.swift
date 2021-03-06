//
//  Copyright © 2019 An Tran. All rights reserved.
//

import Foundation

typealias VideoID = String

// MARK: - VideoMetaData

typealias VideosList = [VideoMetaData]

struct VideoMetaData: Codable {
    let id: VideoID
    let authors: AuthorsList
    let conference: VideoConferenceInfo
    let name: String
    let source: VideoSource
    let createdAt: TimeInterval?
}

// MARK: - VideoConferenceInfo

struct VideoConferenceInfo: Codable {
    let metaData: ConferenceMetaData
    let edition: ConferenceEdition
}

// MARK: - VideoDetail

struct VideoDetail: Codable {
    let metaData: VideoMetaData
    let description: String?
    let resources: [VideoResource]?
}

// MARK: - VideoSource

public struct VimeoResourceData: Codable {
    public let showcase: String?
    public let video: String
}

enum VideoSource {
    case vimeo(resource: VimeoResourceData)
    case youtube(id: String)
    case wwdc(url: String)
    case streaming(url: String)
    case website(url: String)

    init(type: String, resourceID: String) {
        switch type {
            case "vimeo":
                self = .vimeo(resource: VimeoResourceData(showcase: nil, video: resourceID))
            case "youtube":
                self = .youtube(id: resourceID)
            default:
                exit(1)
        }
    }
}

extension VideoSource: Codable {

    enum Key: CodingKey {
        case type
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .type)

        switch rawValue {
        case "vimeo":
            let resource = try container.decode(VimeoResourceData.self, forKey: .value)
            self = .vimeo(resource: resource)

        case "youtube":
            let id = try container.decode(String.self, forKey: .value)
            self = .youtube(id: id)

        case "wwdc":
            let url = try container.decode(String.self, forKey: .value)
            self = .wwdc(url: url)

        case "streaming":
            let url = try container.decode(String.self, forKey: .value)
            self = .streaming(url: url)

        case "website":
            let url = try container.decode(String.self, forKey: .value)
            self = .website(url: url)

        default:
            throw ModelCodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        switch self {
        case .vimeo(let resource):
            try container.encode("vimeo", forKey: .type)
            try container.encode(resource, forKey: .value)

        case .youtube(let id):
            try container.encode("youtube", forKey: .type)
            try container.encode(id, forKey: .value)

        case .wwdc(let url):
            try container.encode("wwdc", forKey: .type)
            try container.encode(url, forKey: .value)

        case .streaming(let url):
            try container.encode("streaming", forKey: .type)
            try container.encode(url, forKey: .value)

        case .website(let url):
            try container.encode("website", forKey: .type)
            try container.encode(url, forKey: .value)

        }
    }
}

// MARK: - VideoResource

enum VideoResource {
    case pdf(url: String)
    case website(url: String)
}

extension VideoResource: Codable {

    enum Key: CodingKey {
        case type
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .type)

        switch rawValue {
        case "pdf":
            let url = try container.decode(String.self, forKey: .value)
            self = .pdf(url: url)

        case "website":
            let url = try container.decode(String.self, forKey: .value)
            self = .website(url: url)

        default:
            throw ModelCodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        switch self {
        case .pdf(let url):
            try container.encode("pdf", forKey: .type)
            try container.encode(url, forKey: .value)

        case .website(let url):
            try container.encode("website", forKey: .type)
            try container.encode(url, forKey: .value)

        }
    }
}
