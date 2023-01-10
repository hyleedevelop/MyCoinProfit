//
//  CalcResultModalViewController.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/10.
//

import UIKit

protocol SendDataDelegate {
    func recieveData(response data: String) -> Void
}

final class CalcResultModalViewController: UIViewController, SendDataDelegate {

    let calcVC = CalcViewController()
    
    private let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "계산 결과"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.sizeToFit()
        return iv
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Data provided by CoinGecko"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcVC.dataDelegate = self
        setupNavBar()
        setupView()
        setupContainerView()
    }
    
    func recieveData(response data: String) {
        print(data)
    }
    
    private func setupNavBar() {
        //navigationItem.title = "도움말"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navBarTitleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .gray
        
        navBarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.addSubview(logoImage)
        containerView.addSubview(notesLabel)
        
        let logoImageURL = URL(string: "https://static.coingecko.com/s/coingecko-branding-guide-8447de673439420efa0ab1e0e03a1f8b0137270fbc9c0b7c086ee284bd417fa1.png")
        logoImage.kf.setImage(with: logoImageURL)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            logoImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            logoImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            logoImage.widthAnchor.constraint(equalToConstant: 104.7*1),
            logoImage.heightAnchor.constraint(equalToConstant: 27.9*1),
            
            notesLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15),
            notesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            notesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
        ])
    }
    
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
}
