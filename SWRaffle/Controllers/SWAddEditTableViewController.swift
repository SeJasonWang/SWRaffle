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
    func didDeleteRaffle(_ raffle: SWRaffle)
    func didEditRaffle(_ raffle: SWRaffle)
}

class SWAddEditTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var delegate: SWAddEditTableViewControllerDelegate?
    
    var raffle: SWRaffle?
    var name: String! = ""
    var price: String! = ""
    var stock: String! = ""
    var purchaseLimit: String! = ""
    var descriptionStr: String! = ""
    var wallpaperImage: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if raffle == nil {
            title = "Add"
        } else {
            title = "Edit"
            
            name = raffle?.name
            let cleanZeroPrice = raffle!.price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", raffle!.price) :String(raffle!.price)
            price = cleanZeroPrice
            stock = String(raffle!.stock)
            purchaseLimit = String(raffle!.purchaseLimit)
            descriptionStr = raffle!.description
            wallpaperImage = UIImage.init(data: raffle!.wallpaperData)
        }
                
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))

        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.separatorStyle = .none

        viewWillLayoutSubviews()
    }

    // MARK: - Pricate Methods
        
    @objc func doneButtonPressed() {
        if check() {
            navigationController?.popViewController(animated: true)
            if raffle == nil {
                delegate?.didAddRaffle(result())
            } else {
                delegate?.didEditRaffle(result())
            }
        }
    }

    private func check() -> Bool {

        if name?.count == 0 {
            showAlert("Please enter a name.")
            return false
        } else if price?.count == 0 {
            showAlert("Please enter a price.")
            return false
        } else if stock?.count == 0 {
            showAlert("Please enter a stock.")
            return false
        } else if purchaseLimit?.count == 0 {
            showAlert("Please enter a purchase limit.")
            return false
        } else if wallpaperImage == nil {
            showAlert("Please set a ticket wallpaper.")
            return false
        }

        return true
    }
    
    private func showAlert(_ message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func result() -> SWRaffle {
        
        if raffle == nil { // Add
            raffle = SWRaffle.init(name: name, price: Double(price)!, stock: Int32(stock)!, maximumNumber: Int32(stock)!, purchaseLimit: Int32(purchaseLimit)!, description: descriptionStr, wallpaperData: wallpaperImage!.jpegData(compressionQuality: 0)!)
        } else { // Edit
            raffle!.name = name
            raffle!.price = Double(price)!
            raffle!.stock = Int32(stock)!
            raffle!.maximumNumber += (Int32(stock)! - raffle!.stock) // uplate the maximumNumber after editing the current stock
            raffle!.purchaseLimit = Int32(purchaseLimit)!
            raffle!.description = descriptionStr!
            raffle!.wallpaperData = wallpaperImage!.jpegData(compressionQuality: 0)!
        }
        return raffle!
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if raffle != nil {
            return 7
        } else {
            return 6
        }
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
            return UIScreen.main.bounds.size.width / 2.5 + 12
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
                cell!.textField.text = name
            case 1:
                cell!.textField.placeholder = "0~99999999"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .decimalPad
                cell!.textField.text = price
            case 2:
                cell!.textField.placeholder = "1~99999999.99"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .numberPad
                cell!.textField.text = stock
            case 3:
                cell!.textField.placeholder = "1~99999999"
                cell!.textField.returnKeyType = UIReturnKeyType.next
                cell!.textField.keyboardType = .numberPad
                cell!.textField.text = purchaseLimit
            default:
                cell!.textField.placeholder = "(Optional)"
                cell!.textField.returnKeyType = UIReturnKeyType.done
                cell!.textField.text = descriptionStr
            }
            
            return cell!
        } else if indexPath.section == 5 {
            
            if indexPath.row < 2 {
                let identifier = "UITableViewCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                if cell == nil {
                    cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                }
                
                cell!.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell!.textLabel?.textColor = UIColor.orange

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
                if raffle != nil {
                    cell?.wallpaperView.image = UIImage.init(data: raffle!.wallpaperData)
                }
                
                return cell!
            }
            
        } else {
            let identifier = "SWButtonTableViewCell"
            var cell: SWButtonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWButtonTableViewCell
            if cell == nil {
                cell = SWButtonTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
            }
            
            cell!.label.font = UIFont.systemFont(ofSize: 16)
            cell!.label.text = "Delete Raffle"
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 5 {
            if indexPath.row == 0 {
                print("Camera")
            } else if (indexPath.row == 1) {
                let pickerCamera = UIImagePickerController()
                
                pickerCamera.allowsEditing = true
                pickerCamera.sourceType = .photoLibrary
                pickerCamera.delegate = self
                
                present(pickerCamera, animated: true, completion: nil)
            }
        } else if indexPath.section == 6 {
            
            if raffle!.maximumNumber == raffle!.stock {
                
                let alert = UIAlertController(title: nil, message: "Are you sure you want to delete \"" + raffle!.name + "\"?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in

                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didDeleteRaffle(self.raffle!)

                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert, animated: true)

            } else {
                
                let alert = UIAlertController(title: nil, message: "\"" + raffle!.name + "\"" + "has sold tickets and cannot be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)

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
        view.endEditing(true)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var cell = textField.superview!.superview as! SWTextFieldTableViewCell
        let section = tableView.indexPath(for: cell)?.section
        
        if section == 0 {
            cell = (tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! SWTextFieldTableViewCell)
            cell.textField.becomeFirstResponder()
        } else {
            cell.textField.resignFirstResponder()
        }

        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cell = textField.superview!.superview as! SWTextFieldTableViewCell
        let section = tableView.indexPath(for: cell)?.section
        
        switch section {
        case 0:
            name = textField.text
        case 1:
            price = textField.text
        case 2:
            stock = textField.text
        case 3:
            purchaseLimit = textField.text
        default:
            descriptionStr = textField.text
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        var imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if picker.allowsEditing {
            imagePicker = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!
        }

        let cell: SWWallpaperTableViewCell? = tableView.cellForRow(at: IndexPath.init(row: 2, section: 5)) as? SWWallpaperTableViewCell
        cell?.wallpaperView.image = imagePicker
        wallpaperImage = imagePicker
        
        dismiss(animated: true, completion: nil)
    }
}
