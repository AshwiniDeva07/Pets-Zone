//
//  HomeViewController.swift
//  Pets Zone
//
//  Created by apple on 01/05/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import  Realm
import RealmSwift
import  CoreLocation
import  MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var locationTitle: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var petsMainView: UIView!
    @IBOutlet var searchTextfield: UITextField!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var petsListTableView: UITableView!
    
    var selectedCell = 0
    
    var homeVM = HomeViewModel()
    var petDetailList:CategoryModelClass?
    var petList:CategoryList?
    var searchPetList:[PetList?] = []
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var isSearch = Bool()
    
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        searchTextfield.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
            getAddressFromLatLon(pdblLatitude: "\(currentLocation?.coordinate.latitude ?? 0)", withLongitude: "\(currentLocation?.coordinate.longitude ?? 0)")
        }
        
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setupHomeView()
    }
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
        if DBManager.sharedInstance.getDataFromDB().count <= 0 {
            petDetailList = homeVM.readJsonFile()
            print("petDetailList",petDetailList ?? petDetailList.self!)
            DBManager.sharedInstance.addData(object: petDetailList!)
            petList = petDetailList?.categoriesList[selectedCell]
            categoryCollectionView.reloadData()
            petsListTableView.reloadData()
        }else{
            petDetailList = DBManager.sharedInstance.getDataFromDB()[0] as CategoryModelClass
            print("RealmData",petDetailList!)
            petList = petDetailList?.categoriesList[selectedCell]
            categoryCollectionView.reloadData()
            petsListTableView.reloadData()
        }
    }
    
    //MARK:- viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- getAddressFromLatLon
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil {
                    
                    let pm = placemarks!
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country ?? "")
                        print(pm.locality ?? "")
                        print(pm.subLocality ?? "")
                        print(pm.thoroughfare ?? "")
                        print(pm.postalCode ?? "")
                        print(pm.subThoroughfare ?? "")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        self.addressLabel.text = addressString
                        
                        
                        print(addressString)
                    }
                }
        })
        
    }
    
    //MARK:- setupHomeView
    func setupHomeView() {
        //Registering Xib for tableview
        let petsListNib = UINib.init(nibName: "PetsListTableViewCell", bundle: nil)
        petsListTableView.register(petsListNib, forCellReuseIdentifier: "PetsListTableViewCell")
        
        
        //Registering Xib for collectionview
        let categoryNib = UINib.init(nibName: "PetsCategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: "PetsCategoryCollectionViewCell")
        
        //collectionview layout
        categoryCollectionView.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 80, height: 120)
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        
        //tableview properties
        petsListTableView.separatorStyle = .none
        petsListTableView.backgroundColor = .clear
        
        //view properties
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.contentMode = .scaleAspectFit
        
        profileImageView.image = UIImage(named: "Profile")
        profileImageView.layer.cornerRadius = 25
        profileImageView.contentMode = .scaleToFill
        
        locationTitle.text = "Location"
        locationTitle.setCenterlabelProp(font: 15)
        
        
        addressLabel.setCenterlabelProp(font: 18)
        
        petsMainView.roundTop()
        petsMainView.backgroundColor =  #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        //E8E8E8
        
        searchTextfield.placeholder = "Search Pet to adopt"
        searchTextfield.backgroundColor = .white
        searchTextfield.text = ""
        searchTextfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchTextfield.font = UIFont.boldSystemFont(ofSize: 14)
        searchTextfield.layer.cornerRadius = 15
        searchTextfield.createImagePadView(searchTextfield)
        
        categoryCollectionView.backgroundColor = .clear
    }
    
    
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? searchPetList.count : petList?.petList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == petsListTableView {
            guard let cell = petsListTableView.dequeueReusableCell(withIdentifier: "PetsListTableViewCell") as? PetsListTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.petsListMainView.backgroundColor = .clear
            
            if indexPath.item%2 == 0 {
                cell.petsPhotoView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.8274509804, blue: 0.8352941176, alpha: 1)
            }else{
                cell.petsPhotoView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.8274509804, blue: 0.6784313725, alpha: 1)
            }
            cell.petsPhotoView.layer.cornerRadius = 8
            
            cell.petImage.image = UIImage(named: "petImage")
            switch  isSearch ? searchPetList[indexPath.row]?.id : petList?.petList[indexPath.row].id{
            case "0":
                cell.petImage.image = UIImage(named: "dog\(indexPath.row)")
            case "1":
                cell.petImage.image = UIImage(named: "cat\(indexPath.row)")
            case "2":
                cell.petImage.image = UIImage(named: "parrot\(indexPath.row)")
            case "3":
                cell.petImage.image = UIImage(named: "rabbit\(indexPath.row)")
            case "4":
                cell.petImage.image = UIImage(named: "fish\(indexPath.row)")
            default:
                cell.petImage.image = UIImage(named: "dog\(indexPath.row)")
            }
            cell.petImage.contentMode = .scaleToFill
            cell.petImage.backgroundColor = .clear
            cell.petImage.isOpaque = false
            
            cell.petsDetailView.backgroundColor = .white
            cell.petsDetailView.roundRight()
            
            cell.petNameLabel.text = isSearch ? searchPetList[indexPath.row]?.pet_name : petList?.petList[indexPath.row].pet_name
            cell.petNameLabel.setleftlabelProp(font: 17, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
            
            cell.petTypeName.text = isSearch ? searchPetList[indexPath.row]?.breed_type : petList?.petList[indexPath.row].breed_type
            cell.petTypeName.setleftlabelProp(font: 15, color: #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1))
            
            cell.petYearLabel.text = isSearch ? searchPetList[indexPath.row]?.age : petList?.petList[indexPath.row].age
            cell.petYearLabel.setleftlabelProp(font: 13, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            
            cell.petDistanceLabel.text = isSearch ? searchPetList[indexPath.row]?.distance : petList?.petList[indexPath.row].distance
            cell.petDistanceLabel.setleftlabelProp(font: 15, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            
            cell.pinButton.setImage(UIImage(named: "markpin"), for: .normal)
            
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextfield.resignFirstResponder()
        let deatailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetsDetailViewController") as? PetsDetailViewController
        deatailVC?.petDetail = petList?.petList[indexPath.row]
        self.navigationController?.pushViewController(deatailVC!, animated: true)
        
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        searchTextfield.resignFirstResponder()
    }
}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK:- numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK:- numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petDetailList?.categoriesList.count ?? 0
        
    }
    
    //MARK:- cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            
            guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "PetsCategoryCollectionViewCell", for: indexPath) as? PetsCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            let categoryList = petDetailList?.categoriesList[indexPath.row]
            
            
            if selectedCell == indexPath.item{
                cell.petCategoryView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
                cell.petsCategoryImageView.tintColor = .white
            }else{
                cell.petCategoryView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.petsCategoryImageView.tintColor = .black
            }
            cell.petCategoryView.layer.cornerRadius = 5
            cell.petCategoryView.addShadow(shadowColor: #colorLiteral(red: 0.1882352941, green: 0.3764705882, blue: 0.3764705882, alpha: 1), shadowOffset: CGSize(width: 1.0, height: 1.0), shadowOpacity: 0.4, shadowRadius: 3.0)
            
            cell.petsCategoryImageView.layer.cornerRadius = 5
            cell.petsCategoryImageView.backgroundColor = .clear
            
            switch  categoryList?.url{
            case "dog":
                cell.petsCategoryImageView.image = UIImage(named: "petcategory")
            case "cat":
                cell.petsCategoryImageView.image = UIImage(named: "cat")
            case "bunnies":
                cell.petsCategoryImageView.image = UIImage(named: "bunnies")
            case "fish":
                cell.petsCategoryImageView.image = UIImage(named: "fish")
            case "parrot":
                cell.petsCategoryImageView.image = UIImage(named: "parrot")
            default:
                cell.petsCategoryImageView.image = UIImage(named: "petcategory")
            }
            
            let tintableImage = cell.petsCategoryImageView.image?.withRenderingMode(.alwaysTemplate)
            cell.petsCategoryImageView.image = tintableImage
            
            cell.petsCategoryName.text = categoryList?.name
            cell.petsCategoryName.setCenterlabelProp(font: 14)
            
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        petList = petDetailList?.categoriesList[indexPath.item]
        collectionView.reloadData()
        petsListTableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextfield.resignFirstResponder()
    }
    
    
}

//MARK:- UITextFieldDelegate
extension HomeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchTextfield.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        let enteredString = (textField.text! as NSString).replacingCharacters(in: range, with:string)
        if newLength > 1  && newLength <= 50 {
            
            let petdata = DBManager.sharedInstance.filterData(searchText: "\(enteredString)")
            searchPetList = Array(petdata)
            print(searchPetList)
            isSearch = true
            //petList?.petList = petData
            petsListTableView.reloadData()
        }else{
            searchPetList = []
            isSearch = false
            petList = petDetailList?.categoriesList[selectedCell]
            petsListTableView.reloadData()
        }
        
        return true
    }
    
    
}
