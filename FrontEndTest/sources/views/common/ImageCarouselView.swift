//
//  SlideShow.swift
//  FrontEndTest
//
//  Created by fajaradiwasentosa on 15/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

protocol ImageCarouselViewDelegate: NSObjectProtocol {
    func imageCarouselView(_ imageCarouselView: ImageCarouselView, didShowImageAt index: Int)
}

import UIKit

class ImageCarouselView: UIView {
    private let images: [UIImage?]
    private var index = 0
    private let screenWidth = UIScreen.main.bounds.width

    var delegate: ImageCarouselViewDelegate?

    lazy var previousImageView = imageView(image: nil, contentMode: .scaleAspectFit)
    lazy var currentImageView = imageView(image: nil, contentMode: .scaleAspectFit)
    lazy var nextImageView = imageView(image: nil, contentMode: .scaleAspectFit)

    lazy var previousImageLeadingConstraint: NSLayoutConstraint = {
        return previousImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -screenWidth)
    }()

    lazy var currentImageLeadingConstraint: NSLayoutConstraint = {
        return currentImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    }()

    lazy var nextImageLeadingConstraint: NSLayoutConstraint = {
        return nextImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenWidth)
    }()

    init(_ images: [UIImage?]) {
        self.images = images
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
        setupImages()
        setupSwipeRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.subviews.forEach({ $0.removeFromSuperview() })

        addSubview(previousImageView)
        addSubview(currentImageView)
        addSubview(nextImageView)

        previousImageLeadingConstraint = previousImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -screenWidth)
        currentImageLeadingConstraint = currentImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        nextImageLeadingConstraint = nextImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenWidth)

        NSLayoutConstraint.activate([
            previousImageLeadingConstraint,
            previousImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            previousImageView.widthAnchor.constraint(equalToConstant: screenWidth),

            currentImageLeadingConstraint,
            currentImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            currentImageView.widthAnchor.constraint(equalToConstant: screenWidth),

            nextImageLeadingConstraint,
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextImageView.widthAnchor.constraint(equalToConstant: screenWidth),
        ])
    }

    private func setupImages() {
        currentImageView.image = images[self.index]

        guard images.count > 1 else { return }

        if (index == 0) {
            previousImageView.image = images[images.count - 1]
            nextImageView.image = images[index + 1]
        }

        if (index == (images.count - 1)) {
            previousImageView.image = images[index - 1]
            nextImageView.image = images[0]
        }
    }

    private func setupSwipeRecognizer() {
        guard images.count > 1 else { return }

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))

        leftSwipe.direction = .left
        rightSwipe.direction = .right

        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
    }

    @objc private func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            showNextImage()
        }

        if (sender.direction == .right) {
            showPreviousImage()
        }
    }

    private func showPreviousImage() {
        previousImageLeadingConstraint.constant = 0
        currentImageLeadingConstraint.constant = screenWidth

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.nextImageView = self.currentImageView
            self.currentImageView = self.previousImageView
            self.previousImageView = self.imageView(image: nil, contentMode: .scaleAspectFit)

            self.index = self.index == 0 ? self.images.count - 1 : self.index - 1
            self.delegate?.imageCarouselView(self, didShowImageAt: self.index)
            self.previousImageView.image = self.index == 0 ? self.images[self.images.count - 1] : self.images[self.index - 1]

            self.setupLayout()
        })
    }

    private func showNextImage() {
        nextImageLeadingConstraint.constant = 0
        currentImageLeadingConstraint.constant = -screenWidth

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.previousImageView = self.currentImageView
            self.currentImageView = self.nextImageView
            self.nextImageView = self.imageView(image: nil, contentMode: .scaleAspectFit)

            self.index = self.index == (self.images.count - 1) ? 0 : self.index + 1
            self.delegate?.imageCarouselView(self, didShowImageAt: self.index)
            self.nextImageView.image = self.index == (self.images.count - 1) ? self.images[0] : self.images[self.index + 1]

            self.setupLayout()
        })
    }

    func imageView(image: UIImage? = nil, contentMode: UIImageView.ContentMode) -> UIImageView {
        let view = UIImageView()

        view.image = image
        view.contentMode = contentMode
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
}


//let slideshowView = ImageCarouselView(images) // initialize
//self.slideshowView.delegate = self // set delegate in viewDidLoad()
//extension YourViewController: ImageCarouselViewDelegate {
//    func imageCarouselView(_ imageCarouselView: ImageCarouselView, didShowImageAt index: Int) {
//        // do something with index
//    }
//}
