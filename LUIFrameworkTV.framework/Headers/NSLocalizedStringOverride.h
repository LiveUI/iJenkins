//
//  NSLocalizedStringOverride.h
//
//  Created by Ondrej Rafaj on 31/05/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//


#import <LUIFramework/LUIFramework.h>


#ifndef LUIFramework_NSLocalizedStringOverride_h
#define LUIFramework_NSLocalizedStringOverride_h



// Undefining NSLocalizedString
#ifdef NSLocalizedString
#undef NSLocalizedString
#endif

// NSLocalizedString now points to LUILocalizedString
#define NSLocalizedString(key, comment)         LUILocalizedString(key, comment)



#endif
