//
//  EditViewController.swift
//  TODOList
//
//  Created by legion-11 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskNotes: UITextView!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    let formatter = DateFormatter()
    
    var cell: TableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.text = cell?.title.text
        taskNotes.text = cell?.notes
        taskDate.setDate(cell?.dateOriginal ?? Date(), animated: false)
        if let cellDate = cell?.dateOriginal{dateSwitch.setOn(true, animated: true)}
        
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTitle.text = cell?.title.text
        taskNotes.text = cell?.notes
        taskDate.setDate(cell?.dateOriginal ?? Date(), animated: false)
    }
    
    @IBAction func editTaskTitle(_ sender: UITextField) {
        cell?.title.text = sender.text
    }
    
    @IBAction func del(_ sender: Any) {
        print("del")
    }
    @IBAction func changeDate(_ sender: UIDatePicker) {
        cell?.dateOriginal = sender.date
        
        cell?.date.text = formatter.string(from: sender.date)
        
        if(!dateSwitch.isOn){dateSwitch.setOn(true, animated: true)}
    }
    @IBAction func enableDate(_ sender: UISwitch) {
        if (sender.isOn){
            cell?.dateOriginal = taskDate.date
            cell?.date.text = formatter.string(from: taskDate.date)
        }else{
            cell?.dateOriginal = nil
            cell?.date.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text ?? "default")
        cell?.notes = textView.text
    }
}
