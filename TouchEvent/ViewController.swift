//
//  ViewController.swift
//  TouchEvent
//
//  Created by Kanno Taichi on 2024/08/31.
//

import UIKit
import PhotosUI

class ViewController: UIViewController ,PHPickerViewControllerDelegate{
    @IBOutlet var backgroundImageView : UIImageView!
    
    var selectImageName: String="flower"
    
    var imageViewArray: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event : UIEvent?){
        let touch : UITouch = touches.first!
        let location : CGPoint = touch.location(in: view)
        //ImageViewをセットしてスタンプ画像と座標をセット
        let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 70, height: 70))
        imageView.image = UIImage(named:selectImageName)
        imageView.center=(CGPoint(x:location.x, y:location.y))
        
        //実際に画面に追加する
        view.addSubview(imageView)
        
        imageViewArray.append(imageView)
    }
    
    @IBAction func selectImage1(){
        selectImageName = "flower"
        
    }
    @IBAction func selectImage2(){
        selectImageName = "cloud"
    }
    @IBAction func selectImage3(){
        selectImageName = "heart"
    }
    @IBAction func selectImage4(){
        selectImageName = "star"
    }
    @IBAction func changeBackground(){
        var configration = PHPickerConfiguration()
        
        //選択できるアセットタイプを画像に設定
        let filter = PHPickerFilter.images
        configration.filter = filter
        let picker = PHPickerViewController(configuration: configration)
        
        //デリゲートを設定
        picker.delegate = self
            //ぴっかーを呼び出す
        present(picker, animated: true)
     
    }
    @IBAction func save(){
        UIGraphicsBeginImageContextWithOptions(backgroundImageView.frame.size,false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x:-backgroundImageView.frame.origin.x, y : -backgroundImageView.frame.origin.y)
        view.layer.render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
    @IBAction func undo(){
        if imageViewArray.isEmpty{return}
        //配列の末端を削除
        imageViewArray.last!.removeFromSuperview()
        //スタンプを表示させるimageView配列の末尾を削除
        imageViewArray.removeLast()
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results.first?.itemProvider
        //選択された画像を読み込む
        if let itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { image,error in DispatchQueue.main.async{
                    self.backgroundImageView.image = image as? UIImage
                }
            }
        }
        //ピッカーを閉じる
        dismiss(animated: true)
        
    }

}

