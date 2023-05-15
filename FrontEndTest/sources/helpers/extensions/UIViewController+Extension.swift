//
//  UIViewController+Extension.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupHomeNavigation() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.yelpRedColor()
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

        navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.yelpRedColor()
        navigationController?.navigationBar.barStyle = .default

        guard let navigationWidth = navigationController?.navigationBar.frame.width else { return }
        guard let navigationHeight = navigationController?.navigationBar.frame.height else { return }

        let logoImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: navigationWidth * 0.5, height: navigationHeight))
        logoImageView.image = UIImage(named: "yelp-logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        self.navigationItem.titleView = logoImageView
    }
    
    func redirect(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
