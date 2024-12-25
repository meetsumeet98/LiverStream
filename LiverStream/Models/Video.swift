struct Video: Decodable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
}

struct VideosResponse: Decodable {
    let videos: [Video]
}
