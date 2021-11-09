//
//  CacheManager.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import Foundation
import UIKit

struct CacheManager {
    static var shared = CacheManager()
    let cache = NSCache<NSString, UIImage>()
    let utilityQueue = DispatchQueue.global(qos: .utility)
    var retryInfo = [NSString: Int]()
    
    private init() {
        debugPrint("private Init for singleton class")
    }
    
    func attempts(for itemNumber: NSString) -> Int {
        return self.retryInfo[itemNumber] ?? 0
    }
}

extension UIImageView {
    
    private enum Constants {
        static let retryAttempts: Int = 3
    }
    
    // MARK: - Set Image in Cache
    func setImage(url: URL, itemNumber: NSString, isAnimated: Bool = false) {
        if let cachedImage = CacheManager.shared.cache.object(forKey: itemNumber) {
            debugPrint("Using a cached image for item: \(itemNumber)")
            DispatchQueue.main.async {
                self.image = cachedImage
                if isAnimated {
                    self.bounce(after: .now() + 1.0)
                }
            }
        } else {
            let totalAttempt: Int = CacheManager.shared.attempts(for: itemNumber)
            CacheManager.shared.retryInfo[itemNumber] = (totalAttempt + 1)
            self.loadImage(url: url, itemNumber: itemNumber) {[weak self] (image) in
                guard let weakSelf = self, let image = image else { return }
                DispatchQueue.main.async {
                    weakSelf.image = image
                }
                CacheManager.shared.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
    
    // MARK: - Image Loading
    func loadImage(url: URL, itemNumber: NSString, completion: @escaping (UIImage?) -> ()) {
        CacheManager.shared.utilityQueue.async { [weak self] in
            guard let weakSelf = self else { return }
            
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            catch {
                // Retry Image downloading logic here
                let attempts: Int = CacheManager.shared.attempts(for: itemNumber)
                debugPrint("retries left \(Constants.retryAttempts - attempts) and error = \(error)")
                if attempts < Constants.retryAttempts {
                    weakSelf.setImage(url: url, itemNumber: itemNumber)
                }
                return
            }
        }
    }
}
