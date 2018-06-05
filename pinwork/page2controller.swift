//
//  page2controller.swift
//  pinwork
//
//  Created by Pouyan on 5/28/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class page2controller: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var LoginScrollView: UIScrollView!
    @IBOutlet weak var textview: UITextView?
    @IBOutlet weak var featurePageControl: UIPageControl!
    @IBOutlet weak var firstOrderUIButton: UIButton!
    
    let feature1 = ["title":"حرفه‌ای‌های قابل اعتماد","description":"حرفه‌ای‌های فعال در سیستم پین ورک، تست‌های اخلاقی، امنیتی و حرفه‌ای را گذرانده‌‌اند تا صلاحیت همکاری با مجموعه را پیدا کنند.","image":"pro_trusted.png"]
    let feature2 = ["title":"حرفه‌ای‌های آموزش‌دیده","description":"حرفه‌ای های فعال در سیستم پین ورک، دوره‌های آموزشی بسیاری را گذرانده‌اند تا بهترین خدمات را به شما بدهند.","image":"pro_trained.png"]
    let feature3 = ["title":"سفارش آسان و شفافی‌ قیمت","description":"در کمتر از یک دقیقه می‌توانید سفارش خود را ثبت کنید تا کارشناسان پین ورک در سریع‌ترین زمان ممکن، بهترین حرفه‌ای را به شما اختصاص دهند.","image":"calculator.png"]
    let feature4 = ["title":"پشتیبانی و پیگیری","description":"کارشناسان پین ورک در تمامی مراحل در خدمت شما هستند تا شما با خیالی آسوده از نظافت منزل یا محل کار خود لذت ببرید.","image":"customer_service_icon.png"]

    var featureArray = [Dictionary<String,String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LoginScrollView.delegate = self
        featureArray = [feature1,feature2,feature3,feature4]
        featurePageControl.numberOfPages=featureArray.count
        LoginScrollView.isPagingEnabled = true
        LoginScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 230)
        LoginScrollView.showsHorizontalScrollIndicator = false
        LoginScrollView.showsVerticalScrollIndicator = false
        loadFeatures()
    }
    func loadFeatures(){
        for (index, feature) in featureArray.enumerated(){
            if  let featureView = Bundle.main.loadNibNamed("FirstScrollView", owner: self, options: nil)?.first as? FirstScrollView{
                featureView.featureImageView.image = UIImage(named: feature["image"]!)
                featureView.titleUILabel.text = feature["title"]
                featureView.descriptionUILabel.text = feature["description"]
                LoginScrollView.addSubview(featureView)
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat( index) * self.view.bounds.size.width
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
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
