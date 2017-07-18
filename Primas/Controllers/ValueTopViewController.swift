//
//  ValueTopViewController.swift
//  Primas
//
//  Created by wang on 12/07/2017.
//  Copyright © 2017 wang. All rights reserved.
//

import UIKit

class ValueTopViewController: UIViewController {
    var valueList: [ValueTopModel] = []
    var valueView: ValueTopView = ValueTopView()
    var oldContentOffset = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.valueList = ValueTopModel.generateTestData()
        self.valueView.table.delegate = self
        self.valueView.table.dataSource = self
        self.valueView.headerBind()
        
        self.view.addSubview(valueView)
        self.view.backgroundColor = UIColor.white

        valueView.snp.makeConstraints {
            make in 
            make.edges.equalTo(self.view)
        }

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: primasFont(15)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "";
        self.navigationController?.navigationBar.backItem?.title = "";
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK -- UITableViewDataSource UITableViewDelegate

extension ValueTopViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ValueTopTableViewCell.registerIdentifier) as! ValueTopTableViewCell
        cell.bind(valueList[indexPath.row], indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ValueTableViewCell.rowHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta =  scrollView.contentOffset.y - oldContentOffset.y
        
        let topConstant = valueView.headerViewTopConstraint!.layoutConstraints[0].constant
        let topConstantAbs = 0 - topConstant
        
        if delta > 0 && topConstantAbs < CGFloat(125.0) && scrollView.contentOffset.y > 0 {
            
            let offsetDelta = topConstant - delta < -125.0 ? -125.0 : topConstant - delta
            
            valueView.headerViewTopConstraint!.update(offset: offsetDelta)
            scrollView.contentOffset.y -= delta
        }
        
        if delta < 0 && topConstantAbs > CGFloat(0.0) && scrollView.contentOffset.y < 0 {
            
            let offsetDelta = topConstant - delta >= 0 ? 0 : topConstant - delta
            
            valueView.headerViewTopConstraint!.update(offset: offsetDelta)
            scrollView.contentOffset.y -= delta
        }
        
        oldContentOffset = scrollView.contentOffset
    }
}
