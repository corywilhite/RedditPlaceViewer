//
//  PlaceViewerViewController.swift
//  PlaceViewer
//
//  Created by Cory Wilhite on 4/11/17.
//  Copyright © 2017 Cory Wilhite. All rights reserved.
//

import UIKit

class PlaceViewerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var renderSlider: UISlider! {
        didSet {
            renderSlider.addTarget(
                self,
                action: #selector(renderSliderValueChanged(sender:)),
                for: .valueChanged
            )
            renderSlider.addTarget(
                self,
                action: #selector(renderSliderDidEndValueChange(sender:)),
                for: .touchUpInside
            )
        }
    }
    
    var canvas: UIImageView!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diffs = DiffManager.shared.diffs
        
        renderSlider.minimumValue = Float(diffs.first!.timestamp)
        renderSlider.maximumValue = Float(diffs.last!.timestamp)
        print(diffs.first!.timestamp)
        print(diffs.last!.timestamp)
        
        let filtered = diffs.filter { $0.timestamp == diffs.first!.timestamp }
        
        let image = DiffRenderer.shared.generateImage(from: filtered)
        
        canvas = UIImageView(image: image)
        scrollView.addSubview(canvas)
        scrollView.contentSize = image.size
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 6.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvas.frame.origin = .zero
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }

    var timestampToFilter: UInt32 = 0
    
    func renderSliderValueChanged(sender: UISlider) {
        timestampToFilter = UInt32(sender.value)
        print("changed timestamp to: \(timestampToFilter)")
    }
    
    func renderSliderDidEndValueChange(sender: UISlider) {
        print("filtering")
        let filtered = DiffManager.shared.diffs.filter { $0.timestamp <= timestampToFilter }
        canvas.image = DiffRenderer.shared.generateImage(from: filtered)
    }
}

