//
//  SWHomeViewController.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWHomeViewController: UITableViewController, SWAddEditTableViewControllerDelegate {

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
        
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
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
        let AddViewController: SWAddEditTableViewController! = SWAddEditTableViewController.init()
        AddViewController.delegate = self
        navigationController!.pushViewController(AddViewController, animated: true)
    }
    
    private func presentWecomeViewController() {
        let wecomeViewController = SWWecomeViewController.init()
        
        wecomeViewController.closure = {
            let data = UIImage.init(named: "test")!.jpegData(compressionQuality: 0)!
            let raffle = SWRaffle.init(name: "My Raffle", price: 0, stock: 1000, maximumNumber: 1000, purchaseLimit: 1, description: "", wallpaperData: data)
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
        }
        
        let raffle = raffles[indexPath.row]
        cell!.nameLabel.text = raffle.name
        let cleanZeroPrice = raffle.price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", raffle.price) :String(raffle.price)
        cell!.priceLabel.text = raffle.price > 0 ? "$" + cleanZeroPrice : "Free"
        cell!.stockLabel.text = raffle.stock > 0 ? "Stock: " + String(raffle.stock) : "Sold Out"
        cell!.wallpaperView.image = UIImage.init(data: raffle.wallpaperData)

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentRow = indexPath.row
        let raffle = raffles[indexPath.row]
        let editTableViewController = SWAddEditTableViewController.init()
        editTableViewController.raffle = raffle
        editTableViewController.delegate = self
        navigationController?.pushViewController(editTableViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SWTitleView.init()
        header.titleLabel.text = "All Raffles"
        
        return header
    }
        
    // MARK: - SWAddEditTableViewControllerDelegate
    
    func didAddRaffle(_ raffle: SWRaffle) {
        
        isReadyToInsert = true

        raffles.insert(raffle, at: 0)
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.insert(raffle: SWRaffle(name:raffle.name, price:raffle.price, stock:raffle.stock, maximumNumber:raffle.maximumNumber, purchaseLimit:raffle.purchaseLimit, description:raffle.description, wallpaperData:raffle.wallpaperData))
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
}
