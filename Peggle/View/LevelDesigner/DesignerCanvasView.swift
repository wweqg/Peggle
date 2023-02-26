//
//  DesignerCanvasView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//

import SwiftUI

struct DesignerCanvasView: View {
    @ObservedObject private var levelDesignerViewModel: LevelDesignerViewModel
    init(levelDesignerViewModel: LevelDesignerViewModel) {
        self.levelDesignerViewModel = levelDesignerViewModel
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                        levelDesignerViewModel.backgroundOnTapGesture(
                            Point(xCoordinate: value.location.x, yCoordinate: value.location.y),
                            canvas: geometry.frame(in: .local))
                    }))
                ForEach(levelDesignerViewModel.selectedLevelPegs) { peg in
                    createDesignPegView(peg)
                        .onLongPressGesture(minimumDuration: 0.5) {
                            levelDesignerViewModel.peggObjOnLongPressGesture(peg)
                        }.gesture(DragGesture().onChanged({ value in
                            levelDesignerViewModel.peggObjOnDragGesture(
                                Point(xCoordinate: value.location.x, yCoordinate: value.location.y),
                                peg, geometry.frame(in: .local))
                        }))
                        .gesture(DragGesture(minimumDistance: 0).onEnded({ _ in
                            levelDesignerViewModel.peggObjOnTapGesture(peg)
                        }))
                }
                ForEach(levelDesignerViewModel.selectedLevelRectangles) { rect in
                    createDesignRectView(rect)
                        .onLongPressGesture(minimumDuration: 0.5) {
                            levelDesignerViewModel.peggObjOnLongPressGesture(rect)
                        }.gesture(DragGesture().onChanged({ value in
                            levelDesignerViewModel.peggObjOnDragGesture(
                                Point(xCoordinate: value.location.x, yCoordinate: value.location.y),
                                rect, geometry.frame(in: .local))
                        }))
                        .gesture(DragGesture(minimumDistance: 0).onEnded({ _ in
                            levelDesignerViewModel.peggObjOnTapGesture(rect)
                        }))
                }
            }
        }
    }
    func createDesignPegView(_ peg: Peg) -> some View {
        PegView(pos: .constant(CGPoint(x: peg.coordinate.xCoordinate,
                                       y: peg.coordinate.yCoordinate)), willBeDestroyed: .constant(peg.willBeDestroyed),
                                                                        pegType: peg.pegType, pegRadius: peg.radius)
    }
    func createDesignRectView(_ rect: Rectangle) -> some View {
        RectangleView(height: .constant(rect.height), width: .constant(rect.width),
                      pos: .constant(CGPoint(x: rect.coordinate.xCoordinate, y: rect.coordinate.yCoordinate)))
    }
}

struct DesignerCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        DesignerCanvasView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
