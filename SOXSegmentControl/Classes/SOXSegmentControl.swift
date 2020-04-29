//
//  SOXSegment.swift
//  Tell My Friend
//
//  Created by Peter Hauke on 19.04.20.
//  Copyright © 2020 Peter Hauke. All rights reserved.
//

//  Created by Wasim Malek on 27/05/19.
//  Copyright © 2019 Wasim Malek. All rights reserved.
//

import Foundation
import UIKit


//MARK: - SOXSegmentControl - Class with Properties
open class SOXSegmentControl: UIControl {
    //MARK: Public Properties
    private var selectorView: UIView = UIView()

    public var selectorColor: UIColor = .lightGray { didSet { selectorView.backgroundColor = selectorColor } }
    public var selectorCornerRadius: CGFloat = 5.0 { didSet { updateSelectorViewStyle() } }
    public var selectorMovementAnimated: Bool = true
    public var selectorStyle: SelectorStyle = .square { didSet { updateSelectorViewFrame() } }
    public var selectorType: SelectorType = .background { didSet { updateSelectorViewFrame() } }
    public var underlineBarSelectorHeight : CGFloat = 5.0  { didSet { updateSelectorViewFrame() } }


    public var selectedSegmentPath: SOXIndexPath = SOXIndexPath.init(row: 0, column: 0) {
        didSet {
            //TODO: TODO update selectedSegmentIndex
            let newValue = selectedSegmentPath
            updateSegment(atIndexPath: oldValue, isSelected: false)
            updateSegment(atIndexPath: newValue, isSelected: true)
            updateSelectorViewFrame()
        } }
    public var selectedSegmentIndex: Int = 0

     //MARK: Segment Properties
    public var textPosition: SOXSegmentControl.TextPosition = .right { didSet { updateTextPosition() } }



    //MARK: Border Settings
    public var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor } }
    public var borderCornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = borderCornerRadius } }
    public var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }

    //MARK: Appereance of Selected and Unselected Segments
    public var selectedTextColor: UIColor = .label { didSet { updateView() } }
    public var selectedTintColor: UIColor = .label { didSet { updateView() } }
    public var selectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }
    public var unSelectedTextColor: UIColor = .lightGray { didSet { updateView() } }
    public var unSelectedTintColor: UIColor = .lightGray { didSet { updateView() } }
    public var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }

    //MARK: - Call Back
    //TODO: TODO needs to be reworked; 280420, ph
    var onValueChanged: ((_ index: Int)->())?

    //MARK: - Private Properties
    private var segmentDescriptors: [[SOXSegmentDescriptor]] = [[SOXSegmentDescriptor]]()
    private var linearSegmentDescriptors = [SOXSegmentDescriptor]()
    private var segments = [[SOXSegment]]()


    //MARK: - Override UIView Methods
    open override func layoutSubviews() {
        super.layoutSubviews()

        if segmentDescriptors.count > 0 {
            updateSelectorViewFrame()
        }
    }

}


//MARK: - SOXSegmentControl - Enums
extension SOXSegmentControl {

    public enum SelectorStyle: Int {
        case square
        case round
        case rounded // set selectorCornerRadius
    }

    public enum SelectorType: Int {
        case none
        case background
        case underlineBar
    }

    public enum TextPosition: Int {
        case none
        case right
        case bottom
        //TODO: TODO add text/imagePosition?
    }

}


//MARK: - Public Methods
public extension SOXSegmentControl {
    func setSegmentDescriptors(_ newSegmentDescriptors: [[SOXSegmentDescriptor]]) {
        segmentDescriptors = newSegmentDescriptors
        updateLinearSegmentDescriptors()

        updateSegments()
        updateView()
        updateSegment(atIndexPath: selectedSegmentPath, isSelected: true)
    }

    func setTitles(_ titles: [[String]]) {
        var newSegmentDescriptors = [[SOXSegmentDescriptor]]()

        for rowTitles in titles {
            var newSegmentDescriptorsForRow = [SOXSegmentDescriptor]()
            for title in rowTitles {
                let segmentDescriptor = SOXSegmentDescriptor(title: title)
                newSegmentDescriptorsForRow.append(segmentDescriptor)
            }
            newSegmentDescriptors.append(newSegmentDescriptorsForRow)
        }

        setSegmentDescriptors(newSegmentDescriptors)
    }

}


//MARK: - Private Methods
extension SOXSegmentControl {
    private func updateView() {
        if segmentDescriptors.count == 0 {
            return
        }

        clipsToBounds = true

        subviews.forEach( { $0.removeFromSuperview() } )


        addSubview(selectorView)
        arrangeSegments()
    }

