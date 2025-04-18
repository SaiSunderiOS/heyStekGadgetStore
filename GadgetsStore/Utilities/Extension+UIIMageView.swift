//
//  Extension+UIIMageView.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
