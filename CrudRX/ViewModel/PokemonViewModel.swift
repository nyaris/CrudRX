//
//  PokemonViewModel.swift
//  CrudRX
//
//  Created by Nina Dominique Thomé Bernardo - NBE on 20/02/20.
//  Copyright © 2020 Nina Dominique Thomé Bernardo - NBE. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PokemonViewModelContract {
    func getTrainers()
    func getTypes()
    func didRequestPokemonType(index: Int) -> String
    func createDocument(name:String, pokemonType:String)
    var trainers: Driver<[Trainers]> { get }
    var types: Driver<[String]> { get }
}

class PokemonViewModel: PokemonViewModelContract {
    
    private let TRAINERS_COLLECTION_KEY = "trainers"
    private let TYPES_COLLECTION_KEY = "pokemonTypes"
    
    private let trainersRelay: BehaviorRelay<[Trainers]> = BehaviorRelay(value: [])
    private let typesRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var trainers: Driver<[Trainers]> { return trainersRelay.asDriver() }
    var types: Driver<[String]> { return typesRelay.asDriver() }
    
    
    let service = FirebaseService()
    let disposeBag = DisposeBag()
    
    public func getTrainers() {
        service.listenDocument(collection: TRAINERS_COLLECTION_KEY).subscribe(onNext: { (trainers) in
            var listTrainer:[Trainers] = []
            trainers.forEach { (dict) in
                listTrainer.append(Trainers(name: dict["name"] as? String ?? "",
                                            pokemonType: dict["pokemonType"] as? String ?? ""))
            }
            self.trainersRelay.accept(listTrainer)
        }).disposed(by: disposeBag)
    }
    
    func getTypes() {
        service.listenDocument(collection: TYPES_COLLECTION_KEY).subscribe(onNext: { (types) in
            let poke = types[0]["types"] as! [String]
            self.typesRelay.accept(poke)
        }).disposed(by: disposeBag)
    }
    
    func createDocument(name: String, pokemonType: String) {
        service.documentID(name: name, pokemonType: pokemonType)
     }
    
    func didRequestPokemonType(index: Int) -> String {
        return typesRelay.value[index]
    }
}
