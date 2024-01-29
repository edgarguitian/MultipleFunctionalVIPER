//
//  NoteInteractor.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NoteInteractor: GetNotesInteractable {
    private let collection = Constants.databaseFirestoreName

    func getNotes() async -> Result<[Note], Error> {
        var notes = [Note]()

        do {
            let querySnapshot = try await Firestore.firestore().collection(collection).getDocuments()

            for document in querySnapshot.documents {
                let data = document.data()
                let id = document.documentID
                guard let title = data["titulo"] as? String,
                      let description = data["descripcion"] as? String else {
                    return .failure(NSError(domain: "YourDomain", code: -1, userInfo: nil))
                }

                let note = Note(id: id, titulo: title, descripcion: description)
                notes.append(note)
            }

            return .success(notes)
        } catch {
            return .failure(error)
        }
    }

}

extension NoteInteractor: CreateNoteInteractable {
    func createNote(title: String, description: String) async -> Result<Note, Error> {
        do {
            let note = Note(titulo: title, descripcion: description)
            _ = try Firestore.firestore().collection(Constants.databaseFirestoreName).addDocument(from: note)
            return .success(note)
        } catch {
            return .failure(error)
        }
    }

}

extension NoteInteractor: DeleteNoteInteractable {
    func deleteNote(note: Note) async -> Result<Bool, Error> {
        guard let documentId = note.id else {
            return .failure(NSError(domain: "YourDomain", code: -1, userInfo: nil))
        }
        do {
            try await Firestore.firestore().collection(Constants.databaseFirestoreName).document(documentId).delete()
            return .success(true)
        } catch {
            return .success(false)
        }
    }

}
