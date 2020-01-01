//
//  SettingsTableViewController.swift
//  Symbals
//
//  Created by Aaron Pearce on 17/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit
import SafariServices

class SettingsTableViewController: UITableViewController {
    let appIdentifier = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    @IBAction func close() {
        dismiss(animated: true)
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            showAttribution()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAttribution() {
        guard let url = URL(string: "https://github.com/davedelong/sfsymbols") else { return }
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true)
    }
}
