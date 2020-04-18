//
//  SWAddEditTableViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/17.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

protocol SWAddEditTableViewControllerDelegate: NSObjectProtocol {
    func didAddRaffle(_ raffle: SWRaffle)
    func didEditRaffle(_ raffle: SWRaffle)
}

class SWAddEditTableViewController: UITableViewController, UITextFieldDelegate {

    weak var delegate: SWAddEditTableViewControllerDelegate?
    var raffle: SWRaffle?

    override func viewDidLoad() {
        super.viewDidLoad()

        if raffle == nil {
            self.title = "Add"
        } else {
            self.title = "Edit"
        }
        
        self.tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        self.tableView.separatorStyle = .none

    }

    // MARK: - Pricate Methods
    
    private func check() -> Bool {
        let nameCell: SWTextFieldTableViewCell? = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? SWTextFieldTableViewCell
        let priceCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? SWTextFieldTableViewCell
        let stockCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? SWTextFieldTableViewCell
        let maximumLimitCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? SWTextFieldTableViewCell

        if nameCell?.textField.text?.count == 0 {
            self.showAlert("Please enter a name.")
            return false
        } else if priceCell?.textField.text?.count == 0 {
            self.showAlert("Please enter a price.")
            return false
        } else if stockCell?.textField.text?.count == 0 {
            self.showAlert("Please enter a stock.")
            return false
        } else if maximumLimitCell?.textField.text?.count == 0 {
            self.showAlert("Please enter a maximum limit.")
            return false
        }

        return true
    }
    
    private func showAlert(_ message: String?) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func result() -> SWRaffle {
        let nameCell: SWTextFieldTableViewCell? = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? SWTextFieldTableViewCell
        let priceCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? SWTextFieldTableViewCell
        let stockCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? SWTextFieldTableViewCell
        let maximumLimitCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as? SWTextFieldTableViewCell
        let descriptionCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as? SWTextFieldTableViewCell
        
        let name = (nameCell?.textField.text)!
        let price = Double((priceCell?.textField.text)!)!
        let stock = Int32((stockCell?.textField.text)!)!
        let maximumLimit = Int32((maximumLimitCell?.textField.text)!)!
        let description = (descriptionCell?.textField.text)!
        
        if raffle == nil {
            raffle = SWRaffle.init(name: name, price: price, stock: stock, maximumLimit: maximumLimit, description: description)
        } else {
            raffle!.name = name
            raffle!.price = price
            raffle!.stock = stock
            raffle!.maximumLimit = maximumLimit
            raffle!.description = description
        }
        return raffle!
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 5 {
            return 1
        } else if section == 5 {
            return 3
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 && indexPath.row == 2 {
            return 150
        } else if indexPath.section == 6 {
            return 60
        } else {
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < 5 {
            let identifier = "SWTextFieldTableViewCell"
            var cell: SWTextFieldTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWTextFieldTableViewCell
            if cell == nil {
                cell = SWTextFieldTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell!.textField.delegate = self
            }

            cell?.selectionStyle = .none
            switch indexPath.section {
            case 0:
                cell!.textField.placeholder = "Ex. Lucy Door Prize"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.text = raffle == nil ? "" : raffle!.name
            case 1:
                cell!.textField.placeholder = "0~99999999"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .decimalPad
                cell!.textField.text = raffle == nil ? "" : String(raffle!.price)
            case 2:
                cell!.textField.placeholder = "1~99999999.99"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .numberPad
                cell!.textField.text = raffle == nil ? "" : String(raffle!.stock)
            case 3:
                cell!.textField.placeholder = "1~99999999"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .numberPad
                cell!.textField.text = raffle == nil ? "" : String(raffle!.maximumLimit)
            default:
                cell!.textField.placeholder = "(Optional)"
                cell!.textField.returnKeyType = UIReturnKeyType.done
                cell!.textField.text = raffle == nil ? "" : String(raffle!.description)
            }
            
            return cell!
        } else if indexPath.section == 5 {
            
            if indexPath.row < 2 {
                let identifier = "UITableViewCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                if cell == nil {
                    cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                }
                
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell!.accessoryType = .disclosureIndicator

                if indexPath.row == 0 {
                    cell!.textLabel?.text = "Take Photo..."
                } else {
                    cell!.textLabel?.text = "Choose from Existing"
                }
                return cell!
            } else {
                let identifier = "SWWallpaperTableViewCell"
                var cell: SWWallpaperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWWallpaperTableViewCell
                if cell == nil {
                    cell = SWWallpaperTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                }
                
                cell!.wallpaperView.image = UIImage.init(named: "test")

                return cell!
            }
            
        } else {
            let identifier = "SWButtonTableViewCell"
            var cell: SWButtonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWButtonTableViewCell
            if cell == nil {
                cell = SWButtonTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
            }
            
            cell!.label.text = "Save"
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 5 {
            if indexPath.row == 0 {
                print("Take Photo...")
            } else {
                print("Choose from Existing")
            }
        } else if indexPath.section == 6 {
            if self.check() == true {

                self.navigationController?.popViewController(animated: true)
                if raffle == nil {
                    self.delegate?.didAddRaffle(self.result())
                } else {
                    self.delegate?.didEditRaffle(self.result())
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 5 {
            return 25
        } else if section == 6 {
            return 0
        } else {
            return 15
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SWTitleView.init()
        
        switch section {
        case 0:
            header.titleLabel.text = "Raffle Name"
        case 1:
            header.titleLabel.text = "Price"
        case 2:
            header.titleLabel.text = "Stock"
        case 3:
            header.titleLabel.text = "Maximum Limit"
        case 4:
            header.titleLabel.text = "Description"
        case 5:
            header.titleLabel.text = "Ticket Wallpaper"
        default:
            header.titleLabel.text = ""
        }
        
        return header
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 4 {
            return 0
        } else {
            return 20
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init()
        return footer
    }
    
    // MARK: - UIScrollViewDelegate

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var cell = textField.superview!.superview as! SWTextFieldTableViewCell
        let section = self.tableView.indexPath(for: cell)?.section
        
        if section == 0 {
            cell = (self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! SWTextFieldTableViewCell)
            cell.textField.becomeFirstResponder()
        } else {
            cell.textField.resignFirstResponder()
        }

        return true
    }
}
