//
//  StartGameCanvasView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct StartGameCanvasView: View {
    @ObservedObject var viewModel: StartGameViewModel
    init(viewModel: StartGameViewModel = .init()) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack {
            BackgroundView()
                .gesture(DragGesture().onChanged({ value in
                    viewModel.backgroundOnDragGesture(point: Point(xCoordinate: value.location.x,
                                                                   yCoordinate: value.location.y))
                }))
                .gesture(DragGesture(minimumDistance: 0).onEnded({ _ in
                    viewModel.backgroundOnTapGesture()
                }))
            ForEach(viewModel.pegs) { peg in
                createPegView(peg)
            }
            ForEach(viewModel.rects) { rect in
                createRectView(rect)
            }
            CannonView(shoot: $viewModel.cannon.shoot,
                       size: viewModel.cannon.size)
                .rotationEffect(.radians(viewModel.rotation))
                .position(toCGPoint(point: viewModel.cannon.coordinate))
            BucketView(size: viewModel.bucket.size)
                .position(x: viewModel.bucket.coordinate.xCoordinate, y: viewModel.bucket.coordinate.yCoordinate)
            if viewModel.cannonBallInPlay {
                if let cannonBall = viewModel.cannonBall {
                    CannonBallView(radius: cannonBall.radius)
                        .position(x: cannonBall.coordinate.xCoordinate, y: cannonBall.coordinate.yCoordinate)
                }
            }
            TimerView(viewModel: viewModel)
            PointView(viewModel: viewModel)
            RemainingPegsView(viewModel: viewModel)
        }
    }
    func createPegView(_ peg: Peg) -> some View {
        PegView(pos: .constant(CGPoint(x: peg.coordinate.xCoordinate, y: peg.coordinate.yCoordinate)),
                willBeDestroyed: .constant(peg.willBeDestroyed),
                pegType: peg.pegType, pegRadius: peg.radius)
    }
    func createRectView(_ rect: Rectangle) -> some View {
        RectangleView(height: .constant(rect.height), width: .constant(rect.width),
                      pos: .constant(CGPoint(x: rect.coordinate.xCoordinate, y: rect.coordinate.yCoordinate)))
    }
    private func toCGPoint(point: Point) -> CGPoint {
        CGPoint(x: point.xCoordinate, y: point.yCoordinate)
    }
}

struct StartGameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameCanvasView(viewModel: StartGameViewModel())
    }
}
