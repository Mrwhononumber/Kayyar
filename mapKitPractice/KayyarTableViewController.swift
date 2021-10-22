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
        spots = Spots()
        myTableView.delegate = self
        myTableView.dataSource = self
        
//         Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spots.loadData {
            self.myTableView.reloadData()
            print("😅\(self.spots.spotArray.count)")
        }
    }
    



}
extension KayyarTableViewController: UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return spots.spotArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
        cell.streetLabel.text = spots.spotArray[indexPath.row].address

        return cell
    }




}
