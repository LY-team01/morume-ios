//
//  FaceIndices.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

/// 顔のパーツインデックス定義
struct FaceIndices {
    static let leftEye: [Int] = [
        33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161, 246,
        471, 472, 469, 470, 468,
        130, 25, 110, 24, 23, 22, 26, 112, 243, 190, 56, 28, 27, 29, 30, 247,
        226, 31, 228, 229, 230, 231, 232, 233, 244, 189, 221, 222, 223, 224, 225, 113,
        35, 111, 117, 118, 119, 120, 121, 128, 245
    ]
    static let rightEye: [Int] = [
        263, 249, 390, 373, 374, 380, 381, 382, 362, 398, 384, 385, 386, 387, 388, 466,
        474, 475, 476, 477, 473,
        359, 467, 260, 259, 257, 258, 286, 414, 463, 341, 256, 252, 253, 254, 339, 255,
        446, 342, 445, 444, 443, 442, 441, 413, 464, 453, 452, 451, 450, 449, 448, 261,
        265, 340, 346, 347, 348, 349, 350, 357, 465
    ]
    static let nose_border = [
        168, 351, 412, 343, 277, 355, 429, 327, 326, 2, 97, 98, 129, 209, 126, 47, 114, 188, 122
    ]
    // 鼻の境界を除いた中身
    static let nose_contain = [
        6, 217, 174, 196, 197, 419, 399, 437, 198, 236, 3, 195, 248, 456, 420, 102, 49, 131, 134, 51, 5, 281, 363, 360,
        279, 331, 48, 115, 220, 45, 4, 275, 440, 344, 278, 64, 219, 237, 44, 1, 274, 457, 438, 439, 294, 235, 59,
        166, 79, 239, 238, 241, 125, 19, 354, 461, 458, 459, 309, 392, 289, 455, 240, 75, 60, 20, 242, 141, 94, 370,
        462, 250, 290, 305, 460, 99, 328
    ]
    // 鼻の全体
    static let nose = [
        168, 351, 412, 343, 277, 355, 429, 327, 326, 2, 97, 98, 129, 209, 126, 47, 114, 188, 122, 6, 217, 174, 196,
        197, 419, 399, 437, 198, 236, 3, 195, 248, 456, 420, 102, 49, 131, 134, 51, 5, 281, 363, 360, 279, 331, 48, 115,
        220, 45, 4, 275, 440, 344, 278, 64, 219, 237, 44, 1, 274, 457, 438, 439, 294, 235, 59, 166, 79, 239, 238,
        241, 125, 19, 354, 461, 458, 459, 309, 392, 289, 455, 240, 75, 60, 20, 242, 141, 94, 370, 462, 250, 290, 305,
        460, 99, 328
    ]
    static let mouth: [Int] = [
        164, 393, 391, 322, 410, 287, 273, 335, 406, 313, 18, 83, 182, 106, 43, 57, 186, 92, 165, 167,
        0, 267, 269, 270, 409, 291, 375, 321, 405, 314, 17, 84, 181, 91, 146, 61, 185, 40, 39, 37,
        13, 312, 311, 310, 415, 308, 324, 318, 402, 317, 14, 87, 178, 88, 95, 78, 191, 80, 81, 82,
        11, 12, 302, 268, 303, 271, 304, 272, 408, 407, 292, 306, 307, 325, 319, 320, 408, 404, 316, 315, 15, 16, 86,
        85, 179, 180, 89, 90, 96, 77, 62, 76
    ]
    static let leftContour: [Int] = [70, 63, 105, 66, 107, 55, 65, 52, 53, 46]
    static let rightContour: [Int] = [300, 293, 334, 296, 336, 285, 295, 282, 283, 276]
}
