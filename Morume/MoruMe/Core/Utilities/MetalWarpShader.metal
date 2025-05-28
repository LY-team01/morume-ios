//
//  MetalWarpShader.metal
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = float4(in.position, 0, 1);
    out.texCoord = in.texCoord;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              texture2d<float, access::sample> srcTexture [[texture(0)]],
                              sampler srcSampler [[sampler(0)]]) {
    float4 color = srcTexture.sample(srcSampler, in.texCoord);
    // RとBを入れ替え - BGRA → RGBA
    return float4(color.b, color.g, color.r, color.a);
}
