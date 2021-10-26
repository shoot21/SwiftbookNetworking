//
//  imageProperties.swift
//  Networking
//
//  Created by Никита Иващенков on 26/10/2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}

