//
//  UIImageView+OnlineImage.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import Foundation
import UIKit
/// Image view extenstion for downloading image from the server
extension UIImageView {
    public func getImageFromServer(url: URL, completion: @escaping (Bool) -> Void) {
        self.image = nil
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(false)
                return
            }
            DispatchQueue.main.async {
                if let data = data {
                    let image = UIImage(data: data)
                    self.image = image
                }
                completion(true)
            }
            
        }).resume()
    }
}

