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
    var currentSection = -1
    var isReadyToInsert = false
    var isReadyToReload = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "Home"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(addButtonPressed))
        
        self.tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        self.tableView.separatorStyle = .none
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        raffles = database.selectAllRaffles()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isReadyToInsert {
            tableView.insertSections([0], with: .automatic)
            isReadyToInsert = false
        }
        if isReadyToReload {
            tableView.reloadSections([currentSection], with: .automatic)
            isReadyToReload = false
        }
    }
    
    @objc func addButtonPressed() {
        let AddViewController: SWAddEditTableViewController! = SWAddEditTableViewController.init()
        AddViewController.delegate = self
        self.navigationController!.pushViewController(AddViewController, animated: true)
    }
    
    // MARK: - Public Methods
    public func updateTableView() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return raffles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SWWallpaperTableViewCell"
        var cell: SWWallpaperTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? SWWallpaperTableViewCell
        if cell == nil {
            cell = SWWallpaperTableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }
        
        let raffle = raffles[indexPath.section]
        cell!.nameLabel.text = raffle.name
        cell!.priceLabel.text = raffle.price > 0 ? "$" + String(raffle.price) : "Free"
        cell!.stockLabel.text = raffle.stock > 0 ? "Stock: " + String(raffle.stock) : "Sold Out"
        cell!.wallpaperView.image = UIImage.init(named: "test")
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentSection = indexPath.section
        let raffle = raffles[indexPath.section]
        let editTableViewController = SWAddEditTableViewController.init()
        editTableViewController.raffle = raffle
        editTableViewController.delegate = self
        self.navigationController?.pushViewController(editTableViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SWTitleView.init()
        header.titleLabel.text = "All Raffles"
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init()
        return footer
    }
    
    // MARK: - SWAddEditTableViewControllerDelegate
    
    func didAddRaffle(_ raffle: SWRaffle) {
        
        raffles.insert(raffle, at: 0)
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.insert(raffle: SWRaffle(name:raffle.name, price:raffle.price, stock:raffle.stock, maximumLimit:raffle.maximumLimit, description:raffle.description))
        
        isReadyToInsert = true
    }
    
    func didEditRaffle(_ raffle: SWRaffle) {
        
        raffles[currentSection] = raffle
        
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.update(raffle: raffle)

        isReadyToReload = true
    }
}
