import UIKit

enum ProcessStatus: Equatable, Sendable {
    case idle
    case processing
    case success
    case failure(String)
}

struct BookProcessItem: Identifiable, Equatable, Sendable {
    let id: UUID
    let originalImage: UIImage
    var status: ProcessStatus
    var result: BookResult?
    
    static func == (lhs: BookProcessItem, rhs: BookProcessItem) -> Bool {
        lhs.id == rhs.id && lhs.status == rhs.status && lhs.result == rhs.result
    }
}
