//
//  ViewController.swift
//  UIcollectionViewTest
//
//  Created by Дмитрий Подольский on 13.01.2021.
//

import UIKit

struct Group:Decodable {
    var status:String
    var result:Results
}

struct Results:Decodable {
    var title:String
    var actionTitle:String
    var selectedActionTitle:String
    var list:[ListSetup]
}

struct ListSetup:Decodable {
    var id:String
    var title:String
    var description:String?
    var icon:[String: String]
    var price:String
    var isSelected:Bool
}

class ViewController: UIViewController {
    let countCell = 1
    let offsetCell:CGFloat = 30.0
 
    var titleNav = ""
    var actionTitleButton = ""
    var selectedActionTitleButton = ""
    var titles = [String]()
    var descriptions = [String?]()
    var iconsJ = [String]()
    var prices = [String]()
    var isSelecteds = [Bool]()
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var button: UIButton!

    private func parsJSON() {
        let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { [self] (data, respons, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let resultJson = try JSONDecoder().decode(Group.self, from: data)
           
                self.titleNav = resultJson.result.title
                self.actionTitleButton = resultJson.result.actionTitle
                self.selectedActionTitleButton = resultJson.result.selectedActionTitle
                for i in 0 ..< resultJson.result.list.count {
                    let listTitle = [resultJson.result.list[i].title]
                    let listDescription = [resultJson.result.list[i].description]
                    let listIcon = [resultJson.result.list[i].icon["52x52"]!]
                    let listPrice = [resultJson.result.list[i].price]
                    let listIsSelected = [resultJson.result.list[i].isSelected]
                      
                    self.titles.append(contentsOf: listTitle)
                    self.descriptions.append(contentsOf: listDescription)
                    self.iconsJ.append(contentsOf: listIcon)
                    self.prices.append(contentsOf: listPrice)
                    self.isSelecteds.append(contentsOf: listIsSelected)
                }
                DispatchQueue.main.async{
                   self.collectionView.reloadData()}
                
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        parsJSON()
        }
    
    @IBAction func buttunAction(_ sender: UIButton) {
        for cell in collectionView!.visibleCells{
            let offerCell = cell as! ImageCollectionViewCell
            if !(offerCell.checkmark.isHidden){
                let alert = UIAlertController(
                    title: "Вы выбрали",
                    message: offerCell.label.text!,
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                break
            }
        }
 
        let alert = UIAlertController(
            title: "Вы не выбрали услугу",
            message: "Продолжить без изменений?",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    }


extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        let title = titles[indexPath.item]
        let description = descriptions[indexPath.item]
        let iconJ = iconsJ[indexPath.item]
        let price = prices[indexPath.item]
        
        titleOutlet.text = titleNav
        cell.label.text = title
        cell.labelDes.text = description
        cell.icon.image = UIImage(data: NSData(contentsOf: NSURL(string: iconJ )! as URL)! as Data)
        cell.price.text = price
        cell.checkmark.image = UIImage(named: "checkmark")
        cell.checkmark.isHidden = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameCV = collectionView.frame
        let widthCell =  frameCV.width - 30
        let hieghtCell = widthCell/2
        
        return CGSize(width: widthCell , height: hieghtCell)
     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
               cell.checkmark.isHidden = !(cell.checkmark.isHidden)
               if !(cell.checkmark.isHidden){
                   button?.setTitle(selectedActionTitleButton, for: .normal)
               }else{
                   button?.setTitle(actionTitleButton, for: .normal)
               }
           }
      }
    
func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                cell.checkmark.isHidden = true
                button?.setTitle(actionTitleButton, for: .normal)
            }
        }
}



