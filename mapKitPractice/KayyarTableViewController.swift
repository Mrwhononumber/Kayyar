//
//  KayyarTableViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit

class KayyarTableViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    var spots: Spots!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        spots = Spots()
        myTableView.delegate = self
        myTableView.dataSource = self
        
//         Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMySpinner()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spots.loadData {
            self.myTableView.reloadData()
            print("😅\(self.spots.spotArray.count)")
        }
        removeMySpenner()
    }
    



}
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
