//
//  TableViewCell.swift
//  TODOList
//
//  Created by legion-11 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var notes = ""
    var dateOriginal: Date?
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBAction func swicthPress(_ sender: UISwitch) {
        print("switch")
    }
    
}
