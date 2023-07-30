//
//  ScratchCardView.swift
//  Masking
//
//  Created by Bilal SIMSEK on 30.07.2023.
//

import SwiftUI

struct ScratchCardView<Content:View,Overlay:View>: View {
    var content:Content
    var overlay:Overlay
    var pointSize:CGFloat
    var onFinish:()->()
    
    @State var dragPoints:[CGPoint] = []
    @State var animateCard:[Bool] = [false,false]
    @State var isScratched:Bool = false
    @State var disableGesture:Bool = false
    
    init( pointSize: CGFloat,@ViewBuilder content:@escaping ()->Content, overlay:@escaping ()-> Overlay, onFinish: @escaping () -> Void) {
        self.content = content()
        self.overlay = overlay()
        self.pointSize = pointSize
        self.onFinish = onFinish
    }
    
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            
        ZStack{
            
            overlay
                .opacity(disableGesture ? 0 : 1)
            content
                .mask {
                    if disableGesture{
                        Rectangle()
                    }else{
                        PointShape(points: dragPoints)
                            .stroke(style: StrokeStyle(lineWidth:
                                                        isScratched ? size.width * 1.7 :
                                                        pointSize,lineCap: .round,lineJoin: .round))
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: disableGesture ? 100000 : 0)
                        .onChanged({ value in
                            if dragPoints.isEmpty{
                                withAnimation {
                                    animateCard[0] = false
                                    animateCard[1] = false
                                }
                            }
                            dragPoints.append(value.location)
                        })
                        .onEnded({ _ in
                            if !dragPoints.isEmpty{
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    isScratched = true
                                }
                                
                                onFinish()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                                    disableGesture = true
                                }
                            }
                        })
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment:.center)
        .rotation3DEffect(.init(degrees: animateCard[0] ? 4 : 0), axis: (x:1,y:0,z:0))
        .rotation3DEffect(.init(degrees: animateCard[1] ? 4 : 0), axis: (x:0,y:1,z:0))
        
        .onAppear{
            withAnimation(.easeInOut.delay(1.5).repeatForever(autoreverses:true)) {
                animateCard[0] = true
            }
            withAnimation(.easeInOut.delay(1.5).repeatForever(autoreverses:true).delay(0.8)) {
                animateCard[1] = true
            }
        }
    }
       
   
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct PointShape:Shape{
    var points:[CGPoint]
    var animatableData:[CGPoint]{
        get{points}
        set{points = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{path in
            if let first = points.first{
                path.move(to: first)
                path.addLines(points)
            }
           
            
        }
    }
}
