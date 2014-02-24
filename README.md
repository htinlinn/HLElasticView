HLElasticView
============

HLElasticSnapView and HLElasticScaleView are UIView subclasses that support elastic snapping and scaling. It is inspired by UIScrollView's rubber band bouncing and [Facebook Paper](http://www.facebook.com/paper).

HLElasticViews take flick velocity into account and use [CADisplayLink](https://developer.apple.com/library/ios/documentation/QuartzCore/Reference/CADisplayLink_ClassRef/Reference/Reference.html) to update view positions and sizes. Spring and damping constants are defined in HLUtility.h and can be modified to change the elasticity.