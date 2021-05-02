//
//  PetsDetailViewController.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class PetsDetailViewController: UIViewController {
    
    @IBOutlet var petsView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var fileSendBtn: UIButton!
    @IBOutlet var petsScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var petDetailView: UIView!
    @IBOutlet var petDetailSubView: UIView!
    @IBOutlet var petName: UILabel!
    @IBOutlet var petType: UILabel!
    @IBOutlet var pinImage: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var petsDescriptionView: UIView!
    @IBOutlet var petOwnerDetails: UIView!
    @IBOutlet var ownerImage: UIImageView!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var guardianType: UILabel!
    @IBOutlet var postedDate: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    
    @IBOutlet var selectionView: UIView!
    @IBOutlet var favouriteBtn: UIButton!
    @IBOutlet var adoptBtn: UIButton!
    
    var slides:[Slide] = []
    
    var petDetail: PetList?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.bringSubviewToFront(petDetailView)
        petDetailView.addSubview(petDetailSubView)
        petDetailSubView.anchor(top: petDetailView.topAnchor, leading: petDetailView.leadingAnchor, bottom: petDetailView.bottomAnchor, trailing: petDetailView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15), size: CGSize(width: 0, height: 0))
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = petDetail?.photoArray.count ?? 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        self.view.bringSubviewToFront(pageControl)
        petsScrollView.bringSubviewToFront(pageControl)
        
        self.view.bringSubviewToFront(backBtn)
        self.view.bringSubviewToFront(fileSendBtn)
        
        petsView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.8274509804, blue: 0.8352941176, alpha: 1)
        petsScrollView.backgroundColor = .clear
        
        petDetailView.backgroundColor = .white
        petDetailSubView.backgroundColor = .white
        petDetailView.layer.cornerRadius = 20
        petDetailSubView.layer.cornerRadius = 20
        petDetailView.addShadow(shadowColor: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
        
        petName.text = petDetail?.pet_name
        petName.setleftlabelProp(font: 17, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
        
        petType.text = petDetail?.breed_type
        petType.setleftlabelProp(font: 15, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
        
        yearLabel.text = petDetail?.age
        yearLabel.setleftlabelProp(font: 14, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
        yearLabel.textAlignment  = .right
        
        addressLabel.text = petDetail?.address
        addressLabel.setleftlabelProp(font: 14, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        pinImage.image = UIImage(named: "markpin")
        locationImage.image = UIImage(named: "location")
        
        
        petsDescriptionView.backgroundColor = .white
        petOwnerDetails.backgroundColor = .white
        
        ownerImage.image = UIImage(named: "Profile")
        ownerImage.layer.cornerRadius = 25
        
        ownerName.text = petDetail?.owner_name
        ownerName.setleftlabelProp(font: 15, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
        
        guardianType.text = petDetail?.owner_type
        guardianType.setleftlabelProp(font: 13, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        postedDate.text = petDetail?.post_date
        postedDate.setleftlabelProp(font: 13, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        notesLabel.text = petDetail?.notes
        notesLabel.setleftlabelProp(font: 13, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        
        selectionView.backgroundColor = #colorLiteral(red: 0.8961447719, green: 0.8961447719, blue: 0.8961447719, alpha: 1)
        selectionView.roundTop()
        
        favouriteBtn.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
        favouriteBtn.layer.cornerRadius = 8
        
        adoptBtn.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        adoptBtn.setTitle("Adoption", for: .normal)
        adoptBtn.setTitleColor(.white, for: .normal)
        adoptBtn.layer.cornerRadius = 8
        
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- goBack
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- createSlides
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "\(petDetail?.photoArray[0] ?? "dog1")")
        slide1.imageView.backgroundColor = .clear
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "\(petDetail?.photoArray[1] ?? "dog1")")
        slide2.imageView.backgroundColor = .clear
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "\(petDetail?.photoArray[2] ?? "dog1")")
        slide3.imageView.backgroundColor = .clear
        
        
        return [slide1, slide2, slide3]
    }
    
    //MARK:- setupSlideScrollView
    func setupSlideScrollView(slides : [Slide]) {
        petsScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        petsScrollView.contentSize = CGSize(width: petsView.frame.width * CGFloat(slides.count), height: petsView.frame.height)
        petsScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            petsScrollView.addSubview(slides[i])
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK:- PetsDetailViewController
extension PetsDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
    }
    
}
