# LiteChart
使用Swift开发，基于UIKit、面向iOS平台的轻量级数据可视化图表框架。
只需少量代码，即可创建显示精美、动画流畅、高度自定义且易于移植的图表。

- [功能](#功能)
- [环境](#环境)
- [配置](#配置)
- [使用方法](#使用方法)
- [联系我们](#联系我们)



## 功能
* 覆盖面广。目前支持七种类型的图表，包括常用的`雷达图`、`气泡图`、`散点图`、`折线图`、`柱状图`、`饼图`和`漏斗图`；
* 高性能动画。使用异步动画绘制，动画效果流畅；
* 支持两种动画类型。目前支持基础动画和弹簧动画，但漏斗图、饼状图、折线图、雷达图出于动画效果的考虑，不支持弹簧动画效果；用户可控制动画的暂停、重播、继续和结束控制；
* 细致的用户自定义。除了基本的图表标题、x轴y轴、单位值等，还可以自定义参考线、各组件颜色配置、图例样式、图表显示方向等等；
* 广泛的数据支持。折线图、散点图、气泡图支持负数输入，所有图表没有最大数据量限制；
* 简便的使用方法。使用声明式语法，无需关心底层代码实现，只需赋值相关属性，即可完成自定义图表构建；
* 颜色适配暗黑模式。调用合适的颜色初始化方法，快捷配置图表的暗黑显示。


|雷达图|气泡图|折线图|
|:----:|:----:|:-----:|
|![雷达图.png](https://github.com/lmyl/LiteChart/blob/master/Images/雷达图.png)|![气泡图.png](https://github.com/lmyl/LiteChart/blob/master/Images/气泡图.png)|![折线图.png](https://github.com/lmyl/LiteChart/blob/master/Images/折线图.png)|
|**散点图**|**柱状图**|**饼图**|
|![散点图.png](https://github.com/lmyl/LiteChart/blob/master/Images/散点图.png)|![柱状图.png](https://github.com/lmyl/LiteChart/blob/master/Images/柱状图.png)|![饼图.png](https://github.com/lmyl/LiteChart/blob/master/Images/饼图.png)|
|**漏斗图**|
|![漏斗图.png](https://github.com/lmyl/LiteChart/blob/master/Images/漏斗图.png)|


## 环境
* iOS 13.0+

## 配置
### cocoa pods
在您项目的podfile文件中添加声明
```ruby
pod 'LiteChart'
```

## 使用方法
框架图表主要由绘图区和图表区组成。绘图区的主要内容是可视化的数据，还包括了坐标轴、坐标轴单位量、轴标题、参考线等围绕可视化数据的一系列组件；图表区包括内层的绘图区和图表标题、图例。

### 1⃣️ 图表创建和配置
以折线图为示例，使用方法如下：
1. 初始化折线图接口`LiteChartLineChartInterface`，输入符合要求的数据和轴标题（显示在对应数据坐标轴的下方）
   ⚠️注意⚠️：
    * **检查输入数据的合理性。** 在折线图中要求的数据为一个元组数组。元组的组成部分有：该条折线的颜色，折线的类型，折线对应的图例形状，折线中对应的数据数组。数据数组可以为正负数混合，但请输入合理数据以免报错，框架仅对您的数据做基础检查；轴标题数组的元素个数应与输入的数据数组的元素个数相同。
    * **创建图表时，仔细阅读相应的接口文件。**
```swift
var lineInterface = LiteChartLineChartInterface
(inputDatas: 
[(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)),LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), 
(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151)), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), 
(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)),LineStyle.solidCubicBezierCurve, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], 
coupleTitle: 
["Swift", "Python", "Java", "Ruby", "PHP"])

```

2. 对初始化的折线图接口进行一系列自定义操作；
```swift
/*配置组件属性*/
lineInterface.inputLegendTitles = ["2019", "2020", "2021"] // 设置图例的显示内容
lineInterface.underlayerColor = .init(lightColor: .dimGray)   // 设置底层参考线颜色
lineInterface.unitTextColor = .init(lightColor: .dimGray)     // 设置单位量的显示颜色
lineInterface.valueUnitString = "usage"                     // 设置数据单元的单位量
lineInterface.coupleUnitString = "language"                    // 设置轴单元的单位量
/*控制组件的显示与隐藏*/
lineInterface.isShowValueUnitString = true                 // 是否显示数据单元的单位量
lineInterface.isShowCoupleUnitString = true                // 是否显示轴单元的单位量
lineInterface.isShowValueDividingLine = true               // 是否显示值分割线
lineInterface.isShowCoupleDividingLine = true              // 是否显示轴分割线
/*设置显示类型*/
lineInterface.dividingValueLineStyle = .dotted             // 值分割线类型
lineInterface.dividingCoupleLineStyle = .solid             // 轴分割线类型
lineInterface.displayDataMode = .original                  // 数值显示的类型

```
3. 初始化图表接口，这里的参数为一个子图表的接口实例；
```swift
var interface = LiteChartViewInterface(contentInterface: lineInterface)
```
4. 对初始化的图表接口进行一系列自定义操作（这些自定义操作是展现在图表区上的）；
```swift
interface.isShowChartTitleString = true                    // 是否显示图表标题
interface.chartTitleString = "example"                     // 设置图表标题的内容
interface.isShowLegendTitles = true                         // 是否显示图例
```
5. 实例化图表`LiteChartView`；
```swift
let chartView = try! LiteChartView(interface: interface)
```

6. 设定图表frame，并将其添加到视图上（这里使用了`snpKit`框架来调整框架约束）
```swift
chartView.snp.updateConstraints{
     make in
     make.width.equalToSuperview()
     make.center.equalToSuperview()
     make.height.equalTo(300)
}
self.view.addSubview(chartView)
```
实现的效果：
![截屏2020-11-24 下午1.52.46.png](https://github.com/lmyl/LiteChart/blob/master/Images/折线图展示示例.png)

### 2⃣️ 动画的添加和使用
要实现动画的展示和用户控制，您需要
1. 实例化LiteChartAnimationInterface，根据您的需求配置参数；
```swift
let interface = LiteChartAnimationInterface(
                 animationType: .base(duration: 4),       // 设定动画的类型
                 delay: 0, 
                 fillModel:.both, 
                 animationTimingFunction: .init(name: .easeInEaseOut))
```
2. 调用LiteChartView的startAnimation方法并传递参数，开始动画

```swift
// 使用上文创建的chartView实例作为例子
chartView.startAnimation(animation: interface)
```
3. 调用pauseAnimation方法暂停动画；
```swift
chartView.pauseAnimation()
```
4. 调用continueAnimation方法继续动画
```swift
chartView.continueAnimation()
```
5. 调用stopAnimation 方法立刻结束动画
```swift
chartView.stopAnimation()
```
动画效果示例：
![折线图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/折线图动图.gif)
其他动画效果示例：
|雷达图|气泡图|散点图|
|:----:|:----:|:-----:|
|![雷达图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/雷达图动图.gif)|![气泡图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/气泡图动图.gif)|![散点图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/散点图动图.gif)|

|饼图|漏斗图|柱状图|
|:----:|:----:|:-----:|
|![饼图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/饼图动图.gif)|![漏斗图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/漏斗图动图.gif)|![柱状图动图.gif](https://github.com/lmyl/LiteChart/blob/master/Images/柱状图动图.gif)|


### 3⃣️ 主要属性说明
|属性名称|属性类型|描述|取值范围|
|:----|:----|:----|:----|
|inputDatas|Array|符合对应图表的一组数据输入|任意满足接口定义类型的数组|
|borderStyle|LiteChartViewBorderStyle|绘图区的边界类型，全包围或半包围|.halfSurrounded, .fullySurrounded|
|dividingValueLineStyle|AxisViewLineStyle|分割线的样式，折线、虚线或无线|.solid, .dotted,.segment|
|displayDataMode|ChartValueDisplayMode|数据值的显示模式，普通、百分号、混合或不显示|.original, .percent,.mix, .none|
|valueUnitString/coupleUnitString|String|显示在坐标轴中部位置的单位量|任意有效字符串|
|underlayerColor|LiteChartDarkLightColor|底层绘制的线的颜色|框架内置颜色库中的颜色|
|animationType|LiteChartAnimationType|图表显示的动画类型，基础或弹簧式|.base, .spring|

## 联系我们

**GitHub issue tracker**: [issue tracker](https://github.com/lmyl/LiteChart/issues) ( 提出错误和改进 )

**Google 邮箱**: `1269458422ly@gmail.com` or `hxh0804@gmail.com` ( 如果有任何建议和问题，欢迎联系我们)



