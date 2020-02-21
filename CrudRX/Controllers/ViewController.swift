//
//  ViewController.swift
//  CrudRX
//
//  Created by Nina Dominique Thomé Bernardo - NBE on 18/02/20.
//  Copyright © 2020 Nina Dominique Thomé Bernardo - NBE. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var viewCad: UIView!
    @IBOutlet weak var trainerTextField: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemonFavoriteTextField: UITextField!
    let disposeBag = DisposeBag()
    let viewModel = PokemonViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewCad.layer.cornerRadius = 18
        trainerTextField.layer.cornerRadius = 18
           
        trainerTextField.layer.masksToBounds = true
        pokemonFavoriteTextField.layer.cornerRadius = 18
           
        pokemonFavoriteTextField.layer.masksToBounds = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pokebola.jpg")!)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .systemRed
        
        viewModel.getTypes()
        viewModel.types.map{ $0 }.drive(picker.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        picker.rx.itemSelected.subscribe(onNext: { (row, comp) in
            self.pokemonFavoriteTextField.text = self.viewModel.didRequestPokemonType(index: row)
            }).disposed(by: disposeBag)
        
        pokemonFavoriteTextField.inputView = picker
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        guard let name = trainerTextField.text, !name.isEmpty, let type = pokemonFavoriteTextField.text, !type.isEmpty else {
            let alert = UIAlertController(title: "Preencha os campos aê carai!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok, vou preencher czao.", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        viewModel.createDocument(name: trainerTextField.text ?? "",
                                 pokemonType: pokemonFavoriteTextField.text ?? "")
        let alert = UIAlertController(title: "Cadastro efetuado com sucesso!", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)

        self.trainerTextField.text = ""
        self.pokemonFavoriteTextField.text = ""
    }
    
    func bind() {
        viewModel.getTrainers()
        viewModel.trainers.drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { item, model, cell in
            cell.textLabel?.text = "Treinador: \(model.name) | Tipo: \(model.pokemonType)"
        }.disposed(by: disposeBag)
        
       
    }
    
    
}

