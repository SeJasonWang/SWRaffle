//
//  SWWecomeViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/19.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

protocol SWWecomeViewControllerDelegate: NSObjectProtocol {
    func didAddDefaultRaffle(_ raffle: SWRaffle)
}

class SWWecomeViewController: UIViewController {

    weak var delegate: SWWecomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true
        view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel.init()
        let titleLabel1 = UILabel.init()
        let titleLabel2 = UILabel.init()
        let subTitleLabel1 = UILabel.init()
        let subTitleLabel2 = UILabel.init()
        let continueButton = UIButton.init(type: .custom)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel1.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel2.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(subTitleLabel1)
        view.addSubview(subTitleLabel2)
        view.addSubview(continueButton)

        titleLabel.text = "Welcome to Your Raffles"
        titleLabel1.text = "Control Your Raffles"
        titleLabel2.text = "Sell and Share tickets"
        subTitleLabel1.text = "My parents grew to like my girlfriend so much, they take her as their own daughter. Now they started looking for a proper boyfriend for her."
        subTitleLabel2.text = "I got another letter from this lawyer today. It said “Final Notice”. Good that he will not bother me anymore. "
        continueButton.setTitle("Continue", for: .normal)
        
        titleLabel.textAlignment = .center
        titleLabel1.textAlignment = .left
        titleLabel2.textAlignment = .left
        subTitleLabel1.textAlignment = .left
        subTitleLabel2.textAlignment = .left

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel2.font = UIFont.boldSystemFont(ofSize: 15)
        subTitleLabel1.font = UIFont.systemFont(ofSize: 15)
        subTitleLabel2.font = UIFont.systemFont(ofSize: 15)

        subTitleLabel1.textColor = UIColor.lightGray
        subTitleLabel2.textColor = UIColor.lightGray
        continueButton.backgroundColor = UIColor.orange
        
        subTitleLabel1.numberOfLines = 0
        subTitleLabel2.numberOfLines = 0

        continueButton.layer.cornerRadius = 10
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        // layout Views
        let layoutViews:[String: UIView] = ["view": view,
                                            "titleLabel": titleLabel,
                                            "titleLabel1": titleLabel1,
                                            "titleLabel2": titleLabel2,
                                            "subTitleLabel1": subTitleLabel1,
                                            "subTitleLabel2": subTitleLabel2,
                                            "continueButton": continueButton]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[titleLabel]-25-|", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-50-[titleLabel1]-50-|", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-50-[titleLabel2]-50-|", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-50-[subTitleLabel1]-50-|", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-50-[subTitleLabel2]-50-|", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[continueButton]-25-|", options:[], metrics:nil, views:layoutViews))

        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-80-[titleLabel]", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[titleLabel]-80-[titleLabel1]", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[titleLabel1]-0-[subTitleLabel1]", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[subTitleLabel1]-20-[titleLabel2]", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[titleLabel2]-0-[subTitleLabel2]", options:[], metrics:nil, views:layoutViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[continueButton(==50)]-60-|", options:[], metrics:nil, views:layoutViews))

    }
    
    @objc private func continueButtonPressed() {
        dismiss(animated: true) {            
            let data = UIImage.init(named: "test")!.jpegData(compressionQuality: 0)!
            let stock = 100
            let raffle = SWRaffle.init(name: "My Raffle", price: 0, stock: Int32(stock), maximumNumber: Int32(stock), purchaseLimit: 0, description: "This is your raffle description", wallpaperData: data, isMarginRaffle: 0)
            self.delegate?.didAddDefaultRaffle(raffle)
        }
    }
    
}
