//
//  FTAPIJobDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobDetailDataObject.h"


@class FTAPIJobDataObject;

@protocol FTAPIJobDataObjectDelegate <NSObject>

- (void)jobDataObject:(FTAPIJobDataObject *)object didFinishLoadingJobDetail:(FTAPIJobDetailDataObject *)detail;

@end


@interface FTAPIJobDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *fullColor;
@property (nonatomic, strong, readonly) UIColor *realColor;
@property (nonatomic) BOOL animating;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) FTAPIJobDetailDataObject *jobDetail;

@property (nonatomic, weak) id <FTAPIJobDataObjectDelegate> delegate;


@end
