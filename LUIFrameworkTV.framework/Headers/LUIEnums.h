//
//  LUIEnums.h
//
//  Created by Ondrej Rafaj on 17/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#ifndef LUIFramework_LUIEnums_h
#define LUIFramework_LUIEnums_h


typedef NS_ENUM(NSInteger, LUIDataType) {
    LUIDataTypeTranslations,
    LUIDataTypeImages,
    LUIDataTypeColors
};

typedef NS_ENUM(NSInteger, LUIBuild) {
    LUIBuildStaging = -1,
    LUIBuildLive = 0,
};

typedef NS_ENUM(NSInteger, LUIDataSource) {
    LUIDataSourceLocal,
    LUIDataSourceRemote,
    LUIDataSourceCustom
};


#endif
