//
//  ComplexSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl

class ComplexSegmentControlViewController: UIViewController {

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
extension ComplexSegmentControlViewController {

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

        let segments2 = [SOXSegmentDescriptor(buttonTitle: "Segment D",
                                             buttonImageName: "d.circle"),
                        SOXSegmentDescriptor(buttonTitle: "Segment E",
                                             buttonImageName: "e.circle"),
                        SOXSegmentDescriptor(buttonTitle: "Segment F",
                                             buttonImageName: "f.circle")]

        let segments3 = [SOXSegmentDescriptor(buttonTitle: "Segment G",
                                              buttonImageName: "g.circle"),
                         SOXSegmentDescriptor(buttonTitle: "Segment H",
                                              buttonImageName: "h.circle"),
                         SOXSegmentDescriptor(buttonTitle: "Segment I",
                                              buttonImageName: "i.circle")]


        segmentControl.segmentDescriptors = [segments,
                                             segments2,
                                             segments3]
    }

}
