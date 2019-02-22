import UIKit

struct Movie: Codable, Equatable {

    let title: String
    let rating: Double
    let description: String
    let imageURLExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case description = "overview"
        case imageURLExtension = "poster_path"
    }
}

struct TopLevelDictionary: Decodable {
    let results: [Movie]
}
