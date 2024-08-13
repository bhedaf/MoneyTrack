//
//  ExpensesTableViewCell.swift
//  MoneyTrack
//
//  Created by Default User on 4/15/24.
// Author: Freya Bheda

import UIKit

class ExpensesTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let amountLabel = UILabel()
    let dateLabel = UILabel()
    let noteLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        
        amountLabel.textAlignment = NSTextAlignment.left
        amountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textColor = UIColor.black
        
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        var f = CGRect(x: 10, y: 5, width: 460, height: 30)
        titleLabel.frame = f
        
        f = CGRect(x: 10, y: 25, width: 460, height: 20)
        amountLabel.frame = f
        
        f = CGRect(x: 10, y: 45, width: 460, height: 20)
        dateLabel.frame = f
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
