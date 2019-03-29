//
//  ViewController.swift
//  CoachMark
//
//  Created by Sudhanshu Sudhanshu on 27/03/19.
//  Copyright © 2019 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath1 = IndexPath(item: 3, section: 0)
        let cell1 = myTableView.cellForRow(at: indexPath1) as! Cell
        let convertedRect1 = cell1.button.convert(cell1.button.bounds, to: nil)
        
        let indexPath2 = IndexPath(item: 5, section: 0)
        let cell2 = myTableView.cellForRow(at: indexPath2) as! Cell
        let convertedRect2 = cell2.button.convert(cell2.button.bounds, to: nil)
        
        let coachMark1 = CoachMark(message: "1 Hey! Please click here.", sourceRect: convertedRect1)
        let coachMark2 = CoachMark(message: "2 Hey! Please click here.", sourceRect: convertedRect2)
        
        let coachMarkContainerView = CoachMarkContainerView(coachMarks: [coachMark1, coachMark2])
        view.addSubview(coachMarkContainerView)

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        return cell
    }


}

