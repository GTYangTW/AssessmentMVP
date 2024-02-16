//
//  TableViewCell.swift
//  AssessmentAPP
//
//  Created by 10362 on 2024/2/6.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    
    var bgView = UIView()
    var imgHead = UIImageView()
    var lbName = UILabel()
    var lbPosition = UILabel()
    var lbExpert = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, name: String, position: String, exps: [String]){
        self.imgHead.image = image
        self.lbName.text = name
        self.lbPosition.text = position
        let expJoined = exps.joined(separator: ", ")
        self.lbExpert.text = expJoined
    }
    
    
    private func setupCell() {
        contentView.addSubview(bgView)
        bgView.addSubview(imgHead)
        bgView.addSubview(lbName)
        bgView.addSubview(lbPosition)
        bgView.addSubview(lbExpert)
        lbName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbExpert.numberOfLines = 0
        lbName.textColor = UIColor.white
        lbPosition.textColor = UIColor.white
        lbExpert.textColor = UIColor.white
        contentView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        imgHead.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.top.left.equalToSuperview().offset(10)
        }
        lbName.snp.makeConstraints { make in
            make.left.equalTo(imgHead.snp.right).offset(10)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        lbPosition.snp.makeConstraints { make in
            make.left.equalTo(imgHead.snp.right).offset(10)
            make.top.equalTo(lbName.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.right.equalToSuperview().offset(-10)
//            make.height.equalToSuperview().multipliedBy(0.2)
        }
        lbExpert.snp.makeConstraints { make in
            make.left.equalTo(imgHead.snp.right).offset(10)
            make.top.equalTo(lbPosition.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.rightMargin.equalTo(10)
//            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //當畫面加載完畢後才能計算尺寸,因此需要寫在layoutSubviews
        let headWidthHalf = imgHead.frame.width / 2
        imgHead.layer.cornerRadius = CGFloat(headWidthHalf)
        imgHead.clipsToBounds = true
    }
}
