//
//  ListagemViewController.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit

class ListagemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    fileprivate let dao = ContatoDao.shared
    fileprivate var indexPathOfCurrentSelection: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapTableViewController()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let indexPath = indexPathOfCurrentSelection else {
            return
        }
        
        guard let _ = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(550)) { [unowned self] in
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.indexPathOfCurrentSelection = nil
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let formulario = segue.destination as? FormularioViewController else {
            return
        }
        
        formulario.delegate = self
        
    }
    
    
    
    private func setupTapTableViewController(){
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(touchCell(sender:)))
        
        tableView.addGestureRecognizer(tap)
    }
    
    
    @objc func touchCell(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let ponto = sender.location(in: tableView)
            
            guard let indexPath = tableView.indexPathForRow(at: ponto) else {
                return
            }
            
            guard let contato = dao.find(by: indexPath.row) else {
                return
            }
            
            ActionManager(showIn: self).showActions(of: contato)
            
        }
        
    }
}


extension ListagemViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dao.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contatoCell", for: indexPath)
        
        guard let contato = dao.find(by: indexPath.row) else {
            return cell
        }
        
        cell.textLabel?.text = contato.nome
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}

extension ListagemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let formulario = storyboard?.instantiateViewController(withIdentifier: "formulario") as? FormularioViewController else {
            return
        }
        
        guard let contato = dao.find(by: indexPath.row) else {
            return
        }
        
        formulario.contato = contato
        formulario.delegate = self
        
        
        navigationController?.pushViewController(formulario, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let contato = dao.find(by: indexPath.row) else {
                return
            }
                        
            dao.remove(contato: contato)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension ListagemViewController: ContatoDelegate {
    func save(contato: Contato) {
        indexPathOfCurrentSelection = getIndexPath(by: contato)
    }
    
    func update(contato: Contato) {
        indexPathOfCurrentSelection = getIndexPath(by: contato)
    }
    
    private func getIndexPath(by contato: Contato) -> IndexPath?{
        guard let index = dao.index(of: contato) else {
            return nil
        }
        
        return IndexPath(row: index, section: 0)
    }
}
