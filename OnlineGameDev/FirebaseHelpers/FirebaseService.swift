//
//  FirebaseService.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 02/07/2021.
//

import Firebase
import FirebaseFirestore


enum FCollectionReference: String {
    case Game
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
