struct Comment: Codable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
}

struct CommentsResponse: Codable {
    let comments: [Comment]
}
