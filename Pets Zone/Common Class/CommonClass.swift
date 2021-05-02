

import Foundation
import  UIKit

//MARK:- Anchor Helpers
struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

//MARK:- UILabel
extension UILabel{
    
    //setDarkText
    func setCenterlabelProp(font: Int) {
        self.textColor = UIColor.gray
        self.font = UIFont.boldSystemFont(ofSize: CGFloat(font))
        self.backgroundColor = UIColor.clear
        self.textAlignment = .center
    }
    
    func setleftlabelProp(font: Int,color: UIColor) {
        self.textColor = color //#colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1)
        self.font = UIFont.boldSystemFont(ofSize: CGFloat(font))
        self.backgroundColor = UIColor.clear
        self.textAlignment = .left
    }
    
    
}

extension UIView {
    
    @discardableResult
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func roundTop(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundLeft(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundRight(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottom(radius:CGFloat = 10){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addShadow(shadowColor: CGColor ,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}
extension UITextField{
    
    func createImagePadView(_ txtField:UITextField)->Void
    {
        let width:CGFloat = 40
        let leftView = UIView.init(frame: CGRect(x: 0, y: 3.5, width: width,height: 40))
        let padImageView = UIImageView.init()
        
        let rightView = UIView.init(frame: CGRect(x: 0, y: 3.5, width: width,height: 40))
        let rightImageView = UIImageView.init()
        
        txtField.rightViewMode =  UITextField.ViewMode.always
        txtField.leftViewMode = UITextField.ViewMode.always
        txtField.leftView = leftView
        txtField.rightView = rightView
        
        padImageView.image =  UIImage(named:"search")
        padImageView.frame = CGRect(x: 10, y: 8, width: 25, height: 25)
        leftView.addSubview(padImageView)
        
        rightImageView.image =  UIImage(named:"searcharrow")
        rightImageView.frame = CGRect(x: 5, y: 8, width: 25, height: 25)
        rightView.addSubview(rightImageView)
        
    }
}

//icon grey #B3B3B3
//text grey ACACAC
//backgroun grey #F6F6F6
//text blach #565656
//table back grn #C9D3D5
//org #EBD3AD
//#306060
