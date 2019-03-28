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
        let indexPath = IndexPath(item: 3, section: 0)
        let cell = myTableView.cellForRow(at: indexPath) as! Cell
        let convertedRect = cell.button.convert(cell.button.bounds, to: nil)
        
        let coachMarkView = CoachMarkView(sourceRect: convertedRect, coachMark: CoachMark(message: "Hey! Please click here."))
        view.addSubview(coachMarkView)

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

