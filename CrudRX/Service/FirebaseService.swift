//
//  FirebaseService.swift
//  CrudRX
//
//  Created by Nina Dominique Thomé Bernardo - NBE on 18/02/20.
//  Copyright © 2020 Nina Dominique Thomé Bernardo - NBE. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
class FirebaseService {
    
    let db = Firestore.firestore()
    
    func getCollection() {
        
        db.collection("trainers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func listenDocument(collection: String) -> Observable<[[String:Any]]>{
        return Observable.create { (observer) in
            self.db.collection(collection)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        observer.onNext([])
                        return
                    }
                    observer.onNext(document.documents.map { $0.data() })
            }
            return Disposables.create()
        }
    }
    
    
    
    func documentID(name: String, pokemonType: String) {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("trainers").addDocument(data: [
            "name": name,
            "pokemonType": pokemonType
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }    
}





