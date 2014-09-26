/*
 * Copyright (c) 2012-2013 Adam Debono. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    GMSMapView *mapView_;
    UINavigationBar *navbar;
}


- (void)viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    
    ADSlidingViewController *slidingViewController = [self slidingViewController];
	
	[slidingViewController setLeftViewAnchorWidth:300];
	[slidingViewController setRightViewAnchorWidth:300];
	
	[slidingViewController setLeftViewAnchorWidthType:1];
	[slidingViewController setRightViewAnchorWidthType:1];
	
	[slidingViewController setLeftMainAnchorType:0];
	[slidingViewController setRightMainAnchorType:0];
	
	[slidingViewController setLeftUnderAnchorType:0];
	[slidingViewController setRightUnderAnchorType:0];
	
	[slidingViewController setUndersidePersistencyType:0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    
    [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
    //creamos la navigation bar
    
    
    navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    //Colocamos imagen de fondo
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"barra1"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem * navItem = [[UINavigationItem alloc] initWithTitle:@"Jodete"];
    
    //
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flechaAtras"] style:UIBarButtonItemStylePlain target:self action:@selector(volverAlHome)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gpsIcono"] style:UIBarButtonItemStylePlain target:self action:@selector(centrarMapa)];
    
    navItem.leftBarButtonItem = leftButton;
    navItem.rightBarButtonItem = rightButton;
    
    navbar.tag = 21;
    
    navbar.items = [NSArray arrayWithObject:navItem];
    
    
    //Agregamos la navbar al un subview
    [self.view addSubview:navbar];
    
   	

}

-(void)volverAlHome
{

    [[self slidingViewController] anchorTopViewTo:ADAnchorSideRight];

}

-(void)centrarMapa
{
    [[self slidingViewController] anchorTopViewTo:ADAnchorSideLeft];
}
- (IBAction)leftBarButton:(UIBarButtonItem *)sender {
	[[self slidingViewController] anchorTopViewTo:ADAnchorSideRight];
}

- (IBAction)rightBarButton:(UIBarButtonItem *)sender {
	[[self slidingViewController] anchorTopViewTo:ADAnchorSideLeft];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        mapView_.frame = CGRectMake(0, 0, 768, 1024);
        navbar.frame = CGRectMake(0, 0, 768, 30);
    }
    else
    {
        
        mapView_.frame = CGRectMake(0, 0, 1024, 768);
        navbar.frame = CGRectMake(0, 0, 1024, 30);
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if((fromInterfaceOrientation == UIInterfaceOrientationPortrait) ||
       (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        NSLog(@"Portrait");
        //mapView_.frame = CGRectMake(0, 0, 1024, 768);
    }
    else
    {
        NSLog(@"Landscape");
        //mapView_.frame = CGRectMake(0, 0, 768, 1024);
    }
}


- (void)viewDidUnload {

	[super viewDidUnload];
}
@end
