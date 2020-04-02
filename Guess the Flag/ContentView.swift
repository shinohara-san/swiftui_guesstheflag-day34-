
import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var dim = false
    @State private var dimAmount:Double = 0
    
    @State private var wrongAnswer = false
    
    var body: some View {
        ZStack{
            
        LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
            
        VStack(spacing: 30) {
            Spacer()
          VStack {
            Text("Tap the flag of").foregroundColor(.white)
            Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle)
            .fontWeight(.black)
            }
            ForEach(0 ..< 3) { number in
                    Button(action: {
                       self.flagTapped(number)
                       
                    }) { Image(self.countries[number]) .renderingMode(.original).clipShape(Capsule()).overlay(Capsule().stroke(Color.black, lineWidth: 1)).shadow(color: .black, radius: 2)
                        .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.dim == true && number == self.correctAnswer ? 1 : 1.0 - self.dimAmount)
//                        正解の時だけスピン、不正解の国旗はオパシティ0.25
                    }
                }
            Text("Score: \(score)").foregroundColor(.white)
            Spacer()
            
            }
            Group{
                if self.wrongAnswer == true{
                    Image("wrong").resizable().edgesIgnoringSafeArea(.all)
                } else{
                    Image("wrong").hidden()
                    
                }
            }
            
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            self.score += 10
            self.dim = true
            self.dimAmount = 0.75
            withAnimation{
                self.animationAmount += 360
                
            }
        } else {
            scoreTitle = "Wrong! That is the flag of \(self.countries[number]). "
            self.score -= 10
            self.wrongAnswer = true
        }

        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.dim = false
        self.dimAmount = 0
        self.wrongAnswer = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
