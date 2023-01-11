//
//  CalcResultModalViewController.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/10.
//

import UIKit

final class CalcResultModalViewController: UIViewController {
    
    let calcVC = CalcViewController()
    
    private let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "계산 결과"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let modalViewLogoImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "calcResultModalView_main_image.svg")
        iv.sizeToFit()
        return iv
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constant.SizeSetting.calcResultFontSize, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Data provided by CoinGecko"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let coingeckoLogoImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sizeToFit()
        return iv
    }()
    
    private lazy var calcSaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constant.UIColorSetting.themeColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcSaveButtonName, for: .normal)
        button.setTitleColor(.label, for: .normal)
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CalcViewController로부터 데이터를 전달받
        calcVC.dataDelegate = self
    
        setupNavBar()
        setupView()
        setupContainerView()
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
        containerView.addSubview(modalViewLogoImage)
        containerView.addSubview(resultLabel)
//        containerView.addSubview(coingeckoLogoImage)
//        containerView.addSubview(notesLabel)
        containerView.addSubview(calcSaveButton)
        
        let logoImageURL = URL(string: "https://static.coingecko.com/s/coingecko-branding-guide-8447de673439420efa0ab1e0e03a1f8b0137270fbc9c0b7c086ee284bd417fa1.png")
        coingeckoLogoImage.kf.setImage(with: logoImageURL)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            modalViewLogoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            modalViewLogoImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            modalViewLogoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            modalViewLogoImage.heightAnchor.constraint(equalTo: modalViewLogoImage.widthAnchor, multiplier: 773.0/1075.0),
            
            resultLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            resultLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            resultLabel.topAnchor.constraint(equalTo: modalViewLogoImage.bottomAnchor, constant: 30),
            
            calcSaveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            calcSaveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            calcSaveButton.widthAnchor.constraint(equalToConstant: 140),
            calcSaveButton.heightAnchor.constraint(equalToConstant: 40),
            
//            coingeckoLogoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            coingeckoLogoImage.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10),
//            coingeckoLogoImage.widthAnchor.constraint(equalToConstant: 104.7*1),
//            coingeckoLogoImage.heightAnchor.constraint(equalToConstant: 27.9*1),
//
//            notesLabel.topAnchor.constraint(equalTo: coingeckoLogoImage.bottomAnchor, constant: 15),
//            notesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
//            notesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
        ])
    }
    
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
}

// CalcViewController로부터 데이터를 전달받기 위해 커스텀 프로토콜 채택
extension CalcResultModalViewController: CalcResultDelegate {
    func receiveData(with data: (Double, Double, Double, Double)) {
        print(data)
        resultLabel.text = """
                           \(data.0.toUSD())를 이용해\n
                           XX코인에 투자한 결과입니다.\n
                           XXXX년 XX월 XX일에 전액 매수하고\n
                           XXXX년 XX월 XX일에 전액 매도한 결과\n
                           \(data.2.toUSD())(\(data.1.toPercentage()))의 수익을 기록하였습니다.\n
                           따라서 최종 평가금액은 \(data.3.toUSD())입니다.
                           """
    }
}
