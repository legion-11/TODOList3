//
//  TableViewCell.swift
//  TODOList
//
//  Created by legion-11 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

//custome cell
class TableViewCell: UITableViewCell {
    
    
    //notes for todo item
    var notes = ""
    //deadline
    var dateOriginal: Date?
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var taskSwitch: UISwitch!
    
    //finish task grey out labels
    @IBAction func swichPressed(_ sender: UISwitch) {
        if sender.isOn{
            //
            title.textColor = UIColor.gray
            date.textColor = UIColor.gray
        }else{
            // if deadline was not set or deadline in future
            if ((date.text != "" && dateOriginal! > Date()) || date.text == ""){
                title.textColor = UIColor.label
                date.textColor = UIColor.label
            // deadline has come
            }else{
                title.textColor = UIColor.red
                date.textColor = UIColor.red
            }
        }
    }
}
