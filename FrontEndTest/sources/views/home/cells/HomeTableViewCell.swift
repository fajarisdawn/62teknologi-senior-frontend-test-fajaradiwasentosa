//
//  HomeTableViewCell.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var starRattingView: [UIImageView]!
    @IBOutlet weak var bussinessImageView: UIImageView!
    @IBOutlet weak var bussinessTitleLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ model: SearchBusinessesResponse.Business?) {
        guard let `model` = model else { return }
        bussinessTitleLabel.text = model.name
        bussinessImageView.loadImageFromURL(url: model.imageURL ?? NetworkProperties.imageNotFoundUrl)
        categoriesLabel.text = (model.categories?.compactMap { $0.title })?.joined(separator: ",")
        phoneNumberLabel.text = model.displayPhone
        reviewCountLabel.text = "\(model.reviewCount ?? 0) Reviews"
        priceLabel.text = model.price
        setupRattingView(model.rating)
    }
    
    private func setupRattingView(_ ratting: Double?) {
        for rattingView in starRattingView {
            if Double(rattingView.tag) <= ratting?.rounded(.towardZero) ?? 0 {
                rattingView.image = UIImage(systemName: "star.fill")
            } else {
                if ratting ?? 0 == Double(rattingView.tag) - 0.5 {
                    rattingView.image = UIImage(systemName: "star.leadinghalf.filled")
                } else {
                    rattingView.image = UIImage(systemName: "star")
                }
            }
        }
    }
}

extension HomeTableViewCell: ReusableCell {}
