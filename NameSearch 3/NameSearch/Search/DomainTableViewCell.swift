//
//  DomainTableViewCell.swift
//  NameSearch
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import UIKit

class DomainTableViewCell: UITableViewCell {

    static let reusedID = "\(DomainTableViewCell.self)"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: DomainTableViewCell.reusedID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
