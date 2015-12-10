//
//  SGRuntimeHeader.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#ifndef SGRuntimeHeader_h
#define SGRuntimeHeader_h

#import <objc/runtime.h>
#define OBJC_ASSOCIATED(property, setProperty, policy) \
-(id)property {\
return objc_getAssociatedObject(self, @selector(property));\
}\
- (void)setProperty:(id)property {\
objc_setAssociatedObject(self, @selector(property), property, policy);\
}

#endif /* SGRuntimeHeader_h */
