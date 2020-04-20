//
//  SWSellTableViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/20.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWSellTableViewController: UITableViewController, UITextFieldDelegate {

    var raffle: SWRaffle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sell"

        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        } else {
            return 15
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView.init()
        } else {
            let header = SWTitleView.init()
            switch section {
            case 1:
                header.titleLabel.text = "History Customers"
            case 2:
                header.titleLabel.text = "Customer Name"
            default:
                header.titleLabel.text = "Amount"
            }
            return header
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.size.width / 2.5 + 12
        } else {
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = "SWWallpaperTableViewCell"
            var cell: SWWallpaperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWWallpaperTableViewCell
            if cell == nil {
                cell = SWWallpaperTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell?.editButton.isHidden = true
            }
            
            cell!.nameLabel.text = raffle.name
            cell!.descriptionLabel.text = raffle.description
            cell!.priceLabel.text = raffle.price > 0 ? "$" + raffle.price.cleanZeroString() : "Free"
            cell!.stockLabel.text = raffle.stock > 0 ? "Stock: " + String(raffle.stock) : "Sold Out"
            cell!.wallpaperView.image = UIImage.init(data: raffle.wallpaperData)

            return cell!
        } else if indexPath.section == 1 {
            
            // History Customers
            let identifier = "UITableViewCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if cell == nil {
                cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
            }
            
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell!.textLabel?.textColor = UIColor.orange
            cell!.textLabel?.text = "OK"
            
            return cell!
            
        } else {
            
            // Customer Name & Amount
            let identifier = "SWTextFieldTableViewCell"
            var cell: SWTextFieldTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWTextFieldTableViewCell
            if cell == nil {
                cell = SWTextFieldTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell!.textField.delegate = self
                cell!.selectionStyle = .none
            }

            switch indexPath.section {
            case 2:
                cell!.textField.placeholder = "Enter your customer's name"
                cell!.textField.returnKeyType = UIReturnKeyType.next
            default:
                cell!.textField.placeholder = "Enter an amount of tickets"
                cell!.textField.returnKeyType = UIReturnKeyType.done
            }
            
            return cell!
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
}
