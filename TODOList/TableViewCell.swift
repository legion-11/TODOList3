//
//  TableViewCell.swift
//  TODOList
//
//  Created by Dmytro Andriichuk $301132978 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//
//  Assignment #5

import UIKit

//custome cell
class TableViewCell: UITableViewCell {
    
    //deadline
    var tableView: TableViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var taskSwitch: UISwitch!
    
    //finish task grey out labels
    @IBAction func swichPressed(_ sender: UISwitch) {
        if sender.isOn{
            tableView?.isDone[indexPath!.row] = true
            title.textColor = UIColor.gray
            date.textColor = UIColor.gray
        }else{
            tableView?.isDone[indexPath!.row] = false
            // if deadline was not set or deadline in future
            if (tableView?.hasDate[indexPath!.row] == true && (tableView?.dates[indexPath!.row])! > Date() ) {
                title.textColor = UIColor.label
                date.textColor = UIColor.label
            // deadline has come
            }else{
                title.textColor = UIColor.red
                date.textColor = UIColor.red
            }
        }
        tableView?.saveToPersistentList()
        
    }
}
