//
//  EventTableViewCell.swift
//  ProjSoftDesign
//
//  Created by Admin on 11/08/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let identifier = "EventTableViewCell"
    
    
    private let title: UILabel = {
       let title = UILabel()
        title.textColor = .white
        title.font = .systemFont(ofSize: 16, weight: .light)
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemTeal
        contentView.addSubview(title)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
    
    public func changeTitle(text: String) {
        title.text = text
    }
}
