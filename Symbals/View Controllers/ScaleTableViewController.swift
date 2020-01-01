//
//  ScaleTableViewController.swift
//  Symbals
//
//  Created by Aaron Pearce on 21/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class ScaleTableViewController: UITableViewController {
    
    var currentScale: UIImage.SymbolScale = .default {
        didSet {
            delegate?.didUpdate(scale: currentScale)
        }
    }

    var delegate: WeightAndScaleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setContentSize()
    }
    
    func setContentSize() {
        let size = CGSize(width: 250, height: tableView.contentSize.height + 44)
        preferredContentSize = size
        popoverPresentationController?
            .presentedViewController
            .preferredContentSize = size
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIImage.SymbolScale.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let scale = UIImage.SymbolScale.allCases[indexPath.row]
        cell.textLabel?.text = scale.displayString
        
        cell.accessoryType = (scale == currentScale) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentScale = UIImage.SymbolScale.allCases[indexPath.row]
        tableView.cellForRow(at: indexPath)
        for cell in tableView.visibleCells {
            if cell == tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

