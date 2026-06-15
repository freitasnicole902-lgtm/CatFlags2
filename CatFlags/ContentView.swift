import SwiftUI

struct ContentView: View {
    
    @State private var goToCreateRoom = false
    @State private var goToBoardRoom = false
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: CreateRoomView(), isActive: $goToCreateRoom){
                    Button("Criar sala"){
                        goToCreateRoom = true
                    }
                }
                
                NavigationLink(destination: JoinRoomView(), isActive: $goToBoardRoom){
                    Button("Entrar em sala"){
                        goToBoardRoom = true
                    }
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
