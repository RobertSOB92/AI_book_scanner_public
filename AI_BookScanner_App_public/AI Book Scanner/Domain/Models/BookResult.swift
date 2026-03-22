import Foundation

struct BookResult: Codable, Equatable, Sendable {
    let title: String
    let author: String
    let description: String
    let sourceUrl: String
}
