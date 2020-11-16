//
//  AddEmployeeTableViewController.swift
//  Employee
//
//  Created by Kasito on 16.11.2020.
//

import UIKit
import FirebaseDatabase

class AddEmployeeTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var photoImageView: UIImageView! 
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var developerSwitch: UISwitch! {
        didSet {
            developerSwitch.isOn = false
        }
    }
    
    var isDev = false
    var timeInterval: TimeInterval = 0
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func isDeveloper(sender: UISwitch) {
        isDev = sender.isOn
    }
    
    @IBAction func changeDate(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.medium
        let strDate = timeFormatter.string(from: datePicker.date)
        timeInterval = datePicker.date.timeIntervalSince1970
        dateOfBirth.text = strDate
    }
    
    @IBAction func saveEmployee(sender: AnyObject) {
        guard let name = nameTextField.text else { return }
        
        if name != "" {
            var stringImage: String = ""
            if let image = photoImageView.image {
                stringImage = image.jpegData(compressionQuality: 0.1)!.base64EncodedString()
            }
            
            let items: [String : Any] = ["username" : name, "dateOfBirth" : timeInterval, "developer" : isDev, "foto" : stringImage]
            self.ref.child("profiles/\(name)").setValue(items)
            
            dismiss(animated: true, completion: nil)
        }
    }
}

extension AddEmployeeTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        photoImageView.image = info[.originalImage] as? UIImage
    }
}
