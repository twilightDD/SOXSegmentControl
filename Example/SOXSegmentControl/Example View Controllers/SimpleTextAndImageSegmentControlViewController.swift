//
//  SimpleTextAndImageSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl


class SimpleTextAndImageSegmentControlViewController: UIViewController {

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
extension SimpleTextAndImageSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.type = .imageOnTop
        segmentControl.selectorType = .underlineBar

        let segments = [SOXSegmentDescriptor(buttonTitle: "Segment A",
                                             buttonImageName: "a.circle"),
                        SOXSegmentDescriptor(buttonTitle: "Segment B",
                                             buttonImageName: "b.circle"),
                        SOXSegmentDescriptor(buttonTitle: "Segment C",
                                             buttonImageName: "c.circle")]

        segmentControl.segmentDescriptors = [segments]
    }
    
}
