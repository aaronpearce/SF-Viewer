//
//  DetailViewController.swift
//  MetaSymbols
//
//  Created by Aaron Pearce on 15/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: WeightAndScaleViewControllerDelegate?
    
    var currentWeight: UIImage.SymbolWeight = .regular {
        didSet {
            configureView()
        }
    }
    
    var currentScale: UIImage.SymbolScale = .default {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let symbol = symbol {
            self.loadViewIfNeeded()
            iconView.image = UIImage(systemName: symbol.shortName)
            iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 144, weight: currentWeight, scale: currentScale)
            title = symbol.shortName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    var symbol: Symbol? {
        didSet {
            configureView()
        }
    }
    
    @IBAction func showWeightPicker(_ sender: UIBarButtonItem) {
        guard let weightScale = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "WeightScale") as? WeightAndScaleViewController else {
                return
        }
        
        weightScale.currentScale = currentScale
        weightScale.currentWeight = currentWeight
        weightScale.delegate = self
        
        let popoverPush = PopoverPushController(rootViewController: weightScale)
        popoverPush.modalPresentationStyle = .popover
        popoverPush.popoverPresentationController?.delegate = self
        popoverPush.popoverPresentationController?.barButtonItem = sender
        popoverPush.popoverPresentationController?.sourceRect = view.bounds
        popoverPush.popoverPresentationController?.permittedArrowDirections = [.up]
        present(popoverPush, animated: true)
    }

    @IBAction func export(_ sender: UIBarButtonItem) {
        guard let symbol = symbol, let documents = FileManager.default.urls(
          for: .documentDirectory,
          in: .userDomainMask
        ).first else { return }
        
        let alert = UIAlertController(title: "Choose Export Format", message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = sender

        for format in ExportFormat.allCases {
            let action = UIAlertAction(title: format.rawValue, style: .default) { (action) in
                do {
                    let fullURL = try format.exporter.export(symbol: symbol, weight: self.currentWeight, scale: self.currentScale, in: Symbols.getFont()!, to: documents)
                    let activity = UIActivityViewController(
                      activityItems: [fullURL],
                      applicationActivities: nil
                    )
                    activity.excludedActivityTypes = [
                        .saveToCameraRoll
                    ]
                    activity.popoverPresentationController?.barButtonItem = sender
                    // 3
                    self.present(activity, animated: true, completion: nil)
                } catch {
                    print(error)
                }
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

}

extension DetailViewController: WeightAndScaleViewControllerDelegate {
    func didUpdate(scale: UIImage.SymbolScale) {
        delegate?.didUpdate(scale: scale)
        self.currentScale = scale
    }
    
    func didUpdate(weight: UIImage.SymbolWeight) {
        delegate?.didUpdate(weight: weight)
        self.currentWeight = weight
    }
}


extension DetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailCell
    
        guard let symbol = symbol else { return cell }
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = symbol.shortName
        case (0, 1):
            cell.textLabel?.text = "Private Unicode"
            cell.detailTextLabel?.text = symbol.newPUAs
        case (0, 2):
            cell.textLabel?.text = "Unicode"
            if let unicode = symbol.unicodes, unicode != "XXXXX", unicode != "NO" {
                cell.detailTextLabel?.text = unicode
            } else {
                cell.detailTextLabel?.text = "N/A"
            }
        case (0, 3):
            cell.textLabel?.text = "Categories"
            cell.detailTextLabel?.text = "\(symbol.categories?.joined(separator: ", ").capitalized ?? "N/A")"
        case (0, 4):
            cell.textLabel?.text = "Additional Keywords"
            cell.detailTextLabel?.text = symbol.additionalSearchMetadata ?? "N/A"
        case (0, 5):
            cell.textLabel?.text = "Modifiable"
            cell.detailTextLabel?.text = symbol.nonModifiable ? "No" : "Yes"
        case (0, 6):
            cell.textLabel?.text = "Notes"
            cell.detailTextLabel?.text = symbol.protectedSymbolNotes ?? "None"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch (indexPath.row) {
        case 5, 6:
            return nil
        default:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                return self.makeContextMenu(for: indexPath)
            })
        }
    }

    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {

        let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc.fill")) { [weak self] _ in
            guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath)
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell?.detailTextLabel?.text
        }

        // Create and return a UIMenu with the share action
        return UIMenu(title: "", children: [copyAction])
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .dismiss
    }
    
}