    //MARK: - Segment Handling
    private func updateLinearSegmentDescriptors() {
        linearSegmentDescriptors = [SOXSegmentDescriptor]()
        for segmentDescriptorsForRow in segmentDescriptors {
            linearSegmentDescriptors.append(contentsOf: segmentDescriptorsForRow)
        }
    }

    private func arrangeSegments() {

        // Outer StackView
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .fill
        outerStackView.distribution = .fillEqually

        addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        outerStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        outerStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


        for segmentsForRow in segments {
            let rowStackView = UIStackView(arrangedSubviews: segmentsForRow)
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually//.fillProportionally
            rowStackView.updateConstraints()
            rowStackView.setNeedsLayout()

            outerStackView.addArrangedSubview(rowStackView)
//            outerStackView.updateConstraints()
//            outerStackView.setNeedsLayout()
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
        }

//        outerStackView.updateConstraints()
//        outerStackView.setNeedsLayout()
    }


    private func updateSegments() {

        var newSegments = [[SOXSegment]]()
        var index: Int = 0

        for (row, rowSegmentDescriptors) in segmentDescriptors.enumerated() {
            var rowSegments = [SOXSegment]()

            for (column, segmentDescriptor) in rowSegmentDescriptors.enumerated() {
                let indexPath = SOXIndexPath(row: row, column: column)

                let segment = SOXSegment(indexPath: indexPath, segmentDescriptor: segmentDescriptor)
//                if column % 2 == 0 {
//                    segment.backgroundColor = .brown
//                }
                segment.tag = index
                segment.tintColor = unSelectedTintColor(forIndexPath: indexPath)

                segment.addTarget(self,
                                  action: #selector(buttonTapped(_:)),
                                  for: .touchUpInside)

                if textPosition(forIndexPath: indexPath) != .none {
                    segment.setTitle(segmentDescriptor.title, for: .normal)
                    segment.setTitleColor(unSelectedTextColor(forIndexPath: indexPath), for: .normal)
                    segment.titleLabel?.font = unSelectedFont(forIndexPath: indexPath)
                    segment.titleLabel?.textAlignment = .center
                }

                if let imageName = segmentDescriptor.imageName {
                    let buttonImage = self.image(name: imageName)
                    segment.setImage(buttonImage, for: .normal)

                    switch textPosition {
                        case .none:
                            break
                        case .right:
                            segment.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        case .bottom:
                            segment.centerImageAndButton(5, imageOnTop: true)
                    }
                }

                rowSegments.append(segment)

                index += 1
            }
            newSegments.append(rowSegments)
        }

        segments = newSegments
    }

    private func image(name: String)
        -> UIImage? {
            if let image = UIImage(named: name) {
                return image
            }

            if let systemImage = UIImage(systemName: name) {
                return systemImage
            }

            return nil
    }


    private func updateSegment(atIndexPath indexPath: SOXIndexPath, isSelected: Bool) {

        guard let segmentToUpdate = segment(forIndexPath: indexPath)
            else { return }

        if isSelected == true {
            segmentToUpdate.tintColor = selectedTintColor(forIndexPath: indexPath)
            segmentToUpdate.setTitleColor(selectedTextColor(forIndexPath: indexPath), for: .normal)
            segmentToUpdate.titleLabel?.font = selectedFont(forIndexPath: indexPath)
        }
        else {
            segmentToUpdate.tintColor = unSelectedTintColor(forIndexPath: indexPath)
            segmentToUpdate.setTitleColor(unSelectedTextColor(forIndexPath: indexPath), for: .normal)
            segmentToUpdate.titleLabel?.font = unSelectedFont(forIndexPath: indexPath)
        }

    }


    private func segment(forIndexPath indexPath: SOXIndexPath)
        -> SOXSegment? {
            if segments.count > indexPath.row {
                let segmentsForRow = segments[indexPath.row]
                if segmentsForRow.count > indexPath.column {
                    let segment = segmentsForRow[indexPath.column]
                    return segment
                }
            }

            return nil
    }


    //MARK: - SelectorView Handling

    private func updateSelectorView() {
        updateSelectorViewFrame()
    }

    private func updateSelectorViewBackgroundColor() {
        selectorView.backgroundColor = backgroundColor
    }

