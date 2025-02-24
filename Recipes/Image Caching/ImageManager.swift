//
//  ImageManager.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import SwiftUI

/// Protocol for caching the images
protocol ImageCaching {
    func getImage(for url: String) -> UIImage?
    func cacheImage(_ image: UIImage, for url: String)
    func clearCache()
}

/// Protocol that enforces image loading from a give URL String
protocol ImageLoading {
    func loadImage(from url: String) async -> UIImage?
}

class ImageManager: ImageCaching, ImageLoading {

    private let fileManager = FileManager.default
    private let cacheDirectoryURL: URL
    
    private var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
        self.cacheDirectoryURL = (fileManager.urls(for: .cachesDirectory, 
                                                   in: .userDomainMask).first?.appending(path: "Fetch_Recipe_Images"))!
        
        createCacheDirectoryIfNeeded()
        
        // Observe memory warning notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    /// Creates a cache directory if one diesn't exist
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
            } catch {
                print("Failed to create cache directory: \(error)")
            }
        }
    }
    
    /// Handles the memory warning notification and clears the cache
    @objc private func handleMemoryWarning() {
        print("Memory warning received, clearing the cache")
        clearCache()
    }
    
    /// Finds and returns the instance of image for given key
    /// - Parameter key: Cache key to find the object
    /// - Returns: UIimage from cache if found, nil otherwise
    func getImage(for url: String) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url) else { return nil }
        return image
    }
    
    /// Cache the image object for given key in the cache
    /// - Parameters:
    ///   - image: An instance of image to be store in cache
    ///   - key: key to be used for settign the given image
    func cacheImage(_ image: UIImage, for url: String) {
        let fileURL = cacheDirectoryURL.appendingPathComponent(url.hashValue.description)
        guard let imageData = image.pngData() else { return }
        
        try? imageData.write(to: fileURL)
    }
    
    /// Clears the cache  by removing all object
    func clearCache() {
        do {
            let cachedFiles = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil)
            for file in cachedFiles {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("Failed to clear cache: \(error)")
        }
    }
    
    /// Get the image from given endpoint URL String asynchronously
    /// - Parameter url: String representing the URL for the image to load
    /// - Returns: An optional UIImage
    func loadImage(from url: String) async -> UIImage? {
        
        let cachedImageFileURL = cacheDirectoryURL.appendingPathComponent(url.hashValue.description)
        
        // Check cache first, if the image for the given url is cached
        if let cachedImage = getImage(for: cachedImageFileURL.path) {
            return cachedImage
        }
        
        // If not cached, load from the network and cache for the next time
        do {
            guard let imageURL = URL(string: url) else {
                return nil
            }
            
            let (imageData, _) = try await urlSession.data(from: imageURL)
            
            guard let image = UIImage(data: imageData) else {
                return nil
            }
            
            // Cache the image
            cacheImage(image, for: url)
            return image
        } catch {
            print("Failed to get image for URL: \(url) | error: \(error.localizedDescription)")
            return nil
        }
    }
}
