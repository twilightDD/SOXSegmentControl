//
//  ColorfulSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 29.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl

class ColorfulSegmentControlViewController: UIViewController {

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
extension ColorfulSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .underlineBar


        let segments = [SOXSegmentDescriptor(title: "A",
                                             selectedTextColor: .systemPurple,
                                             unSelectedTextColor: .systemPurple,
                                             selectedFont: UIFont.systemFont(ofSize: 15.0),
                                             unSelectedFont: UIFont.systemFont(ofSize: 15.0),
                                             imageName: "a.circle",
                                             selectedImageColor: .systemBlue,
                                             unSelectedImageColor: .systemBlue,
                                             segmentType: .bottom,
                                             selectorColor: .systemGreen,
                                             selectorType: .background,
                                             selectorStyle: .rounded),
                        SOXSegmentDescriptor(title: "B",
                                             selectedTextColor: .systemBlue,
                                             unSelectedTextColor: .systemBlue,
                                             selectedFont: UIFont.systemFont(ofSize: 15.0),
                                             unSelectedFont: UIFont.systemFont(ofSize: 15.0),
                                             imageName: "b.circle",
                                             selectedImageColor: .systemGreen,
                                             unSelectedImageColor: .systemGreen,
                                             segmentType: .bottom,
                                             selectorColor: .systemYellow,
                                             selectorType: .underlineBar,
                                             selectorStyle: .square),
                        SOXSegmentDescriptor(title: "C",
                                             selectedTextColor: .systemGreen,
                                             unSelectedTextColor: .systemGreen,
                                             selectedFont: UIFont.systemFont(ofSize: 15.0),
                                             unSelectedFont: UIFont.systemFont(ofSize: 15.0),
                                             imageName: "c.circle",
                                             selectedImageColor: .systemYellow,
                                             unSelectedImageColor: .systemYellow,
                                             segmentType: .bottom,
                                             selectorColor: .systemRed,
                                             selectorType: .background,
                                             selectorStyle: .square),
                        SOXSegmentDescriptor(title: "D",
                                             selectedTextColor: .systemYellow,
                                             unSelectedTextColor: .systemYellow,
                                             selectedFont: UIFont.systemFont(ofSize: 15.0),
                                             unSelectedFont: UIFont.systemFont(ofSize: 15.0),
                                             imageName: "d.circle",
                                             selectedImageColor: .systemRed,
                                             unSelectedImageColor: .systemRed,
                                             segmentType: .bottom,
                                             selectorColor: .systemPurple,
                                             selectorType: .underlineBar,
                                             selectorStyle: .none),
                        SOXSegmentDescriptor(title: "E",
                                             selectedTextColor: .systemRed,
                                             unSelectedTextColor: .systemRed,
                                             selectedFont: UIFont.systemFont(ofSize: 15.0),
                                             unSelectedFont: UIFont.systemFont(ofSize: 15.0),
                                             imageName: "e.circle",
                                             selectedImageColor: .systemPurple,
                                             unSelectedImageColor: .systemPurple,
                                             segmentType: .bottom,
                                             selectorColor: .systemBlue,
                                             selectorType: .background,
                                             selectorStyle: .round)]

        segmentControl.setSegmentDescriptors([segments])
    }

}
