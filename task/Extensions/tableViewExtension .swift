//
//  tableViewExtension .swift
//  task
//
//  Created by Mina Gamil  on 12/24/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import Foundation
import UIKit
extension UITableView{
    func registerNib<cell:UITableViewCell>(cell:cell.Type){
        let nibName = String(describing: cell)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}
