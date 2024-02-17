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
    var tbResult = [Result]()
    
    let loadingControl = UIRefreshControl()
    var pageNumber = Int()
    var activityIndicator = UIActivityIndicatorView()
    
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
        presenter.getJSON(with: pageNumber)
        setupBasic()

    }
    
    func setupBasic() {
        view.addSubview(bgView)
        view.addSubview(lbTitleRed)
        view.addSubview(lbTitleWhite)
        bgView.backgroundColor = UIColor.black
        view.sendSubviewToBack(bgView)
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
        setupTableView()
        
    }
    func setupTableView() {
        view.addSubview(tbMain)
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        tbMain.addSubview(activityIndicator)
        tbMain.addSubview(loadingControl)
        tbMain.backgroundColor = UIColor.black
        tbMain.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(self.lbTitleRed.snp.bottom).offset(10)
        }
        loadingControl.addTarget(self, action: #selector(loadingData), for: .valueChanged)
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        tbMain.showsVerticalScrollIndicator = false
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
    @objc func loadingData(){
        // 停止 refreshControl 動畫
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.tbMain.reloadData()
            self.loadingControl.endRefreshing()
        }
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
extension MainView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let bgFrameHeight = bgView.frame.origin.y
        // 滑動動作要大，且畫面是往上時觸發
        guard scrollView.contentOffset.y > bgFrameHeight + 30 && scrollView.contentOffset.y > 0 else { return }
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -30 || self.pageNumber < 3{
                // View 如何驅動 Presenter 改變？
                self.pageNumber += 1
                // 刷新後畫面只保留新的頁面 ？
                self.presenter.getJSON(with: self.pageNumber)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
