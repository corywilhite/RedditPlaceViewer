//
//  DiffRenderer.swift
//  PlaceViewer
//
//  Created by Cory Wilhite on 4/12/17.
//  Copyright © 2017 Cory Wilhite. All rights reserved.
//

import UIKit

class DiffRenderer {
    
    static let shared = DiffRenderer()
    private init() {}
    
    let renderQueue = DispatchQueue(label: "com.corywilhite.PlaceView.renderQueue", qos: .userInitiated)
    
    func generateImage(from diffs: [Diff], completion: @escaping (UIImage) -> Void) {
        
        renderQueue.async {
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1000, height: 1000), false, UIScreen.main.scale)
            let bitmap = UIGraphicsGetCurrentContext()
            
            for diff in diffs {
                bitmap?.setFillColor(getColor(for: diff).cgColor)
                bitmap?.fill(CGRect(x: CGFloat(diff.x), y: CGFloat(diff.y), width: 1, height: 1))
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async { completion(image!) }
            
        }
        
    }
    
}
