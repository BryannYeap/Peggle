import SwiftUI

struct CanvasView: View {

    @ObservedObject private var viewModel: CanvasViewModel
    private var cannonView: CannonView = CannonView()

    init(viewModel: CanvasViewModel = .init()) {
        self.viewModel = viewModel
        if let startGameViewModel = viewModel as? StartGameViewModel {
            cannonView.setViewModel(viewModel: startGameViewModel)
        }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                BackgroundView()
                    .gesture(DragGesture().onChanged({ value in
                        viewModel.backgroundOnDragGesture(Point(xCoord: value.location.x,
                                                                yCoord: value.location.y))
                        hideKeyboard()
                    }))
                    .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                        viewModel.backgroundOnTapGesture(at: Point(xCoord: value.location.x,
                                                                   yCoord: value.location.y))
                        hideKeyboard()
                    }))

                ForEach(viewModel.levelGameObjects) {obstacle in
                        createView(obstacle)
                        if let obstacle = obstacle as? Obstacle,
                           let viewModel = viewModel as? LevelDesignerViewModel,
                            obstacle.isBlock {
                                if !viewModel.gameInPlay {
                                    ZStack {
                                        Circle()
                                            .stroke(obstacle.oscillatingSpringConstant
                                                    == obstacle.nonOscillatableSpringConstant
                                                    ? .black : .red,
                                                    lineWidth: 3)
                                            .frame(width: viewModel.obtainOscillatingCircleWidth(for: obstacle),
                                                   height: viewModel.obtainOscillatingCircleWidth(for: obstacle))
                                            .gesture(DragGesture().onChanged({ value in
                                                viewModel.obstacleOnDragGesture(obstacle: obstacle,
                                                                                coord: Point(xCoord: value.location.x,
                                                                                        yCoord: value.location.y))
                                                hideKeyboard()
                                            }))
                                    }.position(x: obstacle.coordinate.xCoord,
                                               y: obstacle.coordinate.yCoord)
                                }
                        }
                }

                ForEach(viewModel.cannonballs) { cannonball in
                    createView(cannonball)
                }

                if viewModel is StartGameViewModel {
                    cannonView.position(cannonView.position)
                }
            }

        }.navigationBarHidden(true)
    }

    private func createView(_ gameObject: GameObject) -> some View {

        var anyView: AnyView = determineView(gameObject)

        if let obstacle = gameObject as? Obstacle {
            anyView = AnyView(anyView.onLongPressGesture(minimumDuration: 0.5) {
                viewModel.obstacleOnLongPressGesture(obstacle)
                hideKeyboard()
            }.gesture(DragGesture().onChanged({ value in
                viewModel.obstacleOnDragGesture(obstacle: obstacle,
                                                coord: Point(xCoord: value.location.x,
                                                             yCoord: value.location.y))
                hideKeyboard()
            })).gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                viewModel.obstacleOnTapGesture(obstacle)
                viewModel.backgroundOnTapGesture(at: Point(xCoord: value.location.x, yCoord: value.location.y))
                hideKeyboard()
            })))
        }

        return anyView
    }

    private func determineView(_ gameObject: GameObject) -> AnyView {
        var anyView: AnyView?

        switch gameObject {
        case is PegObstacle:
            if let peg = gameObject as? PegObstacle {
                anyView = createPegView(withPeg: peg)
            }
        case is TriangleObstacle:
            if let triangle = gameObject as? TriangleObstacle {
                anyView = createTriangleView(withTriangle: triangle)
            }
        case is Cannonball:
            if let cannonball = gameObject as? Cannonball {
                anyView = AnyView(CannonballView(withCannonball: cannonball))
            }
        default:
            assert(false, "Could not identify type of Game Object in CanvasView")
        }

        return anyView ?? AnyView(EmptyView())
    }

    private func createPegView(withPeg peg: PegObstacle) -> AnyView {
        var pegColour: PegView.Colour?
        if let bluePeg = peg as? PegBlue {
            pegColour = bluePeg.willBeDestroyed ? .blueGlow : .blue
        } else if let orangePeg = peg as? PegOrange {
            pegColour = orangePeg.willBeDestroyed ? .orangeGlow : .orange
        } else if let greenPeg = peg as? PegGreen {
            pegColour = greenPeg.willBeDestroyed ? .greenGlow : .green
        } else {
            assert(false, "Cannot identify peg to create PegView in CanvasView")
        }
        return AnyView(PegView(colour: pegColour ?? PegView.Colour.blue,
                               withPeg: peg))
    }

    private func createTriangleView(withTriangle triangle: TriangleObstacle) -> AnyView {
        var triangleColour: TriangleView.Colour?
        if let blueTriangle = triangle as? TriangleBlue {
            triangleColour = blueTriangle.willBeDestroyed ? .blueGlow : .blue
        } else if let orangeTriangle = triangle as? TriangleOrange {
            triangleColour = orangeTriangle.willBeDestroyed ? .orangeGlow : .orange
        } else if let greenTriangle = triangle as? TriangleGreen {
            triangleColour = greenTriangle.willBeDestroyed ? .greenGlow : .green
        } else if let redTriangle = triangle as? TriangleRed {
            triangleColour = redTriangle.willBeDestroyed ? .redGlow : .red
        } else {
            assert(false, "Cannot identify triangle to create TriangleView in CanvasView")
        }
        return AnyView(TriangleView(viewModel: viewModel as? LevelDesignerViewModel ?? LevelDesignerViewModel(),
                                    colour: triangleColour ?? TriangleView.Colour.blue,
                                    withTriangle: triangle))
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
