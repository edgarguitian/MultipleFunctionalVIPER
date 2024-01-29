//
//  NoteInteractable.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation

protocol GetNotesInteractable {
    func getNotes() async -> Result<[Note], Error>
}

protocol CreateNoteInteractable {
    func createNote(title: String, description: String) async -> Result<Note, Error>
}

protocol DeleteNoteInteractable {
    func deleteNote(note: Note) async -> Result<Bool, Error>
}
