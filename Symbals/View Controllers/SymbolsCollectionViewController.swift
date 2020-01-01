//
//  SymbolsCollectionViewController.swift
//  Symbals
//
//  Created by Aaron Pearce on 15/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class SymbolsCollectionViewController: BaseCollectionViewController {
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.scopeButtonTitles = ["All".localized, "Home".localized, "Room".localized]
        return searchController
    }()
    
    var currentWeight: UIImage.SymbolWeight = .regular {
        didSet {
            updateWeightOrScale()
        }
    }
    
    var currentScale: UIImage.SymbolScale = .medium {
        didSet {
            updateWeightOrScale()
        }
    }

    var initialDetailLoaded = false
    lazy var symbols: Symbols = {
        return Symbols {
            DispatchQueue.main.async {

                self.collectionView.reloadData()
                
                if !self.initialDetailLoaded {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        let initialIndexPath = IndexPath(row: 0, section: 0)
                        self.collectionView.selectItem(at: initialIndexPath, animated: true, scrollPosition: .top)
                        if let symbol = self.symbols.symbol(for: initialIndexPath) {
                            self.performSegue(withIdentifier: "showDetail", sender: symbol)
                        }
                    }
                    self.initialDetailLoaded = true
                        
                }
            }
        }
    }()
    
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding * 2, right: padding)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        /*
        let segmented = UISegmentedControl(items: [UIImage(systemName: "square.grid.3x2.fill"), UIImage(systemName: "text.justify")])
        segmented.setTitleTextAttributes([.foregroundColor: UIColor(named: "primary")!], for: .normal)
        segmented.setTitleTextAttributes([.foregroundColor: UIColor(named: "primary")!], for: .selected)
        segmented.selectedSegmentIndex = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmented)
        */
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func updateWeightOrScale() {
        collectionView.reloadData()
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    override func registerCells() {
        collectionView.register(BaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(SymbolCell.self, forCellWithReuseIdentifier: "SymbolCell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return symbols.symbolKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = symbols.symbolKeys[section]
        return symbols.symbolsByCategory[key]?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SymbolCell", for: indexPath) as! SymbolCell
        
        if let symbol = symbols.symbol(for: indexPath) {
            cell.imageView.image = UIImage(systemName: symbol.shortName)
            cell.imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: currentWeight, scale: currentScale)
            cell.label.text = symbol.shortName.replacingOccurrences(of: ".", with: ".\u{200B}")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionViewDisplayWidth - (padding * 2)) / 3 - 1
        
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! BaseHeaderView
            header.titleLabel.text = symbols.symbolKeys[indexPath.section].capitalized
            return header
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: 0, height: 24)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let symbol = sender as? Symbol {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.symbol = symbol
                controller.currentScale = currentScale
                controller.currentWeight = currentWeight
                controller.delegate = self
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let symbol = symbols.symbol(for: indexPath) {
            performSegue(withIdentifier: "showDetail", sender: symbol)
        }
    }
}


extension SymbolsCollectionViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text, scope: searchController.searchBar.selectedScopeButtonIndex)
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String?, scope: Int = 0) {
        symbols.filter(for: searchText)
        collectionView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

extension SymbolsCollectionViewController: WeightAndScaleViewControllerDelegate {
    func didUpdate(scale: UIImage.SymbolScale) {
        self.currentScale = scale
    }
    
    func didUpdate(weight: UIImage.SymbolWeight) {
        self.currentWeight = weight
    }
}


extension SymbolsCollectionViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
