import UIKit

class VideosManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var videos: [Video] = []
    
    let videosCollectionView: UICollectionView
    init(withCollectionView collectionView: UICollectionView) {
        videosCollectionView = collectionView
    }
//    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//    }
    
    func loadVideos() {
        guard let url = Bundle.main.url(forResource: "videos", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(VideosResponse.self, from: data)
            videos = decodedResponse.videos
            print("#SB - loadVideos: videos.count \(videos.count)")
            videosCollectionView.reloadData()
        } catch {
            print("Failed to load videos: \(error)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("#SB - numberOfItemsInSection videos.count \(videos.count)")
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("#SB - cellForItemAt indexPath \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: videos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("#SB - sizeForItemAt indexPath \(indexPath)")
        return collectionView.bounds.size
    }
}
