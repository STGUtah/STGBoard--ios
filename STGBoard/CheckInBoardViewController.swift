//
//  CheckInBoardViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

class CheckInBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PersonTableViewCellDelegate {
    
    let personController = PersonController.shared
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        personController.getAllPeopleFromServer { (people) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func refreshAction(){
        personController.getAllPeopleFromServer { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        
        let person = personController.people[indexPath.row]
        
        cell.person = person
        cell.selectionStyle = .none
        
        return cell
    }
    
    func didChangePersonCheckedInStatus(_ person: Person, cell: PersonTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        var person = personController.people[index.row]
        person.isInOffice = cell.checkedInSwitch.isOn
        cell.checkedInSwitchValueChanged(cell.checkedInSwitch)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
