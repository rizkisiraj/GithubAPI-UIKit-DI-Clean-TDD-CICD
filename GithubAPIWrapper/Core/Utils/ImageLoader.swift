//
//  ImageLoader.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 19/05/26.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private init() {}

    // MARK: - Cache

    private let cache = NSCache<NSString, UIImage>()

    // MARK: - Load Image

    @discardableResult
    func loadImage(
        from urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask? {

        // 1. Return cached image immediately
        if let cachedImage = cache.object(
            forKey: urlString as NSString
        ) {

            print("⚡️ Cache hit:", urlString)

            DispatchQueue.main.async {
                completion(cachedImage)
            }

            return nil
        }

        // 2. Validate URL
        guard let url = URL(string: urlString) else {

            DispatchQueue.main.async {
                completion(nil)
            }

            return nil
        }


        // 3. Download image
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, _, error in

            // Ignore cancelled requests
            if let error = error as? URLError,
               error.code == .cancelled {

                return
            }

            guard let data,
                  let image = UIImage(data: data) else {

                DispatchQueue.main.async {
                    completion(nil)
                }

                return
            }

            // 4. Save to cache
            self?.cache.setObject(
                image,
                forKey: urlString as NSString
            )


            // 5. Return image
            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()

        return task
    }

    // MARK: - Optional Utilities

    func clearCache() {
        cache.removeAllObjects()
    }
}
