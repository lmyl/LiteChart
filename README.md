# LiteChart

A lightweight data visualization chart framework for the iOS platform. Developed by Swift, based on UIKit.

With a small amount of code, you can create charts that are beautifully displayed, smoothly animated, highly customizable and easy to transplant.

👉中文版[README_CN](https://github.com/lmyl/LiteChart/blob/master/README_CN.md)

- [Features](#功能)
- [Environment](#环境)
- [Installation](#配置)
- [Usage](#使用方法)
- [Contact](#联系我们)

## Features
* Wide coverage. Currently supports seven types of charts, including commonly used radar charts, bubble charts, scatter charts, line charts, bar charts, pie charts and funnel charts;
* Smooth high-performance animation. Use asynchronous drawing to get high-performance animation;
* Support two kinds of animation. Currently supports basic animation and spring animation, but notice that the funnel chart, pie chart, line chart and radar chart do not support spring animation effects due to animation effects; the user can control the animation's pause, replay, resume and stop;
* Detailed user customization. In addition to the basic chart title, x-axis, y-axis, unit value, etc., you can also customize the reference line, the color configuration of each component, the legend style, the chart display direction, etc.;
* Extensive data support. Line graphs, scatter graphs, and bubble graphs support negative input, and there is no maximum data limit for all charts;
* Easy to use. Use declarative grammar, no need to care about the underlying code implementation, just assign the relevant attributes, you can complete the custom chart construction;
* Adapted to the dark mode. Call a suitable color initialization method to quickly configure the dark display of the chart.

|Radar chart|Bubble chart|Line chart|
|:----:|:----:|:-----:|
|![雷达图.png](https://github.com/lmyl/LiteChart/blob/master/Images/雷达图.png)|![气泡图.png](https://github.com/lmyl/LiteChart/blob/master/Images/气泡图.png)|![折线图.png](https://github.com/lmyl/LiteChart/blob/master/Images/折线图.png)|
|**Scatter chart**|**Bar chart**|**Pie chart**|
|![散点图.png](https://github.com/lmyl/LiteChart/blob/master/Images/散点图.png)|![柱状图.png](https://github.com/lmyl/LiteChart/blob/master/Images/柱状图.png)|![饼图.png](https://github.com/lmyl/LiteChart/blob/master/Images/饼图.png)|
|**Funnel chart**|
|![漏斗图.png](https://github.com/lmyl/LiteChart/blob/master/Images/漏斗图.png)|

## Environment

* iOS 13.0+

## Installation
### cocoa pods
To integrate LiteNetwork into your project using cocoaPods, specify it in your Podfile
```ruby
pod 'LiteChart'
```

## Usage
The frame chart is mainly composed of a drawing area and a chart area. The main content of the drawing area is the visualized data. It also includes a series of components surrounding the visualized data, such as the coordinate axis, the unit quantity of the coordinate axis, the axis title, and the reference line; the chart area includes the inner drawing area, the chart title, and the legend.

### 1⃣️create and configurate
Use Line charts as example:
1. initialize the line chart interface `LiteChartLineChartInterface`, enter the required data and axis title

⚠️ Note ⚠️:
   * check the reasonableness of the input data. The data requried in the line chart is an Array of tuples. The components of the tuple are: the color of polyline, the type of polyline, the legend shape corresponding to the polyline, and the corresponding data array in the polyline. The data array can be a mixture of positive and negative numbers, but please enter reasonable data to avoid errors, the framework only performs basic checks on your data; the count in the axis title array should be the same as the count in the input data array.
   * When creating a chart, read the corresponding interface files carefully.
   ```swift
   var lineInterface = LiteChartLineChartInterface
   (inputDatas: 
   [(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)),LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), 
   (LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151)), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), 
   (LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)),LineStyle.solidCubicBezierCurve, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], 
   coupleTitle: 
   ["Swift", "Python", "Java", "Ruby", "PHP"])
   ```
   
2. Perform a series of custom operations on the initialized line chart interface:
```swift
/*Configure components*/
lineInterface.inputLegendTitles = ["2019", "2020", "2021"] // Set the display content of the legend
lineInterface.underlayerColor = .init(lightColor: .dimGray)   // Set bottom layer line color
lineInterface.unitTextColor = .init(lightColor: .dimGray)     // Set the display color of the unit quantity
lineInterface.valueUnitString = "usage"                     
lineInterface.coupleUnitString = "language"                    
/*Control components' showing and hidding*/
lineInterface.isShowValueUnitString = true                 
lineInterface.isShowCoupleUnitString = true               
lineInterface.isShowValueDividingLine = true               
lineInterface.isShowCoupleDividingLine = true              
/*Set display mode*/
lineInterface.dividingValueLineStyle = .dotted             
lineInterface.dividingCoupleLineStyle = .solid             
lineInterface.displayDataMode = .original                 

```

3. Initialize the chart interface, the parameter here is an interface instance of line chart:
```swift
var interface = LiteChartViewInterface(contentInterface: lineInterface)
```
4. Perform a series of custom operations on the initialized chart interface(Note that these custom operations are displayed on the chart area)
```swift
interface.isShowChartTitleString = true 
interface.chartTitleString = "example"
interface.isShowLegendTitles = true
```

5. Instantiate the chart using LiteChartView:
```swift
let chartView = try! LiteChartView(interface: interface)
```

6. Set frame of the chart and add it to the view(We use snpKit to adjust frame here)
```swift
chartView.snp.updateConstraints{
     make in
     make.width.equalToSuperview()
     make.center.equalToSuperview()
     make.height.equalTo(300)
}
self.view.addSubview(chartView)
```

The final chart is:
![截屏2020-11-24 下午1.52.46.png](https://github.com/lmyl/LiteChart/blob/master/Images/折线图展示示例.png)

### 2⃣️Animation addition and use
To achieve animation display and user control, you need to:
1. Instantiate LiteChartAnimationInterface and configure parameters according to your requirements.
```swift
let interface = LiteChartAnimationInterface(
                 animationType: .base(duration: 4),       // Set the type of animation
                 delay: 0, 
                 fillModel:.both, 
                 animationTimingFunction: .init(name: .easeInEaseOut))
```
2. call startAnimation method of LiteChartView and pass parameters to start the animation:
```swift
// use the interface created before as an example
chartView.startAnimation(animation: interface)
```
3. call pauseAnimation to pause the animation:
```swift
chartView.pauseAnimation()
```
4. call continueAnimation to continue the animation:
```swift
chartView.continueAnimation()
```
5. call stopAnimation to stop the animation immedately: 
```swift
chartView.stopAnimation()
```
Line chart animation:
![动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/折线图动图.gif)
Other kinds of animations instruction：
|Radar chart|Bubble chart|Scatter chart|
|:----:|:----:|:-----:|
|![雷达图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/雷达图动图.gif)|![气泡图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/气泡图动图.gif)|![散点图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/散点图动图.gif)|

|Pie chart|Funnel chart|Bar chart|
|:----:|:----:|:-----:|
|![饼图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/饼图动图.gif)|![漏斗图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/漏斗图动图.gif)|![柱状图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/柱状图动图.gif)|

### 3⃣️ chart basic properties instruction
|Proerty name|Property type|Description|Value range|
|:----|:----|:----|:----|
|inputDatas|Array|A set of data that matched the corresponding chart|Any satisfied array|
|borderStyle|LiteChartViewBorderStyle|Boundary type of drawing area|.halfSurrounded, .fullySurrounded|
|dividingValueLineStyle|AxisViewLineStyle|the type of dividing lines|.solid, .dotted,.segment|
|displayDataMode|ChartValueDisplayMode|Date value display mode|.original, .percent,.mix, .none|
|valueUnitString/coupleUnitString|String|Unit quantity displayed in the middle of the coordinate axis|Any valid String|
|underlayerColor|LiteChartDarkLightColor|The color of the line drawn on the bottom layer|Colors in the frame's color library|
|animationType|LiteChartAnimationType|Type of animation displayed by the chart|.base, .spring|

## Contact

**GitHub issue tracker**: [issue tracker](https://github.com/lmyl/LiteNetwork/issues) ( report bug here )

**Google email**: `1269458422ly@gmail.com` or `hxh0804@gmail.com` ( if you have any questions or suggestions, contact us)
