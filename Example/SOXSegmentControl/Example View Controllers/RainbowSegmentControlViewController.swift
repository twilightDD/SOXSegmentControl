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
        segmentControl.type = .imageOnTop
        segmentControl.selectorType = .underlineBar

        let segments = [SOXSegmentDescriptor(buttonTitle: "A",
                                             buttonImageName: "a.circle",
                                             selectedColor: .systemPurple),
                        SOXSegmentDescriptor(buttonTitle: "B",
                                             buttonImageName: "b.circle",
                                             selectedColor: .systemBlue),
                        SOXSegmentDescriptor(buttonTitle: "C",
                                             buttonImageName: "c.circle",
                                             selectedColor: .systemGreen),
                        SOXSegmentDescriptor(buttonTitle: "D",
                                             buttonImageName: "d.circle",
                                             selectedColor: .systemYellow),
                        SOXSegmentDescriptor(buttonTitle: "E",
                                             buttonImageName: "e.circle",
                                             selectedColor: .systemRed)
        ]

        segmentControl.segmentDescriptors = [segments]
    }

}
