//
//  SPImageTool.h
//  SdkProj
//
//  Created by dzp on 2024/10/10.
//


NS_ASSUME_NONNULL_BEGIN

@interface SPImageTool : NSObject

/* 调整图片亮度和对比度，contrast[0-100],luminance[0-2] */
- (UIImage*)kj_opencvChangeContrast:(int)contrast luminance:(double)luminance img:(UIImage*)img;

@end

NS_ASSUME_NONNULL_END
