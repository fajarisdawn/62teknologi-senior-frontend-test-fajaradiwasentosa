//
//  ReviewTableViewCell.swift
//  FrontEndTest
//
//  Created by fajaradiwasentosa on 16/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ object: ReviewResponse.Review) {
        guard let user = object.user else { return }
        nameLabel.text = user.name.capitalized
        reviewLabel.text = object.text
        profileImageView.loadImageUsingCacheWithUrlString(urlString: user.profileUrl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ReviewTableViewCell: ReusableCell {}
