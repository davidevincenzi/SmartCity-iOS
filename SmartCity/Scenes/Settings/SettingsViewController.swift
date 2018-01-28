//
//  SettingsViewController.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
        let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier,
        let cellType = CellType(rawValue: identifier)
        else { return }
        
        switch cellType {
        case .signOut:
            
            AuthenticationServices().signOut()
            let transition = ChildViewControllerSlideDownTransition()
            AppDelegate.shared.rootViewController.reload(with: transition)
            didClickCloseButton()
            
        case .changeCity:
            
            performSegue(withIdentifier: "toCitySelector", sender: nil)
                        
        }
        
    }
    
    // MARK: -
    
    @IBAction func didClickCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    
    enum CellType: String {
        case changeCity = "change-city"
        case signOut = "sign-out"
    }
    
}
