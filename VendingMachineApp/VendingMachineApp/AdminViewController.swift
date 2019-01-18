//
//  AdminViewController.swift
//  VendingMachineApp
//
//  Created by 윤지영 on 17/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    @IBOutlet var beverageImages: [RoundedCornersImageView]!
    @IBOutlet var beverageLabels: [UILabel]!

    private weak var vendingMachine: AdminMode?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerAsObserver()
        updateAllQuantityLabels()
    }

    func set(vendingMachine: AdminMode?) {
        self.vendingMachine = vendingMachine
    }

    private func registerAsObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(showQuantities(_:)), name: .inventoryDataChanged, object: nil)
    }

    private func updateOneQuantityLabel(at index: Int) {
        let count =  vendingMachine?.count(beverage: index)
        beverageLabels[index].text = "\(count ?? 0)개"
    }

    private func updateAllQuantityLabels() {
        for index in beverageLabels.indices {
            updateOneQuantityLabel(at: index)
        }
    }

    @objc private func showQuantities(_ notification: Notification) {
        if let beverage = notification.userInfo?[Notification.InfoKey.beverageQuantityChanged] as? BeverageSubCategory {
            let index = beverage.rawValue
            updateOneQuantityLabel(at: index)
            return
        }
        updateAllQuantityLabels()
    }

    @IBAction func addBeverageButtonTouched(_ sender: UIButton) {
        guard let beverage = BeverageSubCategory(rawValue: sender.tag) else { return }
        guard let vendingMachine = vendingMachine else { return }
        vendingMachine.add(beverage: beverage)
    }

    @IBAction func closeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
