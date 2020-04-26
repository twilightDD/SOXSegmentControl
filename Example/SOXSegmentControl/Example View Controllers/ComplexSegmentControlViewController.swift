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
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .background

        let segments = [SOXSegmentDescriptor(title: "Segment A",
                                             imageName: "a.circle"),
                        SOXSegmentDescriptor(title: "Segment B",
                                             imageName: "b.circle"),
                        SOXSegmentDescriptor(title: "Segment C",
                                             imageName: "c.circle")]

        let segments2 = [SOXSegmentDescriptor(title: "Segment D",
                                              imageName: "d.circle"),
                         SOXSegmentDescriptor(title: "Segment E",
                                              imageName: "e.circle"),
                         SOXSegmentDescriptor(title: "Segment F",
                                              imageName: "f.circle")]

        let segments3 = [SOXSegmentDescriptor(title: "Segment G",
                                              imageName: "g.circle"),
                         SOXSegmentDescriptor(title: "Segment H",
                                              imageName: "h.circle"),
                         SOXSegmentDescriptor(title: "Segment I",
                                              imageName: "i.circle")]

        
        segmentControl.setSegmentDescriptors([segments,
                                              segments2,
                                              segments3])
    }

}
