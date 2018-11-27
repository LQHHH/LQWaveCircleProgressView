# Swift之水波效果

![2.jpg](https://upload-images.jianshu.io/upload_images/1411806-fe65b8115fe660bb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/650/format/webp)


>水波的效果其实现在的App上比较常见，网上也有很多例子，大家都有自己比较习惯的写法
>这里我也尝试用Swift写了一个水波进度的demo,和大家一起分享一下
>下面请先看效果图：

![1.gif](https://upload-images.jianshu.io/upload_images/1411806-fa655074e70a7c7a.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/200/format/webp)
##知识点分析

> 1.首先就是波浪的形状，是不是忽然感觉很熟悉但是又想不起来，其实就是大家上学时很早就会的公式---> y=Asin(ωx+φ)+B，没错，就是正弦函数，我们先来简单复习下每个参数的含义：

* A:振幅，就是波峰的高度

* ω:角速度，单位时间震动的次数

* φ:初相，x=0的时候的相位

* B:偏距，在坐标系上就是图像的上下移动的一个反映

> 2.有了这个函数之后，我们需要构建出来一个这样的曲线，然后还需要让他动起来，这就需要UIBezierPath和CADisplayLink的相助了
> 3.水浪随着进度上升，在这里我们简单的用一下核心动画CoreAnimaiton，当然还需要用到经常和动画以及路径打交道的CAShaperLayer
> 这样我们对需要用到的知识点进行了简单的分析，我封装了一个LQWaveCircleProgressView继承自UIView，下面着重来看下代码的具体实现

### 先来具体分析绘制曲线的代码

```

private func path() -> UIBezierPath{

 /*先初始化路径path*/

 let path = UIBezierPath()

 /*获取当前view的宽高*/

 let width = self.bounds.size.width

 let height = self.bounds.size.width

 /*初始化保存最后x的值得变量*/

 var lastX = 0

 /*for循环当前View宽度下的每一个x轴的点，在利用公式y=Asin(ωx+φ)+B计算出y的值*/

 for x in 0...Int(width) {

 /*这里我们计算ωx+φ的值，使用a去保存这个值，这里的角速度的值可以自己调整变换，self.phase是个变量，用来控制出现的值不断的变换，当然这里的计算也要注意角度和距离之前的换算，2π、width,计算单位距离带边的度数*/

 let a = 2*Double.pi/Double(width)*Double(x)*0.8+Double(self.phase)*2*Double.pi/Double(width)

 /*y则是通过公式进行简单的计算得出*/

 let y = Double(height)*0.05*sin(a) + Double(height)*0.05

 /如果x==0,这个时候先移动到第一个点，后面则是相邻点之前的连线，进而勾勒出形状/

 if x == 0 {

 path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))

 }

 else{

 path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))

 }

 lastX = x

 /*下面这段代码是让显示的进度文本随着波浪的波峰和波谷动起来*/

 if self.progress < 1.0 {

 self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.waveSinLayer.position.y-self.bounds.size.height/2+CGFloat(y)/2)

 }

 else {

 self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2+CGFloat(y)/2)

 }

 }

 /*for循环结束之后，然后把最后的位置和底部的位置都连接起来*/

 path.addLine(to: CGPoint(x: CGFloat(lastX), y: height))

 path.addLine(to: CGPoint(x: 0, y: height))

 /*这样最后的path完成了*/

 return path

 }

```

### path构建完成后，我们需要创建一个CAShaperLayer来接受这个path,然后还要曲线浪起来，这个时候就需要用到CADisplayLink，iOS设备的屏幕每秒会刷新60次，每次刷新都会调用，精度很高

```

/*创建CADisplayLink对象并且注册到runloop*/

let displayLink = CADisplayLink.init(target: self, selector: #selector(updateUI))

displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

@objc private func updateUI(){

 /不断的去变化self.phase,达到初像不段变化的目的/  

 let scale = self.bounds.size.width / 200.0

 self.phase += 5.0*scale

 /然后把path添加给当前的layer/

 self.waveSinLayer.path = self.path().cgPath

 }

```

### 最后让波浪随着进度上升，用个简单的动画去实现

```

private func creatAnimation() {

 let position = CGPoint(x: self.waveSinLayer.position.x, y: (1.5-self.progress)*self.bounds.size.height)

 let fromPosition = self.waveSinLayer.position

 self.waveSinLayer.position = position

 let animation = CABasicAnimation.init(keyPath: "position")

 animation.fromValue = NSValue(cgPoint: fromPosition)

 animation.toValue = NSValue(cgPoint: position)

 animation.duration = 0.25

 animation.isRemovedOnCompletion = false

 animation.fillMode = .forwards

 self.waveSinLayer.add(animation, forKey:nil)

 UIView.animate(withDuration: 0.25, animations: {

 self.percentL.center = CGPoint(x: self.bounds.size.width/2, y: self.waveSinLayer.position.y-self.bounds.size.height/2)

 }) { (finished) in

 self.percentL.text = String(format: "%.f%@", arguments: [self.progress*100,"%"])

 }

 }

```