    private func updateSelectorViewFrame() {
        if segmentDescriptors.count == 0 { return }

        let newSelectorRow = selectedSegmentPath.row
        let newSelectorColumn = selectedSegmentPath.column

        // Frame
        let segmentWidth = frame.width / CGFloat(segmentDescriptors[newSelectorRow].count)
        let segmentHeight = frame.height / CGFloat(segmentDescriptors.count)
        let segmentOriginX = CGFloat(newSelectorColumn) * segmentWidth
        let segmentOriginY = CGFloat(newSelectorRow) * segmentHeight

        let newSelectorOriginX: CGFloat = segmentOriginX
        var newSelectorOriginY: CGFloat = segmentOriginY
        let newSelectorWidth: CGFloat = segmentWidth
        var newSelectorHeight: CGFloat = 0

        // Selector Type

        switch self.selectorType {
            case .none:
                break
            case .background:
                newSelectorHeight = segmentHeight
            case .underlineBar:
                newSelectorOriginY = segmentOriginY + segmentHeight - underlineBarSelectorHeight
                newSelectorHeight = underlineBarSelectorHeight
        }

        // Selector Style
        var selectorViewCornerRadius: CGFloat = 0
        switch selectorStyle {
            case .square:
                break
            case .round:
                selectorViewCornerRadius = selectorView.frame.height / 2
            case .rounded:
                selectorViewCornerRadius = selectorCornerRadius
        }


        // Update Selector View Frame
        let newUnderlineBarFrame = CGRect(x: newSelectorOriginX,
                                          y: newSelectorOriginY,
                                          width: newSelectorWidth,
                                          height: newSelectorHeight)

        var animationDuration: TimeInterval = 0
        if selectorMovementAnimated == true {
            animationDuration = 0.25
        }

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [unowned self] in
                        //                            fromSegment.isSelected = false
                        //                            toSegment.isSelected = true
                        self.selectorView.frame = newUnderlineBarFrame
                        self.selectorView.backgroundColor = self.selectorColor(forIndexPath: self.selectedSegmentPath)
                        self.selectorView.layer.cornerRadius = selectorViewCornerRadius
            },
                       completion: nil)
    }

    private func updateTextPosition() {
        updateSegments()
        updateView()
        updateSegment(atIndexPath: selectedSegmentPath, isSelected: true)
    }

    private func updateSelectorViewStyle() {
        var cornerRadius: CGFloat
        switch selectorStyle {
            case .round:
                cornerRadius = selectorView.frame.height / 2
            case .rounded:
                cornerRadius = selectorCornerRadius
            default:
                cornerRadius = 0
        }

        selectorView.layer.cornerRadius = cornerRadius
    }



//MARK: - SegmentDesciptor handling

    private func segmentDescriptor(forIndex index: Int)
        -> SOXSegmentDescriptor? {
            guard linearSegmentDescriptors.count >= index
                else { return nil }

            let segmentDescriptor = linearSegmentDescriptors[index]
            return segmentDescriptor
    }

    private func segmentDescriptor(forIndexPath indexPath: SOXIndexPath)
        -> SOXSegmentDescriptor {
            let segmentDescriptorForIndexPath = segmentDescriptor(forRow: indexPath.row,
                                                                  column: indexPath.column)
            return segmentDescriptorForIndexPath
    }

    private func segmentDescriptor(forRow row: Int, column: Int)
        -> SOXSegmentDescriptor {
            let segmentDescriptorsForRow = segmentDescriptors[row]
            let segmentDescriptor = segmentDescriptorsForRow[column]
            return segmentDescriptor
    }


    private func textPosition(forIndexPath indexPath: SOXIndexPath)
        -> TextPosition {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let textPosition = segmentDescriptor.textPosition {
                return textPosition
            }

            return textPosition
    }


    private func selectedTextColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedTextColor = segmentDescriptor.selectedTextColor {
                return selectedTextColor
            }

            return selectedTextColor
    }

    private func selectedTintColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedTintColor = segmentDescriptor.selectedTintColor {
                return selectedTintColor
            }

            return selectedTintColor
    }

    private func unSelectedTextColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedTextColor = segmentDescriptor.unSelectedTextColor {
                return unSelectedTextColor
            }

            return unSelectedTextColor
    }

    private func unSelectedTintColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedTintColor = segmentDescriptor.unSelectedTintColor {
                return unSelectedTintColor
            }

            return unSelectedTintColor
    }

    private func selectorColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectorColor = segmentDescriptor.selectorColor {
                return selectorColor
            }

            return selectorColor
    }

    private func selectedFont(forIndexPath indexPath: SOXIndexPath)
        -> UIFont {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedFont = segmentDescriptor.selectedFont {
                return selectedFont
            }

            return selectedFont
    }

    private func unSelectedFont(forIndexPath indexPath: SOXIndexPath)
        -> UIFont {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedFont = segmentDescriptor.unSelectedFont {
                return unSelectedFont
            }

            return unSelectedFont
    }

}

//MARK: - Action Methods
extension SOXSegmentControl {

