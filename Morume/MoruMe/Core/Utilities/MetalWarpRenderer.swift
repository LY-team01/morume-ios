//
//  MetalWarpRenderer.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import Foundation
import Metal
import MetalKit
import UIKit

final class MetalWarpRenderer {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let textureLoader: MTKTextureLoader

    init?() {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else {
            print("[MetalWarpRenderer] Metal device/commandQueue作成失敗")
            return nil
        }
        self.device = device
        self.commandQueue = commandQueue
        self.textureLoader = MTKTextureLoader(device: device)
        // Load Metal shader
        guard let library = device.makeDefaultLibrary() else {
            print("[MetalWarpRenderer] Metalライブラリのロード失敗")
            return nil
        }
        guard let vertexFunc = library.makeFunction(name: "vertex_main") else {
            print("[MetalWarpRenderer] vertex_main関数が見つかりません")
            return nil
        }
        guard let fragmentFunc = library.makeFunction(name: "fragment_main") else {
            print("[MetalWarpRenderer] fragment_main関数が見つかりません")
            return nil
        }
        let pipelineDesc = MTLRenderPipelineDescriptor()
        pipelineDesc.vertexFunction = vertexFunc
        pipelineDesc.fragmentFunction = fragmentFunc
        pipelineDesc.colorAttachments[0].pixelFormat = .bgra8Unorm

        // 頂点属性レイアウトを設定
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float2  // position
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float2  // texCoord
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.size * 2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.size * 4
        pipelineDesc.vertexDescriptor = vertexDescriptor

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDesc)
        } catch {
            print("[MetalWarpRenderer] パイプライン作成失敗: \(error)")
            return nil
        }
        print("[MetalWarpRenderer] Metal初期化成功")
    }

    // ワーピング描画
    func warp(image: UIImage, srcPoints: [CGPoint], dstPoints: [CGPoint], triangles: [Triangle]) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        // Metalテクスチャ作成（sRGBなし、ガンマ補正なしでロード）
        let options: [MTKTextureLoader.Option: Any] = [
            .SRGB: false,
            .generateMipmaps: false
        ]
        guard let srcTexture = try? textureLoader.newTexture(cgImage: cgImage, options: options) else {
            print("[MetalWarpRenderer] 画像テクスチャ作成失敗")
            return nil
        }
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: width,
            height: height,
            mipmapped: false
        )
        desc.usage = [.renderTarget, .shaderRead, .shaderWrite]
        guard let dstTexture = device.makeTexture(descriptor: desc) else {
            print("[MetalWarpRenderer] 出力テクスチャ作成失敗")
            return nil
        }
        // 頂点バッファ生成
        var vertices: [Float] = []
        for tri in triangles {
            let idx = [tri.point1, tri.point2, tri.point3].map { pt in
                dstPoints.firstIndex(where: { abs($0.x - CGFloat(pt.x)) < 0.5 && abs($0.y - CGFloat(pt.y)) < 0.5 }) ?? 0
            }
            let srcIdx = idx
            for i in 0..<3 {
                let dstPt = dstPoints[idx[i]]
                let srcPt = srcPoints[srcIdx[i]]
                // Metal座標系(-1~1)に変換
                let x = Float(dstPt.x / CGFloat(width) * 2 - 1)
                let y = Float(1 - dstPt.y / CGFloat(height) * 2)
                let u = Float(srcPt.x / CGFloat(width))
                let v = Float(srcPt.y / CGFloat(height))
                vertices += [x, y, u, v]
            }
        }
        let dataSize = vertices.count * MemoryLayout<Float>.size
        guard let vertexBuffer = device.makeBuffer(bytes: vertices, length: dataSize, options: []) else { return nil }
        // コマンドバッファ・レンダーパス
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("[MetalWarpRenderer] コマンドバッファ作成失敗")
            return nil
        }
        let rpd = MTLRenderPassDescriptor()
        rpd.colorAttachments[0].texture = dstTexture
        rpd.colorAttachments[0].loadAction = .clear
        rpd.colorAttachments[0].storeAction = .store
        rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd) else {
            print("[MetalWarpRenderer] コマンドエンコーダ作成失敗")
            return nil
        }
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setFragmentTexture(srcTexture, index: 0)

        // サンプラーを明示的にセット
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.sAddressMode = .clampToEdge
        samplerDescriptor.tAddressMode = .clampToEdge
        let sampler = device.makeSamplerState(descriptor: samplerDescriptor)
        encoder.setFragmentSamplerState(sampler, index: 0)

        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count / 4)
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        // テクスチャ→UIImage
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let byteCount = bytesPerRow * height
        var rawData = [UInt8](repeating: 0, count: byteCount)
        let region = MTLRegionMake2D(0, 0, width, height)
        dstTexture.getBytes(&rawData, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        // 元画像と同じColorSpaceとBitmapInfoを使用
        let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.bitmapInfo.rawValue

        let ctx = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        )
        guard let outCG = ctx?.makeImage() else {
            print("[MetalWarpRenderer] CGContext→CGImage変換失敗")
            return nil
        }
        return UIImage(cgImage: outCG, scale: image.scale, orientation: image.imageOrientation)
    }
}
