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
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 6.0
        
        canvas = UIImageView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        scrollView.addSubview(canvas)
        
        DiffManager.shared.filteredToFirstFrame { (firstDiffs) in
            
            DiffRenderer.shared.generateImage(from: firstDiffs) { [unowned self] image in
                
                self.image = image
                self.view.layoutIfNeeded()
                
            }
            
        }
        
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
    
    var image: UIImage? {
        get {
            return canvas.image
        }
        
        set {
            canvas.image = newValue
            scrollView.contentSize = newValue?.size ?? .zero
        }
    }
    
    var isRendering: Bool = false
    
    func renderSliderDidEndValueChange(sender: UISlider) {
        print("filtering")
        guard isRendering == false else { return }
        
        isRendering = true
        
        DiffManager.shared.filtered(to: timestampToFilter) { (filtered) in
            
            DiffRenderer.shared.generateImage(from: filtered) { [unowned self] image in
                self.image = image
                self.isRendering = false
            }
            
        }
        
    }
}

