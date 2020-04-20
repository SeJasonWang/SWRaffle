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
    var name: String! = ""
    var amount: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sell"

        tableView.separatorStyle = .none
    }

    // MARK: - Pricate Methods

    private func check() -> Bool {

        if name.count == 0 {
            showAlert("Please enter a customer's name.")
            return false
        } else if amount.count == 0 {
            showAlert("Please enter an amount.")
            return false
        }

        return true
    }

    private func showAlert(_ message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        } else if section == 1 {
            return 25
        } else if section == 4 {
            return 0
        } else {
            return 15
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 4 {
            let header = UIView.init()
            header.backgroundColor = UIColor.white
            return header
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
            return UIScreen.main.bounds.size.width / 2.5
        } else if indexPath.section == 4 {
            return 60
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
            
            cell!.wallpaperView.image = UIImage.init(data: raffle.wallpaperData)
            cell!.numberLabel.text = "No. " + String(raffle.maximumNumber - raffle.stock + 1)
            cell!.nameLabel.text = raffle.name
            cell!.descriptionLabel.text = raffle.description
            cell!.priceLabel.text = raffle.price > 0 ? "$" + raffle.price.cleanZeroString() : "Free"
            cell!.stockLabel.text = raffle.stock > 0 ? "Stock: " + String(raffle.stock) : "Sold Out"

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
            cell!.textLabel?.text = "TODO..."
            
            return cell!
            
        } else if indexPath.section <= 3 {
            
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
        } else {
            let identifier = "SWButtonTableViewCell"
            var cell: SWButtonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWButtonTableViewCell
            if cell == nil {
                cell = SWButtonTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell!.label.textColor = UIColor.orange
                cell!.label.text = "Confirm"
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if check() {

        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 20
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    
    // MARK: - UIScrollViewDelegate

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var cell = textField.superview!.superview as! SWTextFieldTableViewCell
        let section = tableView.indexPath(for: cell)?.section
        
        if section == 2 {
            cell = (tableView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as! SWTextFieldTableViewCell)
            cell.textField.becomeFirstResponder()
        } else {
            cell.textField.resignFirstResponder()
        }

        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textFieldCell = textField.superview!.superview as! SWTextFieldTableViewCell
        let section = tableView.indexPath(for: textFieldCell)?.section
                
        if section == 2 {
            name = textField.text
        } else {
            amount = textField.text
        }
    }

}
