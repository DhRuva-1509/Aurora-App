//
//  ParticleAnimation.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-06.
//

import SwiftUI
import Combine

struct Particle {
    var position: CGPoint
    var velocity: CGVector
    var angle: Double
    var length: CGFloat
    var angularSpeed: CGFloat
}

struct ParticleAnimation: View {
    @State private var particles: [Particle] = []
    @State private var innerParticles: [Particle] = []
    private let particleCount = 90
    private let innerParticleCount = 990
    private let connectionDistance: CGFloat = 100

    // Timer firing at ~60fps
    private let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 2 // small inset
            
            Canvas { context, size in
                // Draw particles as small circles
                for particle in particles {
                    let rect = CGRect(x: particle.position.x - 1.5,
                                      y: particle.position.y - 1.5,
                                      width: 3,
                                      height: 3)
                    context.fill(Path(ellipseIn: rect), with: .color(.blue))
                }
                for particle in innerParticles {
                    let rect = CGRect(x: particle.position.x - 1.0,
                                      y: particle.position.y - 1.0,
                                      width: 2,
                                      height: 2)
                    context.fill(Path(ellipseIn: rect), with: .color(.blue))
                }
            }
            .background(Color.clear)
            .onAppear {
                // Initialize particles on circle evenly spaced with random angular speeds
                particles = (0..<particleCount).map { i in
                    let t = Double(i) / Double(max(1, particleCount))
                    let angle = t * 2 * .pi
                    let x = center.x + radius * cos(angle)
                    let y = center.y + radius * sin(angle)
                    let position = CGPoint(x: x, y: y)
                    let angularSpeed = CGFloat.random(in: (-.pi/6)...(.pi/6)) / 800.0 // radians per frame
                    return Particle(position: position,
                                    velocity: .zero,
                                    angle: angle,
                                    length: 0,
                                    angularSpeed: angularSpeed)
                }
                
                innerParticles = (0..<innerParticleCount).map { _ in
                    // Random point inside circle (uniform)
                    let r = radius * sqrt(CGFloat.random(in: 0...1))
                    let theta = CGFloat.random(in: 0..<(2 * .pi))
                    let pos = CGPoint(x: center.x + r * cos(theta), y: center.y + r * sin(theta))
                    // Random velocity
                    let speed = CGFloat.random(in: 8...30) / 60.0
                    let dir = CGFloat.random(in: 0..<(2 * .pi))
                    let vel = CGVector(dx: cos(dir) * speed, dy: sin(dir) * speed)
                    return Particle(position: pos, velocity: vel, angle: 0, length: 0, angularSpeed: 0)
                }
            }
            .onReceive(timer) { _ in
                // Update particle angles and positions on the circle
                for idx in particles.indices {
                    var p = particles[idx]
                    p.angle += Double(p.angularSpeed)
                    // Keep angle in [0, 2π) for numerical stability
                    if p.angle >= 2 * .pi { p.angle -= 2 * .pi }
                    if p.angle < 0 { p.angle += 2 * .pi }
                    let x = center.x + radius * cos(p.angle)
                    let y = center.y + radius * sin(p.angle)
                    p.position = CGPoint(x: x, y: y)
                    particles[idx] = p
                }
                for idx in innerParticles.indices {
                    var p = innerParticles[idx]
                    // Propose next position
                    var next = CGPoint(x: p.position.x + p.velocity.dx,
                                       y: p.position.y + p.velocity.dy)
                    // If outside circle, reflect velocity against normal at current position and step
                    let dx = next.x - center.x
                    let dy = next.y - center.y
                    let dist2 = dx*dx + dy*dy
                    if dist2 > radius*radius {
                        // Normal from center to current position
                        let nx = p.position.x - center.x
                        let ny = p.position.y - center.y
                        let nLen = max(0.0001, sqrt(nx*nx + ny*ny))
                        let ux = nx / nLen
                        let uy = ny / nLen
                        // Reflect v: v' = v - 2*(v·n)*n
                        let v = p.velocity
                        let dot = v.dx * ux + v.dy * uy
                        let rx = v.dx - 2 * dot * ux
                        let ry = v.dy - 2 * dot * uy
                        p.velocity = CGVector(dx: rx, dy: ry)
                        // Step with reflected velocity
                        next.x = p.position.x + p.velocity.dx
                        next.y = p.position.y + p.velocity.dy
                        // Pull slightly inward if still out due to numeric issues
                        let ddx = next.x - center.x
                        let ddy = next.y - center.y
                        let d = sqrt(ddx*ddx + ddy*ddy)
                        if d > radius {
                            let k = (radius - 0.5) / d
                            next = CGPoint(x: center.x + ddx * k, y: center.y + ddy * k)
                        }
                    }
                    p.position = next
                    innerParticles[idx] = p
                }
            }
        }
    }
}

#Preview {
    ParticleAnimation()
}
