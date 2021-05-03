//
//  MainView.swift
//  NewsGoose Importer
//
//  Created by Chad Parker on 4/29/21.
//

import SwiftUI
import NGCore

struct MainView: View {

    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            Text("NewsGoose Importer")
                .font(.title)
                .padding()
            VStack {
                ProgressView("Importing posts…", value: Float(viewModel.fileCountProgress), total: Float(viewModel.fileCountTotal))
                HStack {
                    Text("\(viewModel.postsImportedCount) posts imported")
                    Spacer()
                    Text("file \(viewModel.fileCountProgress) of \(viewModel.fileCountTotal)")
                }
                .font(.callout.monospacedDigit())
                .foregroundColor(.gray)
            }
            .frame(width: 300)
        }
        .padding()
        .padding(.bottom) // window size bug
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}
