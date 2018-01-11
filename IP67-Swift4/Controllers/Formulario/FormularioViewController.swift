//
//  ViewController.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioViewController: UIViewController {

    private var dao = ContatoDao.shared
    private var isEditingMode = false
    
    
    
    var delegate: ContatoDelegate?
    var contato: Contato?
    
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var enderecoTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackCoordenadas: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupImageTap()
        
        guard let contato = contato else {
            self.contato = dao.contatoManaged()
            return
        }
        
        isEditingMode = true
        
        navigationItem.title = "Detalhes"
        
        tabBarController?.tabBar.isHidden = true
        
        fillForm(from: contato)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save(_:)))
        navigationItem.rightBarButtonItem = editButton
    }

    
    @IBAction func save(_ sender: UIBarButtonItem) {
        fillContatc()
        
        if isEditingMode {
            delegate?.update(contato: contato!)
        }else {
            delegate?.save(contato: contato!)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getCoordinate(_ sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        
        guard let endereco = enderecoTextField.text else {
            return
        }        
        
        stackCoordenadas.removeArrangedSubview(sender)
        stackCoordenadas.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        geoCoder.geocodeAddressString(endereco) { (placeMarks, error) in
            
            defer {
                self.activityIndicator.stopAnimating()
                self.stackCoordenadas.removeArrangedSubview(self.activityIndicator)
                self.stackCoordenadas.addArrangedSubview(sender)
            }
            
            guard error == nil else {
                let controller = UIAlertController(title: "Ops", message: "Ocorreu um problema ao tentar localizar as coordenadas para o endereço: \(endereco)", preferredStyle: .alert)
                
                
                controller.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: nil))
                
                self.present(controller, animated: true, completion: nil)
                
                return
            }
            
            guard let placeMark = placeMarks?[0] else {
                return
            }
            
            let coordinate = placeMark.location?.coordinate
            
            self.latitudeTextField.text = coordinate?.latitude.description
            self.longitudeTextField.text = coordinate?.longitude.description
            
            
        }
        
    }
    
    
    private func setupImageTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(escolheImagem(sender:)))
        
        imagemPerfil.addGestureRecognizer(tap)
    }
    
   
    
    @objc func escolheImagem(sender tap: UITapGestureRecognizer) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: "Escolha a imagem de perfil", message: contato?.nome, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.getPhoto(by: .camera)
            }))
            
            alert.addAction(UIAlertAction(title: "Biblioteca", style: .default, handler: { (action) in
                self.getPhoto(by: .photoLibrary)
            }))
            
            present(alert, animated: true, completion: nil)
            
        }else {
            getPhoto(by: .photoLibrary)
        }
        
        
    }
    
    
    private func getPhoto(by sourceType: UIImagePickerControllerSourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        present(picker, animated: true, completion: nil)
    }
    
    private func fillForm(from contato:Contato){
        imagemPerfil.image = contato.foto
        nomeTextField.text = contato.nome
        enderecoTextField.text = contato.endereco
        telefoneTextField.text = contato.telefone
        siteTextField.text = contato.site
        
        latitudeTextField.text = contato.latitude?.description
        longitudeTextField.text = contato.longitude?.description
    }
    
    
    private func fillContatc() {
        contato?.foto = imagemPerfil.image
        contato?.nome = nomeTextField.text
        contato?.endereco = enderecoTextField.text
        contato?.telefone = telefoneTextField.text
        contato?.site = siteTextField.text
        
        contato?.latitude = Double(latitudeTextField.text!)! as NSNumber
        contato?.longitude = Double(longitudeTextField.text!)! as NSNumber
        
        dao.add(contato: contato!)
    }
}


extension FormularioViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage  {
            imagemPerfil.image = image
        }        
        
        picker.dismiss(animated: true, completion: nil)
    }
}
