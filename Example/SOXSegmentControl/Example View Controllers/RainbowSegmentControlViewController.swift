//
//  RainbowSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl


class RainbowSegmentControlViewController: UIViewController {

    //MARK: - Properties

    //MARK: - IBOutlets
    @IBOutlet private weak var segmentControl: SOXSegmentControl!

    //MARK: - Init&Co.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentControl()
    }

    //MARK: - Action Methods

    @IBAction func segmentControllAction(_ sender: SOXSegmentControl) {
        print("Selected segment with index \(sender.selectedSegmentIndex)")
    }

}


//MARK: - Setup
extension RainbowSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .underlineBar


        let segments = [SOXSegmentDescriptor(title: "A",
                                             imageName: "a.circle",
                                             color: .systemPurple),
                        SOXSegmentDescriptor(title: "B",
                                             imageName: "b.circle",
                                             color: .systemBlue),
                        SOXSegmentDescriptor(title: "C",
                                             imageName: "c.circle",
                                             color: .systemGreen),
                        SOXSegmentDescriptor(title: "D",
                                             imageName: "d.circle",
                                             color: .systemYellow),
                        SOXSegmentDescriptor(title: "E",
                                             imageName: "e.circle",
                                             color: .systemRed)
        ]
        
        segmentControl.setSegmentDescriptors([segments])
        segmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: 2)
    }

}
