//
//  ThemeSelectionView.swift
//  CatFlags
//
//  Created by academy on 12/06/26.
//

import SwiftUI

struct ThemeSelectionView: View {

    var body: some View {

        VStack(spacing: 20) {

            Text("Escolha o tema:")
                .font(.largeTitle)

            Button("❤️ Amor") {

            }

            Button("👨‍👩‍👧 Família") {
            }

            Button("🤝 Amigos") {

            }

            Button("👥 Geral") {

            }
        }
    }
}


struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelectionView()
    }
}
