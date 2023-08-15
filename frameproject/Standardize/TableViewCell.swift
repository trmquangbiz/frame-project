//
//  TableViewCell.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    public private(set) var viewModel: Any?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postSetupLayoutView()
    }
    
    /// Override this function to put layout view code here
    func setupView() {
    
    }
    
    /// Do post layout stuff, like add interaction or fixed localize string
    func postSetupLayoutView() {
        
    }

    func setup(viewModel: Any?) {
        self.viewModel = viewModel
        didSetup()
    }
    
    /// override this function for distribute data from view model to view
    func didSetup() {
        
    }
    
    class func cellIdentifier() -> String{
        return String.init(describing: self)
    }
    
    class func nibName() -> String {
        return String.init(describing: self)
    }
    
    class func getCellEstimatedHeight(viewModel: Any?) -> CGFloat {
        return 30
    }

}
