//
//  CustomCellBanner.swift
//  AssessmentAPP
//
//  Created by 10362 on 2024/2/6.
//

import UIKit
import SnapKit

class CustomCellBanner: UITableViewCell {
    
    var bgView = UIView()
    var imgBanner = UIImageView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage){
        self.imgBanner.image = image
    }
    
    private func setupCell() {
        contentView.addSubview(bgView)
        bgView.addSubview(imgBanner)
        imgBanner.contentMode = .scaleAspectFit
        bgView.backgroundColor = UIColor.black
        contentView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        imgBanner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
