//
//  NSLogOverride.h
//
//  Created by Ondrej Rafaj on 16/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#ifndef LUIFramework_NSLogOverride_h
#define LUIFramework_NSLogOverride_h

#import <LUIFramework/LUIDebugger.h>



// Undefining NSLocalizedString
#ifdef NSLog
#undef NSLog
#endif


#define NSLog(args...)              LUILogFull(__FILE__, __LINE__, __PRETTY_FUNCTION__, args)



#endif
