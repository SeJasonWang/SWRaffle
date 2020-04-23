//
//  SWShareTableViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/21.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

protocol SWShareTableViewControllerDelegate: NSObjectProtocol {
    func didSellTickets(_ tickets: Array<SWTicket>)
}

class SWShareTableViewController: UITableViewController {

    weak var delegate: SWShareTableViewControllerDelegate?

    var tickets: Array<SWTicket>!
    var raffle: SWRaffle!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = navigationController?.viewControllers.first as? SWShareTableViewControllerDelegate
        
        title = "Share"

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tickets.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < tickets.count {
            return UIScreen.main.bounds.size.width / 2.5
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < tickets.count {
            let identifier = "SWWallpaperTableViewCell"
            var cell: SWWallpaperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWWallpaperTableViewCell
            if cell == nil {
                cell = SWWallpaperTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell!.editButton.isHidden = true
            }
            
            let ticket = tickets[indexPath.section]
            cell!.wallpaperView.image = UIImage.init(data: raffle.wallpaperData)
            cell!.numberLabel.text = ticket.ticketNumber.ticketNumberString()
            cell!.nameLabel.text = raffle.name
            cell!.descriptionLabel.text = raffle.description
            cell!.priceLabel.text = raffle.price.priceString()
            cell!.stockLabel.text = ticket.customerName
            
            return cell!
        } else {
            let identifier = "SWButtonTableViewCell"
            var cell: SWButtonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWButtonTableViewCell
            if cell == nil {
                cell = SWButtonTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
                cell!.label.text = "Submit and Share tickets"
                cell!.label.textColor = UIColor.orange
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == tickets.count {
            navigationController?.popToRootViewController(animated: true)
            delegate?.didSellTickets(tickets)
        }
    }

        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        } else if section == tickets.count {
            return 20
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = SWTitleView.init(bottom: 0)
            header.titleLabel.text = "All Tickets"
            return header
        } else {
            return UIView.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == tickets.count {
            view.backgroundColor = UIColor.clear
        } else {
            view.backgroundColor = UIColor.white
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < tickets.count - 1 {
            return 12
        } else if section == tickets.count - 1 {
            return 62.5
        } else {
            return 20
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tickets.count - 1 {
            // Total price and Amount
            let footer = SWTitleView.init(bottom: 12)
            footer.titleLabel.textColor = UIColor.red
            footer.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            let amountStr = "Amount: " + String(tickets.count) + "\n"
            let totalPriceStr = "Total Price: " + (raffle.price * Double(tickets.count)).priceString()
            footer.titleLabel.text = amountStr + totalPriceStr
            return footer
        } else {
            return UIView.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section < tickets.count {
            view.backgroundColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.clear
        }
    }
}
