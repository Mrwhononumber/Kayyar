//
//  KayyarTableViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit

class KayyarTableViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    var spots: Spots!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        spots = Spots()
        myTableView.delegate = self
        myTableView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showMySpinner()
        spots.loadData {
//            self.sortBasedOnSegmentPressed()
            self.myTableView.reloadData()
            print("😅\(self.spots.spotArray.count)")
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeMySpenner()
       
    }
    
    //MARK: - Segmented Control Implementation
    
    func sortBasedOnSegmentPressed(){

        switch mySegmentedControl.selectedSegmentIndex {
        case 0: // Recent
            let formatter = DateFormatter()
           
            spots.spotArray.sort{$0.submitionDate.compare($1.submitionDate, options: .numeric) == .orderedDescending}
            print("sort func got triggered")
            
        case 1: // Distance
        print("TODO")
        case 2: // Kayyar Level
        print ("TODO")
        default:
            print ("error occured, check segmented control for an error")
        }
        myTableView.reloadData()
        

    }

    @IBAction func mySegmentedControlPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()

    }
    

}

//MARK: - TableView Delegate and Datasource Methods

extension KayyarTableViewController: UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return spots.spotArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
        cell.streetLabel.text = spots.spotArray[indexPath.row].address
        cell.cityLabel.text = spots.spotArray[indexPath.row].city
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destination = segue.destination as! detailViewController
            let selectedIndexPath = myTableView.indexPathForSelectedRow!
            destination.detailSpot = spots.spotArray[selectedIndexPath.row]
        }
       
        
    }


}
