//
//  SummaryView.swift
//  Day29Of100
//
//  Created by Anand Narayan on 2023-01-26.
//

import SwiftUI

struct SummaryView: View {
    var currentWord: String
    var numberOfTries: Int
    var overallWordsTried: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Word :")
                Text(currentWord)
            }
            HStack {
                Text("Number of attempts for current word :")
                Text("\(numberOfTries)")
            }
            HStack {
                Text("Overall words tried :")
                Text("\(overallWordsTried)")
            }
        }

    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(currentWord: "", numberOfTries: 9, overallWordsTried: 9)
    }
}
