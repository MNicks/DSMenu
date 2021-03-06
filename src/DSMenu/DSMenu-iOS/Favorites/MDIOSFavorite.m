//
//  MDIOSFavorite.m
//  DSMenu
//
//  Created by Jonas Schnelli on 22.10.14.
//  Copyright (c) 2014 include7. All rights reserved.
//

#import "MDIOSFavorite.h"
#import "MDDSSManager.h"
#import "MDDSHelper.h"

@implementation MDIOSFavorite


- (BOOL)isEqual:(id)object
{
    MDIOSFavorite *fav = (MDIOSFavorite *)object;
    
    if([self.zone isEqualToString:fav.zone] && ([self.group isEqualToString:fav.group] || (self.group == nil &&  fav.group == nil)) && ([self.scene isEqualToString:fav.scene] || (self.scene == nil && fav.scene == nil)) && self.favoriteType == fav.favoriteType)
    {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %d %@", self.zone, self.group, self.scene, self.favoriteType, self.UUID];
}

- (NSString *)title
{
    if(self.favoriteType == MDIOSFavoriteTypeZonePreset)
    {
        return NSLocalizedString(([NSString stringWithFormat:@"group%@scene%@", self.group, self.scene]), @"");
    }
    
    return [MDDSHelper nameForZone:self.zone];
}

- (NSString *)subtitle
{
    if(self.favoriteType == MDIOSFavoriteTypeZone)
    {
        return NSLocalizedString(([NSString stringWithFormat:@"group%@OnOff", self.group]), @"");
    }
    else
    {
        NSDictionary *json = [MDDSSManager defaultManager].lastLoadesStructure;
        if(json && [json objectForKey:@"result"] && [[json objectForKey:@"result"] objectForKey:@"apartment"])
        {
            NSArray *zones = [[[json objectForKey:@"result"] objectForKey:@"apartment"] objectForKey:@"zones"];
            for(NSDictionary *aZoneDict in zones)
            {
                if([[(NSNumber *) [aZoneDict objectForKey:@"id"] stringValue] isEqualToString:self.zone])
                {
                    return [aZoneDict objectForKey:@"name"];
                }
            }
        }
        
        return [NSString stringWithFormat:@"zone: %@", self.zone];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.favoriteType       = [coder decodeIntForKey:@"favoriteType"];
        self.zone               = [coder decodeObjectForKey:@"zone"];
        self.group              = [coder decodeObjectForKey:@"group"];
        self.scene              = [coder decodeObjectForKey:@"scene"];
        self.UUID               = [coder decodeObjectForKey:@"UUID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.favoriteType      forKey:@"favoriteType"];
    [coder encodeObject:self.zone           forKey:@"zone"];
    [coder encodeObject:self.group          forKey:@"group"];
    [coder encodeObject:self.scene          forKey:@"scene"];
    [coder encodeObject:self.UUID           forKey:@"UUID"];
}


@end
