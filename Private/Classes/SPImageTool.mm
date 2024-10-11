//
//  SPImageTool.m
//  SdkProj
//
//  Created by dzp on 2024/10/10.
//



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#endif

#ifdef __cplusplus
#   include <opencv2/opencv.hpp>
#   include <opencv2/stitching/detail/blenders.hpp>
#   include <opencv2/stitching/detail/exposure_compensate.hpp>
#else
#   import <Foundation/Foundation.h>
#   import <UIKit/UIKit.h>
#   import <Availability.h>
#endif



#import "SPImageTool.h"

using namespace cv;
using namespace std;


@implementation SPImageTool

/* 4通道转成3通道 */
NS_INLINE cv::Mat kFourChannelsBecomeThree(const cv::Mat src){
    Mat mat1;
    Mat dst;
    if (src.channels() == 4) {
        cv::cvtColor(src, dst, COLOR_RGBA2RGB);
        return dst;
    }
    return src;
}

/* 调整图片亮度和对比度，contrast[0-100],luminance[0-2] */
- (UIImage*)kj_opencvChangeContrast:(int)contrast luminance:(double)luminance img:(UIImage*)img{
    cv::Mat src,dst;
    UIImageToMat(img,src,true);
    src = kFourChannelsBecomeThree(src);
    dst = Mat::zeros(src.size(), src.type());
    int channels = src.channels();
    for (int i = 0; i < src.rows; i++) {
        for (int j = 0; j < src.cols; j++) {
            if (channels == 3) {//rgb
                dst.at<Vec3b>(i, j)[0] = saturate_cast<uchar>(src.at<Vec3b>(i, j)[0] * luminance + contrast);
                dst.at<Vec3b>(i, j)[1] = saturate_cast<uchar>(src.at<Vec3b>(i, j)[1] * luminance + contrast);
                dst.at<Vec3b>(i, j)[2] = saturate_cast<uchar>(src.at<Vec3b>(i, j)[2] * luminance + contrast);
            }else if (channels == 1) {//gray
                dst.at<uchar>(i, j) = saturate_cast<uchar>(src.at<uchar>(i, j) * luminance + contrast);
            }
        }
    }
    return MatToUIImage(dst);  // 使用类方法调用
    
    return nil;
}

// 添加 MatToUIImage 函数定义
+ (UIImage *)MatToUIImage:(cv::Mat)mat {
    NSData *data = [NSData dataWithBytes:mat.data length:mat.elemSize() * mat.total()];

    CGColorSpaceRef colorSpace;

    if (mat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    CGImageRef imageRef = CGImageCreate(mat.cols,
                                        mat.rows,
                                        8,
                                        8 * mat.elemSize(),
                                        mat.step[0],
                                        colorSpace,
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);

    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];

    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return finalImage;
}

@end