    @objc
    private func buttonTapped(_ sender: SOXSegment) {

        selectedSegmentIndex = sender.tag //TODO: TODO remove if didSet selectedSegmentPath changes ~Index
        selectedSegmentPath = sender.indexPath
        print("\(#function): selectedSegmentIndex: \(selectedSegmentIndex)")

        onValueChanged?(selectedSegmentIndex)
        sendActions(for: .valueChanged)
    }

}


//MARK: -
//MARK: - SOXButton
open class SOXSegment: UIButton {

    //MARK: Properties
    var indexPath: SOXIndexPath
    var segmentDescriptor: SOXSegmentDescriptor

    //MARK: Init Methods
    required public init(indexPath: SOXIndexPath, segmentDescriptor: SOXSegmentDescriptor) {
        self.indexPath = indexPath
        self.segmentDescriptor = segmentDescriptor

        super.init(frame: .zero)
    }

    required public init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: Instance Methods
    fileprivate func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {

        guard let imageView = currentImage,
            let titleLabel = titleLabel?.text
            else { return }

        let sign: CGFloat = imageOnTop ? 1 : -1
        titleEdgeInsets = UIEdgeInsets(top: sign * (imageView.size.height + gap),
                                       left: -imageView.size.width,
                                       bottom: 0,
                                       right: 0);

        let titleSize = titleLabel.size(withAttributes:
            [NSAttributedString.Key.font: self.titleLabel!.font!])

        //TODO: TODO get 'right' correct; 200420, ph
        imageEdgeInsets = UIEdgeInsets(top: sign * -(titleSize.height + gap),
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width - gap)
    }

}


//MARK: -
//MARK: - SOXIndexPath
public struct SOXIndexPath: Equatable {

    //MARK: Properties
    var row: Int = 0
    var column: Int = 0

    //MARK: Init
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

}


//MARK: -
//MARK: - SOXSegmentDescriptor
public struct SOXSegmentDescriptor: Equatable {

    //MARK: Properties
    public var title: String?
    public var imageName: String?

    public var selectedTextColor: UIColor?
    public var selectedTintColor: UIColor?
    public var unSelectedTextColor: UIColor?
    public var unSelectedTintColor: UIColor?
    public var selectorColor: UIColor?

    public var selectedFont : UIFont?
    public var unSelectedFont : UIFont?

    public var textPosition: SOXSegmentControl.TextPosition?
    public var selectorType: SOXSegmentControl.SelectorType?
    public var selectorStyle: SOXSegmentControl.SelectorStyle?


    //MARK: Equatable
    private let uuid = UUID()

    public static func == (lhs: SOXSegmentDescriptor, rhs: SOXSegmentDescriptor)
        -> Bool {
            return lhs.uuid == rhs.uuid
    }


    //MARK: Convenient Inits
    //TODO: TODO needs implementation; 280420, ph
    public init(title: String? = nil,
                selectedTextColor: UIColor? = nil,
                unSelectedTextColor: UIColor? = nil,
                selectedFont : UIFont? = nil,
                unSelectedFont : UIFont? = nil,

                imageName: String? = nil,
                selectedImageColor: UIColor? = nil,
                unSelectedImageColor: UIColor? = nil,

                segmentType: SOXSegmentControl.TextPosition? = nil,

                selectorColor: UIColor? = nil,
                selectorType: SOXSegmentControl.SelectorType? = nil,
                selectorStyle: SOXSegmentControl.SelectorStyle? = nil) {
        self.title = title
        self.selectedTextColor = selectedTextColor
        self.unSelectedTextColor = unSelectedTextColor
        self.selectedFont = selectedFont
        self.unSelectedFont = unSelectedFont

        self.imageName = imageName
        self.selectedTintColor = selectedImageColor
        self.unSelectedTintColor = unSelectedImageColor

        //self.segmentType = segmentType
        self.selectorColor = selectorColor
        self.selectorType = selectorType
        self.selectorStyle = selectorStyle

    }


    public init(title: String? = nil,
                imageName: String? = nil,
                color: UIColor? = nil,
                selectedColor: UIColor? = nil,
                unSelectedColor: UIColor? = nil,
                selectorColor: UIColor? = nil,
                selectorType:  SOXSegmentControl.SelectorType? = nil) {

        self.title = title
        self.imageName = imageName

        self.selectorType = selectorType

        if let allColors = color {
            self.selectedTextColor = allColors
            self.selectedTintColor = allColors
            self.selectorColor = allColors
            self.unSelectedTextColor = allColors
            self.unSelectedTintColor = allColors
        }
        else {
            self.selectedTextColor = selectedColor
            self.selectedTintColor = selectedColor
            self.selectorColor = selectorColor

            self.unSelectedTextColor = unSelectedColor
            self.unSelectedTintColor = unSelectedColor
        }
    }

}
