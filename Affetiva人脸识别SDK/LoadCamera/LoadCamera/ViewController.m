//
//  ViewController.m
//  LoadCamera
//
//  Created by William on 2017/11/8.
//  Copyright © 2017年 William. All rights reserved.
//

#import "ViewController.h"
#import <Affdex/Affdex.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AFDXDetectorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
//"开始识别"按钮
@property (weak, nonatomic) IBOutlet UIButton *discern;
@property (nonatomic,strong) UIImage *image;
//探测器
@property (nonatomic,strong) AFDXDetector *detector;
@property (nonatomic,strong) NSArray *emotionArray;
@end

@implementation ViewController
//开始识别按钮
- (IBAction)startDiscern:(UIButton *)sender {
    if(self.detector == nil){
        self.detector = [[AFDXDetector alloc] initWithDelegate:self discreteImages:YES maximumFaces:1 faceMode:LARGE_FACES];
    }
    //允许探测器分析表情
    [self.detector enableAnalytics];
    //打开情绪的识别
//    [self.detector setDetectAllEmotions:YES];
    self.detector.anger = YES;
    self.detector.contempt = YES;
    self.detector.disgust = YES;
    self.detector.fear = YES;
    self.detector.joy = YES;
    self.detector.sadness = YES;
    self.detector.surprise = YES;
/*
 可选择实现的识别方法
 [self.detector setDetectAllExpressions:YES];
 [self.detector setDetectEmojis:YES];
 */
    //传入图片
    [self.detector processImage:self.image];
    
}

//打开相册选择图片按钮
- (IBAction)Images:(UIButton *)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];

}
#pragma AFDXDetectorDelegateMethods
/*
 可选择实现的方法（根据需要）：
 -(void)detector:(AFDXDetector *)detector didStartDetectingFace:(AFDXFace *)face;
 {
 
 }
 -(void)detector:(AFDXDetector *)detector didStopDetectingFace:(AFDXFace *)face;
 {
 
 }

 */

-(void)detector:(AFDXDetector *)detector hasResults:(NSMutableDictionary *)faces forImage:(UIImage *)image atTime:(NSTimeInterval)time;
{
    //拿到faces字典里的所有值
    for(AFDXFace *face in [faces allValues]){
        for(NSString *emo in self.emotionArray){
            NSNumber *emoNum = [face.emotions valueForKey:emo];
            
            
            
            if(isnan(emoNum.floatValue)!=YES && emoNum.floatValue > 1)
            {
                NSLog(@"%@-----%f",emo,emoNum.floatValue);
            }
            
        }
//        其他类似的判断条件
//        ...
    }
}

#pragma ImagePickerMethods

//imagePickerDelegate的方法实现
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.ImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.ImageView setImage:self.image];
    self.discern.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.emotionArray = @[@"anger",@"contempt",@"disgust",@"fear",@"joy",@"sadness",@"surprise"];
}


@end
