import UIKit

class VideosManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    private var videos: [Video] = []
    let videosCollectionView: UICollectionView

    // MARK: - LifeCycle Methods

    init(withCollectionView collectionView: UICollectionView) {
        videosCollectionView = collectionView
    }

    // MARK: - Internal Methods

    func loadVideos() {
        loadVideos(fromFile: "videos") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videos):
                    print("#SB - loadVideos: videos.count \(videos.count)")
                    self?.videos = videos
                    self?.videosCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to load videos: \(error)")
                }
            }
        }
    }

    // MARK: - Private Helpers

    private func loadVideos(fromFile fileName: String, completion: @escaping (Result<[Video], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: nil)))
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let decodedResponse = try JSONDecoder().decode(VideosResponse.self, from: data)
                completion(.success(decodedResponse.videos))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - UICollectionViewDataSource

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

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Cell at index \(indexPath) went off-screen")

        if let videoCell = cell as? VideoCell {
            videoCell.pauseVideo()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Cell at index \(indexPath) will be on-screen")

        if let videoCell = cell as? VideoCell {
            videoCell.playVideo()
        }
    }
}
