//
//  CineTrackUITests.swift
//  CineTrackUITests
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import XCTest

final class CineTrackUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launchApp(resetPersistence: Bool = false) {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        
        if resetPersistence {
            app.launchArguments.append("RESET_PERSISTENCE")
        }
        
        app.launch()
        self.app = app
    }
    
    // MARK: - Navegação Home → Detail
    @MainActor
    func testHomeToDetailNavigation() throws {
        launchApp()

        // Aguarda a lista carregar
        let firstCard = app.images.element(boundBy: 4)
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5))
        firstCard.tap()

        // Verifica que a tela de detalhe apareceu
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
    }
    
    // MARK: - Busca
    @MainActor
    func testSearch() throws {
        launchApp()

        // Vai para a aba Search
        app.tabBars.buttons["Search"].tap()
        
        // Ativa o campo de busca
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("Batman")
        
        // Aguarda resultados aparecerem
        let firstResult = app.cells.firstMatch
        XCTAssertTrue(firstResult.waitForExistence(timeout: 5))
    }
    
    // MARK: - Library
    @MainActor
    func testAddToFavorites() throws {
        launchApp(resetPersistence: true)

        // Abre o detalhe do primeiro item
        let firstCard = app.images.element(boundBy: 4)
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5))
        firstCard.tap()
        
        // Toca no botão de favorito
        let favoriteButton = app.buttons["heart"].firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        favoriteButton.tap()
        
        // Volta e vai para Library
        app.navigationBars.buttons.firstMatch.tap()
        app.tabBars.buttons["Library"].tap()
        
        // Verifica que o item aparece na lista
        let savedItem = app.cells.firstMatch
        XCTAssertTrue(savedItem.waitForExistence(timeout: 3))
    }
    
    @MainActor
    func testSwipeToDeleteFromLibrary() throws {
        launchApp(resetPersistence: true)

        // Salva um item nesta execução antes de validar a exclusão.
        let firstCard = app.images.element(boundBy: 4)
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5))
        firstCard.tap()

        let favoriteButton = app.buttons["heart"].firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        favoriteButton.tap()

        app.navigationBars.buttons.firstMatch.tap()
        app.tabBars.buttons["Library"].tap()
        
        let firstCell = app.cells.firstMatch
        guard firstCell.waitForExistence(timeout: 3) else { return }
        
        firstCell.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Lista deve estar vazia
        XCTAssertFalse(app.cells.firstMatch.exists)
    }
}
