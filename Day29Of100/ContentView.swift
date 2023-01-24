//
//  ContentView.swift
//  Day29Of100
//
//  Created by Anand Narayan on 2022-12-26.
//

import SwiftUI

struct ContentView: View {
    
    @State var fileContents = ""
    @State var usedWords: [String] = [String]()
    @State var rootWord: String = ""
    @State var currentlySpelling: String = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Enter your wordle!") {
                        HStack {
                            TextField("What word you want?", text: $currentlySpelling)
                                .textInputAutocapitalization(.never)
                                .onSubmit {
                                    addNewWord(word: currentlySpelling)
                                }.onAppear {
                                    getFile()
                                }.alert(errorTitle, isPresented: $showingError) {
                                    Button(action: {
                                        showingError = false
                                    }, label: {
                                        Text("ok")
                                    })
                                } message: {
                                    Text(errorMessage)
                                }
                            Image(systemName: "\(currentlySpelling.count).circle.fill")
                        }

                    }
                    Section("Words already entered!") {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Text(word)
                                Image(systemName: "\(word.count).circle.fill")
                            }

                        }
                    }
                }
            }
            .padding()
            .navigationTitle($rootWord)
        }
        

    }
    
    func setErrorMessage(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func hasWordBeenUsed(word: String) -> Bool {
        return usedWords.contains(word)
    }
    
    func checkLetters(word: String) -> Bool {
        var copyOfRoot = rootWord
        var isValid = true
        word.forEach { char in
            if (copyOfRoot.contains(char)) {
                copyOfRoot.remove(at: copyOfRoot.firstIndex(of: char)!)
            }
            isValid = false
            
        }
        return isValid
    }
    
    func isSpellingCorrect(word: String) -> Bool {
        let checker = UITextChecker()
        //Get a range amount
        let range = NSRange(location: 0,
        length: word.utf16.count)

        //Use all of that to check the spelling!
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
 
    func getFile() {
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let testData = try? String(contentsOf: fileURL) {
                fileContents =  testData
                let words = fileContents.components(separatedBy: "\n")
                rootWord = words.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from the bundle.")
    }
    
    func addNewWord(word:String) {
        let trimmed = word.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmed.count > 0) {
            if hasWordBeenUsed(word: trimmed) {
                setErrorMessage(title: "Word used already", message: "Be more original")
                return
            }

            if checkLetters(word: trimmed) {
                setErrorMessage(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
                return
            }

            if isSpellingCorrect(word: trimmed) {
                setErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                return
            }
            withAnimation {
                usedWords.insert(trimmed, at: 0)
                currentlySpelling = ""
            }
            
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
