//
//  NameTableViewCell.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import UIKit

struct SampleNameCellModel {
    var sample: SampleObject
    var name: String {
        get {
            if sample.isValidated() {
                return sample.name ?? " "
            }
            return " "
        }
    }
    var id: Int? {
        get {
            if sample.isValidated() {
                return sample.id
            }
            return nil
        }
    }
}

class NameTableViewCell: TableViewCell {
    let nameLbl = UILabel()
    
    override func setupView() {
        super.setupView()
        selectionStyle = .none
        nameLbl.numberOfLines = 0
        nameLbl.textLayout(font: .content, color: .black)
        contentView.addSubviewForLayout(nameLbl)
        nameLbl.setContentHuggingPriority(.init(1000), for: .vertical)
        nameLbl.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        NSLayoutConstraint.activate([nameLbl.alignLeading(to: contentView, space: DSSpacing.margin.rawValue),
                                     nameLbl.alignTop(to: contentView, space: DSSpacing.margin.rawValue),
                                     contentView.alignTrailing(to: nameLbl, space: DSSpacing.margin.rawValue),
                                     contentView.alignBottom(to: nameLbl, space: DSSpacing.margin.rawValue)])
    }
    
    override func didSetup() {
        super.didSetup()
        if let viewModel = viewModel as? SampleNameCellModel {
            distributeSampleNameCellModel(viewModel: viewModel)
        }
        // if you support more than one type of model, add below this comment
    }
    
    func distributeSampleNameCellModel(viewModel: SampleNameCellModel) {
        nameLbl.text = viewModel.name
    }
    
    override class func getCellEstimatedHeight(viewModel: Any?) -> CGFloat {
        return 51
    }
    
    
}
