//
//  SavedColorsViewController.swift
//  ColorLab
//
//  Created by Mikhail Bobretsov on 20/12/2017.
//  Copyright © 2017 Mikhail. All rights reserved.
//

import UIKit
import CoreData

class SavedColorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var colors: [Color] = []
    var filteredColors: [Color] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    func fetchData() {
        do {
            let sort = NSSortDescriptor(key: #keyPath(Color.date), ascending: false)
            let request = NSFetchRequest<Color>(entityName: "Color")
            request.sortDescriptors = [sort]
            
            colors = try context.fetch(request)
            filteredColors = colors
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            fatalError("Error during fetching the color list: \(error), description: \(error.description)")
        }
    }
    
    //MARK: - SearchBar Set Up
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredColors = colors
        } else {
            filteredColors = colors.filter{ $0.name!.lowercased().contains(searchText.lowercased()) }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    //MARK: - Table Set up
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? colorTableViewCell {
            
            let colorObject = filteredColors[indexPath.row]
            
            cell.colorView.backgroundColor = colorObject.color as? UIColor
            cell.nameLabel.text = colorObject.name
            cell.hexLabel.text = colorObject.hex
            cell.rgbLabel.text = colorObject.rgb
            
            let tapShowFullColor = UITapGestureRecognizer(target: self, action: #selector(showFullColor(sender:)))
            cell.colorView.addGestureRecognizer(tapShowFullColor)
            
            
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    @objc func showFullColor(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        performSegue(withIdentifier: "showColor", sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            let colorObject = self.filteredColors[indexPath.row]
            self.context.delete(colorObject)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredColors.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        delete.backgroundColor = UIColor.red
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            var objectsToShare = [Any]()
            
            let colorObject = self.filteredColors[indexPath.row]
            
            if let name = colorObject.name,
                let hex = colorObject.hex,
                let rgb = colorObject.rgb {
                
                let stringToShare = "Name: \(name)\nHEX: \(hex)\nRGB: \(rgb)"
                
                let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 200), false, 0)
                UIColor.color(fromHexString: String(hex.dropFirst())).setFill()
                UIRectFill(rect)
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                objectsToShare.append(stringToShare)
                objectsToShare.append(image)
                
                let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        share.backgroundColor = UIColor.color(fromHexString: "14FF69")
        
        let rename = UITableViewRowAction(style: .default, title: "Rename") { (action, indexPath) in
            
            let alertControllet = UIAlertController(title: "Enter New Name", message: nil, preferredStyle: .alert)
            alertControllet.addTextField { (textField) in
                textField.placeholder = "New name..."
            }
            let confirmAction = UIAlertAction(title: "Save", style: .default) { (action) in
                if let textFieldArray = alertControllet.textFields, let textField = textFieldArray.first {
                    let newName: String
                    if let text = textField.text {
                        if !text.isEmpty {
                            newName = text
                            let colorObject = self.filteredColors[indexPath.row]
                            colorObject.name = newName
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            if let cell = tableView.cellForRow(at: indexPath) as? colorTableViewCell {
                                cell.nameLabel.text = newName
                            }
                        }
                    } else {
                        return
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertControllet.addAction(confirmAction)
            alertControllet.addAction(cancelAction)
            
            self.show(alertControllet, sender: nil)
        }
        rename.backgroundColor = UIColor.color(fromHexString: "207FFF")
        
        return [delete, share, rename]
    }
    
    //MARK: - IBActions
    @IBAction func segmentedControlValueChanged(sender: Any) {
        if let segControl = sender as? UISegmentedControl {
            
            switch segControl.selectedSegmentIndex {
            case 0: filteredColors = filteredColors.sorted{ $0.name!.lowercased().localizedCaseInsensitiveCompare($1.name!.lowercased()) == ComparisonResult.orderedAscending}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            case 1: filteredColors = filteredColors.sorted{ $0.date! > $1.date! }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            default: break
            }
            
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showColor", let controller = segue.destination as? FullColorViewController, let indexPath = sender as? IndexPath, let cell = tableView.cellForRow(at: indexPath) as? colorTableViewCell, let color = cell.colorView.backgroundColor {
            controller.color = color
        }
    }
}
