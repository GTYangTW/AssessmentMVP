//
//  ViewController.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/6.
//

import UIKit
import SnapKit

// MVP 中畫面是被動的，只有輸入數據、顯示、刷新功能。資料由 Presenter 推給畫面
// 只需要做好 Protocol 溝通
class MainView: UIViewController {
    let lbTitleRed = UILabel()
    let lbTitleWhite = UILabel()
    var tbMain = UITableView()
    let bgView = UIView()
    
    let cellIdBasic = "CustomCell"
    let cellIdBanner = "CustomCellBanner"
    
    let presenter = RedsoPresenter()
    //let presenterPL = RedsoPresenterDelegate
    var tbResult = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Table
        tbMain.delegate = self
        tbMain.dataSource = self
        tbMain.register(CustomCell.self, forCellReuseIdentifier: cellIdBasic)
        tbMain.register(CustomCellBanner.self, forCellReuseIdentifier: cellIdBanner)
        
        // Presenter
        // 委任，當外部呼叫這個方法時，需要呼叫方輸入一個要實作的協議（Protocol）父類型（2/2）
        // 實作委任，View有繼承protocol，因此self能放入，形成Delegation
        presenter.setViewDelegate(delegate: self)
        // 實作 Presenter 獲取數據方法
        presenter.getJSON()
        setupBasic()
    }
    
    func setupBasic() {
        view.addSubview(bgView)
        view.addSubview(lbTitleRed)
        view.addSubview(lbTitleWhite)
        bgView.backgroundColor = UIColor.black
        view.sendSubviewToBack(bgView)
        //view.addSubview(simulatorSegment)
        lbTitleRed.text = "Red"
        lbTitleWhite.text = "So"
        lbTitleRed.textColor = UIColor.red
        lbTitleWhite.textColor = UIColor.white
        lbTitleRed.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        lbTitleWhite.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.right.left.equalToSuperview()
        }
        lbTitleRed.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(view.snp.centerX)
        }
        lbTitleWhite.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(lbTitleRed.snp.right)
        }
//        simulatorSegment.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.width.equalToSuperview()
//            make.top.equalTo(lbTitleRed.snp.bottom)
//            make.centerX.equalToSuperview()
//        }
        setupTableView()
        
    }
    func setupTableView() {
        view.addSubview(tbMain)
        //activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        //activityIndicator.hidesWhenStopped = true
        //tbMain.addSubview(refreshControl)
        //tbMain.addSubview(activityIndicator)
        tbMain.backgroundColor = UIColor.white
//        tbMain.separatorColor = .white
        tbMain.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(self.lbTitleRed.snp.bottom).offset(10)
        }
//        activityIndicator.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//        }
//        tbMain.showsVerticalScrollIndicator = false
    }
    func urlShowsImage(url: URL, completion: @escaping (UIImage, CGFloat, CGFloat) -> Void) {
        let imageURL = url
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let data = data,
               let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    let imgWidth = img.size.width
                    let imgHeight = img.size.height
                    completion(img, imgWidth, imgHeight)
                }
            }
        }.resume()
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tbResult[indexPath.row]
        if data.type == "employee" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdBasic, for: indexPath) as? CustomCell else {
                fatalError("The tabelview could not dequeue a CustomCell in Viewcontroller.")
            }
            if let name = data.id,
               let position = data.position,
               let exps = data.expertise,
               let url = data.avatar{
                urlShowsImage(url: url) { img, _, _ in
                    cell.configure(with: img, name: name, position: position, exps: exps)
                }
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdBanner, for: indexPath) as? CustomCellBanner else {
            fatalError("The tabelview could not dequeue a CustomCell in Viewcontroller.")
        }
        if let url = data.url{
            urlShowsImage(url: url) { img, _, _ in
                cell.imgBanner.image = img
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tbResult[indexPath.row]
        if data.type == "banner" {
            return UITableView.automaticDimension
        }
        return 200
    }
}

// 委任，實作 Delegation 的方法。資料進來要如何處理
extension MainView: RedsoPresenterDelegate{
    func presentJSON(result: [Result]) {
        tbResult = result
        DispatchQueue.main.async {
            self.tbMain.reloadData()
        }
    }
}
