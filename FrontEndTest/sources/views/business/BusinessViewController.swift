//
//  BusinessViewController.swift
//  FrontEndTest
//
//  Created by fajaradiwasentosa on 15/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit
import ImageSlideshow
import MapKit

class BusinessViewController: UIViewController {
    @IBOutlet weak var imageCarouselView: ImageSlideshow?
    @IBOutlet var starRatingImageView: [UIImageView]!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var bussinessTableView: UITableView!
    @IBOutlet weak var bussinessLabel: UILabel!
    
    @IBOutlet weak var businessSubtitleLabel: UILabel!
    var viewModel = BusinessViewModel()
    
    init(_ viewModel: BusinessViewModel) {
        super.init(nibName: String(describing: BusinessViewController.self), bundle: nil)
        self.viewModel = viewModel
        viewModel.interactor = self
        self.getBusiness()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureView() {
        guard let object = viewModel.businessResponse else { return }
        setupRatingView(object.rating)
        setupCarousel(object)
        DispatchQueue.main.async {
            self.bussinessTableView.delegate = self
            self.bussinessTableView.dataSource = self
            self.bussinessTableView.estimatedRowHeight = 85
            self.bussinessTableView.registerReusableCell(ReviewTableViewCell.self)
            self.bussinessLabel.text = object.name?.capitalized
            self.businessSubtitleLabel.text = [["Price :", object.price ?? ""].joined(), ["\(object.reviewCount ?? 0)", "reviews"].joined(separator: " ")].joined(separator: " | ")
        }
        
        showMapButton.addTarget(self, action: #selector(askToOpenMap), for: .touchUpInside)
    }
    
    private func setupCarousel(_ object: SearchBusinessesResponse.Business) {
        imageCarouselView?.contentScaleMode = .scaleAspectFill
        
        DispatchQueue.main.async {
            var images = [ImageSource]()
            object.photos?.forEach({ (urlString) in
                let imageView = UIImageView()
                imageView.loadImageUsingCacheWithUrlString(urlString: urlString)
                images.append(ImageSource(image: imageView.image ?? UIImage()))
            })
            
            self.imageCarouselView?.setImageInputs(images)
        }
    }
    
    private func setupRatingView(_ rating: Double?) {
        DispatchQueue.main.async {
            for ratingView in self.starRatingImageView {
                if Double(ratingView.tag) <= rating?.rounded(.towardZero) ?? 0 {
                    ratingView.image = UIImage(systemName: "star.fill")
                } else {
                    if rating ?? 0 == Double(ratingView.tag) - 0.5 {
                        ratingView.image = UIImage(systemName: "star.leadinghalf.filled")
                    } else {
                        ratingView.image = UIImage(systemName: "star")
                    }
                }
            }
        }
        
    }
}

extension BusinessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.reviewResponse?.reviews.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
         
        guard let reviewResponse = self.viewModel.reviewResponse else { return UITableViewCell() }
        cell.configureCell(reviewResponse.reviews[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
    
}

extension BusinessViewController {
    @objc func askToOpenMap() {
        guard let object = viewModel.businessResponse else { return }
        OpenMapDirections.present(in: self, sourceView: showMapButton, object: object)
    }
}

extension BusinessViewController {
    private func getBusiness() {
        viewModel.getBusiness(id: viewModel.businessId)
    }
    
    private func getReviews() {
        viewModel.getReviews(id: viewModel.businessId)
    }
}

extension BusinessViewController: ViewModelInteractor {
    func success(_ network: Network) {
        switch network {
        case .getBusiness:
            configureView()
            getReviews()
        default:
            DispatchQueue.main.async {
                self.bussinessTableView.reloadData()
            }
        }
    }
    
    func failed(_ message: String) {
        
    }
}

class OpenMapDirections {
    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
    static func present(in viewController: UIViewController, sourceView: UIView, object: SearchBusinessesResponse.Business) {
        let actionSheet = UIAlertController(title: "Open Location", message: "Choose an app to open direction", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            // Pass the coordinate inside this URL
            let url = URL(string: "comgooglemaps://?daddr=\(object.coordinates?.latitude ?? 0),\(object.coordinates?.longitude ?? 0)&directionsmode=driving&zoom=14&views=traffic")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            let coordinate = CLLocationCoordinate2DMake(object.coordinates?.latitude ?? 0,object.coordinates?.longitude ?? 0)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

