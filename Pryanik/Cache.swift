//
//  Cache.swift
//  Pryanik
//
//  Created by Andy Dvoytsov on 10.02.2021.
//

import UIKit

class ImageLoadingWithCache {

    var imageCache = [String:UIImage]()

    func getImage(url: String, imageView: UIImageView, defaultImage: String) {
        if let img = imageCache[url] {
            imageView.image = img
        } else {
            let request: NSURLRequest = NSURLRequest(url: NSURL(string: url)! as URL)
            let mainQueue = OperationQueue.main

            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    self.imageCache[url] = image

                        DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
                else {
                    imageView.image = UIImage(named: defaultImage)
                }
            })
        }
    }
}
