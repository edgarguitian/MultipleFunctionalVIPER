//
//  NotesInteractorTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import XCTest
@testable import MultipleFunctional
import FirebaseFirestore
import FirebaseFirestoreSwift

class NotesInteractorTests: XCTestCase {
    var initialNote: Note!

    override func setUpWithError() throws {
        super.setUp()

        // Initialize NotesRepository with MockErrorMapper
        initialNote = Note(titulo: "Test Title", descripcion: "Test Description")
        let dataBaseName = MultipleFunctional.Constants.databaseFirestoreName
        _ = try Firestore.firestore().collection(dataBaseName).addDocument(from: initialNote)
    }

    // MARK: - Test GetNotesInteractable

    func testGetNotesSuccess() async {
        // WHEN
        let result = await NoteInteractor().getNotes()

        // THEN
        switch result {
        case .success(let notes):
            XCTAssertEqual(notes.count, 1)
            XCTAssertEqual(notes[0].titulo, "Test Title")
            XCTAssertEqual(notes[0].descripcion, "Test Description")
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }

    // MARK: - Test CreateNoteInteractable

    func testCreateNoteSuccess() async {
        // GIVEN
        let mockTitle = "Test New Title"
        let mockDescription = "Test New Description"

        // WHEN
        let result = await NoteInteractor().createNote(title: mockTitle, description: mockDescription)

        // Assert the result
        switch result {
        case .success(let note):
            XCTAssertEqual(note.titulo, mockTitle)
            XCTAssertEqual(note.descripcion, mockDescription)
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }

    // MARK: - Test DeleteNoteInteractable

    func testDeleteNoteSuccess() async {
        // GIVEN
        let resultGet = await NoteInteractor().getNotes()
        guard let notes = try? resultGet.get() else {
            XCTFail("Not Notes in Firestore")
            return
        }

        // WHEN
        guard let firstNote = notes.first else {
            XCTFail("Not Notes in Firestore")
            return
        }
        let result = await NoteInteractor().deleteNote(note: firstNote)

        // THEN
        switch result {
        case .success(let note):
            XCTAssertEqual(note, true)
        case .failure:
            XCTFail("Failure on delete note.")
        }
    }
}
