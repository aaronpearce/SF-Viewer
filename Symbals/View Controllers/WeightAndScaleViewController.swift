//
//  WeightAndScaleViewController.swift
//  Symbals
//
//  Created by Aaron Pearce on 21/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

protocol WeightAndScaleViewControllerDelegate {
    func didUpdate(weight: UIImage.SymbolWeight)
    func didUpdate(scale: UIImage.SymbolScale)
}

class WeightAndScaleViewController: UITableViewController {
    
    var currentScale: UIImage.SymbolScale = .default {
        didSet {
            self.loadViewIfNeeded()
            scaleLabel.text = currentScale.displayString
        }
    }

    var currentWeight: UIImage.SymbolWeight = .regular {
        didSet {
            self.loadViewIfNeeded()
            weightLabel.text = currentWeight.displayString
        }
    }

    var delegate: WeightAndScaleViewControllerDelegate?
    
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setContentSize()
    }
    
    func setContentSize() {
        let size = CGSize(width: 250, height: 88)
        preferredContentSize = size
        popoverPresentationController?
            .presentedViewController
            .preferredContentSize = size
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weightVC = segue.destination as? WeightTableViewController {
            weightVC.delegate = self
            weightVC.currentWeight = currentWeight
        } else if let scaleVC = segue.destination as? ScaleTableViewController {
            scaleVC.delegate = self
            scaleVC.currentScale = currentScale
        }
    }
}

extension WeightAndScaleViewController: WeightAndScaleViewControllerDelegate {
    func didUpdate(scale: UIImage.SymbolScale) {
        delegate?.didUpdate(scale: scale)
        self.currentScale = scale
    }
    
    func didUpdate(weight: UIImage.SymbolWeight) {
        delegate?.didUpdate(weight: weight)
        self.currentWeight = weight
    }
}
