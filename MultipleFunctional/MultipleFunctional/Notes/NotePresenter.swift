//
//  NotePresenter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation

class NotePresenter: ObservableObject {
    private let getNotesInteractor: GetNotesInteractable
    private let createNoteInteractor: CreateNoteInteractable
    private let deleteNoteInteractor: DeleteNoteInteractable

    @Published var notes: [Note] = []
    @Published var showErrorMessageNote: String?
    @Published var showLoadingSpinner: Bool = true

    init(getNotesInteractor: GetNotesInteractable,
         createNoteInteractor: CreateNoteInteractable,
         deleteNoteInteractor: DeleteNoteInteractable) {
        self.getNotesInteractor = getNotesInteractor
        self.createNoteInteractor = createNoteInteractor
        self.deleteNoteInteractor = deleteNoteInteractor
    }

    func getAllNotes() {
        let uiTestErrorHandling = ProcessInfo.processInfo.arguments.contains("UITestErrorHandling")
        if uiTestErrorHandling {
            showErrorMessageNote = "Error al cargar la vista en UITest"
        } else {
            showLoadingSpinner = true
            Task {
                let result = await getNotesInteractor.getNotes()
                handleResultGetNotes(result)
            }
        }
    }

    func createNewNote(title: String, description: String) {
        if !title.isEmpty && !description.isEmpty {
            Task {
                let result = await createNoteInteractor.createNote(title: title, description: description)
                handleResultCreateNote(result)
            }
        } else {
            showErrorMessageNote = NSLocalizedString("errorCreatingNote", comment: "")
        }
    }

    func deleteNote(note: Note) {
        Task {
            if let index = self.notes.firstIndex(where: { $0.id == note.id }) {
                let result = await deleteNoteInteractor.deleteNote(note: note)
                handleResultDeleteNote(result, positionNote: index)
            } else {
                showErrorMessageNote = "Error Deleting Note"
            }
        }
    }

    func handleResultGetNotes(_ result: Result<[Note], Error>) {
        guard case .success(let notesResult) = result else {
            showErrorMessageNote = "Error Getting Notes"
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.notes = notesResult
        }
    }

    func handleResultCreateNote(_ result: Result<Note, Error>) {
        guard case .success(let noteResult) = result else {
            showErrorMessageNote = "Error Creating Note"
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.notes.append(noteResult)
        }
    }

    func handleResultDeleteNote(_ result: Result<Bool, Error>, positionNote: Int) {
        guard case .success(let noteResult) = result else {
            showErrorMessageNote = "Error Deleting Note"
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            if noteResult {
                self.notes.remove(at: positionNote)
            }
        }
    }

}
