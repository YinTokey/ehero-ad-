//
//  UIImage+Cut.h
//  Pods
//
//  Created by YinjianChen on 2016/10/10.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Cut)


+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage *)rectImageWithImage:(UIImage *)originImg clipRect:(CGRect)clipRect;

+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect;

@end
