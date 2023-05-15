//
//  HomeViewController.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var cancelButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    private var locValue: CLLocationCoordinate2D!
    private let locationManager = CLLocationManager()
    private var viewModel: HomeViewModel!
    
    init(_ viewModel: HomeViewModel) {
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
        self.viewModel = viewModel
        self.viewModel.interactor = self
        configureCoordinate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        setupHomeNavigation()
        configureTableView()
    }
    
    private func bindViewModel() {
        if let parameter = self.viewModel.businessesParameter {
            viewModel.searchBusinesses(parameter: parameter)
        }
    }
    
    private func configureTextField() {
        searchTextField.delegate = self
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        tableView.registerReusableCell(HomeTableViewCell.self)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        searchTextField.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bussinessModel?.businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        if let model = viewModel.bussinessModel {
            cell.configureCell(model.businesses?[indexPath.item])
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = viewModel.bussinessModel,
           let bussinessModel = model.businesses,
           let totalResult = model.total {
            if !viewModel.isEndPage {
                let lastElement = bussinessModel.count - 1
                if bussinessModel.count < totalResult && indexPath.row == lastElement && !self.viewModel.loadMore {                    
                    viewModel.loadMore = true
                    bindViewModel()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let businesses = viewModel.bussinessModel, let business = businesses.businesses?[indexPath.item] else { return }
        let viewModel = BusinessViewModel()
        viewModel.businessId = business.id ?? ""
        self.redirect(to: BusinessViewController(viewModel))
    }
    
}

extension HomeViewController: ViewModelInteractor {
    func success(_ network: Network) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func failed(_ message: String) {
        print(message)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func configureCoordinate() {
        locationManager.delegate = self
        DispatchQueue.global().async {[weak self] in
            guard let self = self else { return }
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    if #available(iOS 14.0, *) {
                        switch self.locationManager.accuracyAuthorization {
                        case .fullAccuracy:
                            print("Precise Location allowed")
                        case .reducedAccuracy:
                            print("Precise location disabled")
                        default:
                            print("Precise Location not known")
                        }
                    } else {
                        if CLLocationManager.locationServicesEnabled() {
                            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                            self.locationManager.startUpdatingLocation()
                        }
                    }
                    self.viewModel.businessesParameter = SearchBusinessesParameter(
//                        latitude: self.locationManager.location?.coordinate.latitude,
//                        longitude: self.locationManager.location?.coordinate.longitude
                        latitude: 40.730610,
                        longitude: -73.935242
                    )
                    self.bindViewModel()
                default:
                    print("Bakekok")
                }
            } else {
                print("Location services are not enabled");
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.configureCoordinate()
        }
    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cancelButtonWidthConstraint.constant = 50
        cancelButtonLeading.constant = 12
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        cancelButtonWidthConstraint.constant = 0
        cancelButtonLeading.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if searchTextField.text != "" {
            viewModel.businessesParameter?.term = textField.text
        }
        bindViewModel()
        return true
    }
}
