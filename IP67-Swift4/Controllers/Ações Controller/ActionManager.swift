//
//  GerenciadorDeAções.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit

class ActionManager {
    
    
    private unowned let parentController: UIViewController
    
    init(showIn parentController: UIViewController) {
        self.parentController = parentController
    }
    
    func showActions(of contato: Contato) {
        
        let controller = UIAlertController(title: contato.nome, message: nil, preferredStyle: .actionSheet)
        
        
        controller.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
       
        controller.addAction(UIAlertAction(title: "Ligar", style: .default, handler: { (action) in
            self.call(contato)
        }))
        
        controller.addAction(UIAlertAction(title: "Exibir Site", style: .default, handler: { (action) in
            self.webPage(contato)
        }))
        
        controller.addAction(UIAlertAction(title: "Exibir no Mapa", style: .default, handler: { (action) in
            self.map(contato)
        }))
        
        controller.addAction(UIAlertAction(title: "Exibir Clima", style: .default, handler: { (action) in
            self.weather(contato)
        }))
        
        parentController.present(controller, animated: true, completion: nil)
    }
    
    
    private func weather(_ contato: Contato) {
        
        guard let climaController = parentController.storyboard?.instantiateViewController(withIdentifier: "clima") as? ClimaViewController else {
            return
        }
        
        climaController.contato = contato
        
        
        parentController.navigationController?.pushViewController(climaController, animated: true)
        
    }
    
    private func map(_ contato: Contato) {
        guard let endereco = contato.endereco else {
            return
        }
        
        guard let url = ("http://maps.google.com/maps?q=" + endereco).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        open(by: url)        
    }
    
    
    private func webPage(_ contato: Contato) {
        guard let url = contato.site else {
            return
        }
        
        if url.hasPrefix("http://") {
           open(by: url)
        }else {
            open(by: "http://\(url)")
        }
        
    }
    
    private func call(_ contato: Contato){
        
        
        guard let telefone = contato.telefone else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.open(by: "tel:\(telefone)")
        }else {
            
            let controller = UIAlertController(title: "Ops", message: "Seu aparelho não pode efetuar ligações", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: nil))
            parentController.present(controller, animated: true, completion: nil)
        }
        
    }
    
    
    private func open(by url:String) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}
