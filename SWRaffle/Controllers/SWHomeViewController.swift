//
//  SWHomeViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

extension Int32 {
    public func ticketNumberString() -> String {
        return self > 0 ? "No. " + String(self) : ""
    }
    public func stockString() -> String {
        return self > 0 ? "Stock: " + String(self) : "Sold Out"
    }
}

extension Double {
    public func priceString() -> String {
        return self > 0 ? "$" + self.cleanZeroString() : "Free"
    }
    public func cleanZeroString() -> String {
        let cleanZeroString = self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) :String(self)
        return cleanZeroString
    }
}

class SWHomeViewController: UITableViewController, SWAddEditTableViewControllerDelegate, SWShareTableViewControllerDelegate {
    
    var raffles = [SWRaffle]()
    var currentRow = -1
    var isReadyToInsert = false
    var isReadyToDelete = false
    var isReadyToReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(addButtonPressed))
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        raffles = database.selectAllRaffles()
        
        if raffles.count == 0 {
            presentWecomeViewController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isReadyToInsert {
            tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            isReadyToInsert = false
        }
        if isReadyToDelete {
            tableView.deleteRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .automatic)
            isReadyToDelete = false
        }
        if isReadyToReload {
            tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .automatic)
            isReadyToReload = false
        }
    }
            
    // MARK: - Private Methods
    
    @objc private func addButtonPressed() {
        let AddViewController: SWAddEditTableViewController! = SWAddEditTableViewController.init(style: .grouped)
        AddViewController.delegate = self
        navigationController!.pushViewController(AddViewController, animated: true)
    }
    
    @objc private func editButtonPressed(_ sender: UIButton) {
        
        let row = tableView.indexPath(for: sender.superview!.superview! as! UITableViewCell)!.row
        
        currentRow = row
        let raffle = raffles[row]
        let editTableViewController = SWAddEditTableViewController.init(style: .grouped)
        editTableViewController.raffle = raffle
        editTableViewController.delegate = self
        navigationController?.pushViewController(editTableViewController, animated: true)
    }
    
    private func presentWecomeViewController() {
        let wecomeViewController = SWWecomeViewController.init()
        
        wecomeViewController.closure = {
            let data = UIImage.init(named: "test")!.jpegData(compressionQuality: 0)!
            let raffle = SWRaffle.init(name: "My Raffle", price: 0, stock: 1000, maximumNumber: 1000, purchaseLimit: 1, description: "", wallpaperData: data, soldTickets:Array.init())
            let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
            database.insert(raffle: raffle)
            self.raffles = database.selectAllRaffles()

            self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        }
        
        self.present(wecomeViewController, animated: true, completion: nil)
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raffles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width / 2.5 + 12
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SWWallpaperTableViewCell"
        var cell: SWWallpaperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWWallpaperTableViewCell
        if cell == nil {
            cell = SWWallpaperTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
            cell!.editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
            cell!.needsBottomMargin = true
        }
        
        let raffle = raffles[indexPath.row]
        cell!.wallpaperView.image = UIImage.init(data: raffle.wallpaperData)
        cell!.numberLabel.text = (raffle.maximumNumber - raffle.stock + 1).ticketNumberString()
        cell!.nameLabel.text = raffle.name
        cell!.descriptionLabel.text = raffle.description
        cell!.priceLabel.text = raffle.price.priceString()
        cell!.stockLabel.text = raffle.stock.stockString()

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentRow = indexPath.row

        let sellViewController = SWSellTableViewController.init(style: .grouped)
        sellViewController.raffle = raffles[indexPath.row]
        navigationController?.pushViewController(sellViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SWTitleView.init(bottom: 0)
        header.titleLabel.text = "All Raffles"
        
        return header
    }
        
    // MARK: - SWAddEditTableViewControllerDelegate
    
    func didAddRaffle(_ raffle: SWRaffle) {
        
        isReadyToInsert = true

        raffles.insert(raffle, at: 0)
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.insert(raffle: raffle)
        raffles = database.selectAllRaffles()
        
    }
    
    func didEditRaffle(_ raffle: SWRaffle) {
        
        isReadyToReload = true
        
        raffles[currentRow] = raffle
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.update(raffle: raffle)

    }
    
    func didDeleteRaffle(_ raffle: SWRaffle) {

        isReadyToDelete = true
        
        raffles.remove(at: currentRow)
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.delete(raffle: raffle)
        
        if raffles.count == 0 {
            presentWecomeViewController()
        }
    }
    
    // MARK: - SWSellTableViewControllerDelegate
    
    func didSellTickets(_ soldTickets: Array<SWSoldTicket>) {
        
        isReadyToReload = true

        var raffle = raffles[currentRow]
        raffle.soldTickets += soldTickets
        raffle.stock -= Int32(soldTickets.count)
        raffles[currentRow] = raffle
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.update(raffle: raffle)
    }

}
