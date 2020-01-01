//
//  PopoverPushController.swift
//  Symbals
//
//  Created by Aaron Pearce on 21/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

final class PopoverPushController: UIViewController {
    private let wrappedNavigationController: UINavigationController

    init(rootViewController: UIViewController) {
        self.wrappedNavigationController = UINavigationController(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wrappedNavigationController.willMove(toParent: self)
        self.addChild(wrappedNavigationController)
        self.view.addSubview(wrappedNavigationController.view)
    }
}
