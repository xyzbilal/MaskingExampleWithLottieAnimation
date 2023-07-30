//
//  Home.swift
//  Masking
//
//  Created by Bilal SIMSEK on 30.07.2023.
//

import SwiftUI

struct Home: View {
    
    @State var expandCard:Bool = false
    @State var showContent:Bool = false
    @State var showLottieAnimation:Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack {
            HStack{
                HStack{
                    Image(systemName: "applelogo")
                    Text("Pay")
                }
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                Spacer()
                Button {
                    
                } label: {
                 Text("Back")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

            }
            
            CardView()
            
            Text("Yesss")
                .font(.system(size: 35,weight: .bold))
            Text("Some addidional data you want to tell")
                .kerning(1.02)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Button {
                
            } label: {
                Text("BALANCE")
                    .fontWeight(.semibold)
                    .padding(.vertical,17)
                    .frame(maxWidth: .infinity)
                    .background{
                        Rectangle()
                            .fill(.linearGradient(colors: [Color("Purple"),Color("Purple1")], startPoint: .leading, endPoint: .trailing))
                            
                    }
                    .padding(.top)
            }

            
            
           
        }.foregroundColor(.white)
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay{
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(showContent ? 1 : 0)
                .ignoresSafeArea()
        }
        .overlay {
            GeometryReader { proxy in
                if expandCard{
                    
                    GiftCardView(size: proxy.size)
                        .overlay(content: {
                            if showLottieAnimation{
                                ResizableLottieView(fileName: "Party") { animation in
                                    withAnimation(.easeInOut(duration: 0.35)){
                                    
                                        showLottieAnimation = false
                                    }
                                }
                            }
                        })
                    
                        .matchedGeometryEffect(id: "GFCARD", in: animation)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(x:1)))
                       // .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear{
                            withAnimation(.easeInOut(duration: 0.35)){
                                showContent = true
                                showLottieAnimation = true
                            }
                        }
                }
            }
            .padding(30)
          
        }
        .overlay(alignment: .topTrailing, content: {
        
                Button {
                    withAnimation(.easeInOut(duration: 0.35)){
                        showContent = false
                        showLottieAnimation = false
                    }
                    withAnimation(.easeInOut(duration: 0.35).delay(0.1)){
                        expandCard = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(15)
                }.opacity(expandCard ? 1 : 0)
               

        })
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func CardView()->some View{
        GeometryReader { proxy in
            let size = proxy.size
            
            ScratchCardView(pointSize: 60) {
                if !expandCard{
                    GiftCardView(size: size)
                        .matchedGeometryEffect(id: "GFCARD", in: animation)
                }
            } overlay: {
                Image("card")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width*0.9, height: size.height*0.9,alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } onFinish: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        expandCard = true
                    }
                }
            }
            .frame(width: size.width, height: size.height,alignment: .center)

        }
        .padding(15)
    }
    
    
    @ViewBuilder
    func GiftCardView(size:CGSize)->some View{
        VStack(spacing: 18) {
            Image("Trophy")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
            Text("You Won")
                .font(.callout)
                .foregroundColor(.gray)
            HStack{
                Image(systemName: "applelogo")
                Text("₺79")
            }
            .font(.title.bold())
            .foregroundColor(.black)
            Text("It will be your account soo late")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(20)
        .frame(width: size.width, height: size.height)
        .background{
            RoundedRectangle(cornerRadius: 15)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
