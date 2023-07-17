//
//  STEnlargedImageViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/18.
//

import UIKit

class STEnlargedImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = imageUrl{
            let url = URL(string: imageUrl)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
              with: url,
              placeholder: nil,
              options: [.transition(.fade(1.2))],
              completionHandler: nil
            )
        }
        
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension STEnlargedImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1.0 {
            scrollView.zoomScale = 1.0
        }
        if scrollView.zoomScale >= 6.0 {
            scrollView.zoomScale = 6.0
        }
    }
}
