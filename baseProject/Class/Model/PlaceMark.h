//
//  PlaceMark.h
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"
#import "BMapKit.h"

@interface PlaceMark : NSObject <BMKAnnotation> {

	CLLocationCoordinate2D coordinate;
	Place* place;
	NSInteger mTag;
	NSInteger fl;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) Place* place;
@property (nonatomic, assign) NSInteger mTag;
@property (nonatomic, copy) NSString *leftImgStr;

-(id) initWithPlace: (Place*) p;

@end
