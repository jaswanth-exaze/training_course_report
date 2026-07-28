# Flutter Animations

Animations make apps feel smooth, responsive, and polished.

---

## Implicit Animations

Animations that automatically transition between two states.

### AnimatedContainer:

```dart
class AnimatedContainerExample extends StatefulWidget {
  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          width: _expanded ? 200 : 100,
          height: _expanded ? 200 : 100,
          color: _expanded ? Colors.blue : Colors.red,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Center(
            child: Text("Animate"),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Text("Toggle"),
        ),
      ],
    );
  }
}
```

### AnimatedOpacity:

```dart
class AnimatedOpacityExample extends StatefulWidget {
  @override
  State<AnimatedOpacityExample> createState() =>
      _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
            });
          },
          child: Text("Toggle"),
        ),
      ],
    );
  }
}
```

### Other Implicit Animations:

```dart
// AnimatedPadding
AnimatedPadding(
  padding: _isPadded ? EdgeInsets.all(20) : EdgeInsets.zero,
  duration: Duration(seconds: 1),
  child: Container(),
)

// AnimatedAlign
AnimatedAlign(
  alignment: _isCentered ? Alignment.center : Alignment.topLeft,
  duration: Duration(seconds: 1),
  child: Container(),
)

// AnimatedPositioned
Stack(
  children: [
    AnimatedPositioned(
      left: _isLeft ? 0 : 100,
      top: _isTop ? 0 : 100,
      duration: Duration(seconds: 1),
      child: Container(),
    ),
  ],
)

// AnimatedDefaultTextStyle
AnimatedDefaultTextStyle(
  style: _isBold ? TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  : TextStyle(fontSize: 16),
  duration: Duration(seconds: 1),
  child: Text("Animated Text"),
)

// AnimatedPhysicalModel
AnimatedPhysicalModel(
  shape: BoxShape.rectangle,
  elevation: _isElevated ? 8 : 0,
  color: Colors.white,
  shadowColor: Colors.black,
  duration: Duration(seconds: 1),
  child: Container(),
)
```

### Advanced Implicit Animations:

```dart
class ComplexAnimatedContainer extends StatefulWidget {
  @override
  State<ComplexAnimatedContainer> createState() => _ComplexAnimatedContainerState();
}

class _ComplexAnimatedContainerState extends State<ComplexAnimatedContainer> {
  bool _isExpanded = false;
  bool _isRounded = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          width: _isExpanded ? 300 : 150,
          height: _isExpanded ? 300 : 150,
          decoration: BoxDecoration(
            color: _isExpanded ? Colors.blue : Colors.red,
            borderRadius: BorderRadius.circular(_isRounded ? 75 : 0),
            boxShadow: _isExpanded ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ] : [],
          ),
          transform: _isExpanded 
            ? Matrix4.rotationZ(0.1) 
            : Matrix4.identity(),
          child: Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(
                _isExpanded ? "Expanded!" : "Tap me",
                key: ValueKey<bool>(_isExpanded),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isExpanded ? 24 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 20),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(_isExpanded ? "Shrink" : "Expand"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => setState(() => _isRounded = !_isRounded),
              child: Text(_isRounded ? "Square" : "Round"),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Explicit Animations with AnimationController

Manual control over animations using AnimationController.

### Basic AnimationController:

```dart
class ExplicitAnimationExample extends StatefulWidget {
  @override
  State<ExplicitAnimationExample> createState() => _ExplicitAnimationExampleState();
}

class _ExplicitAnimationExampleState extends State<ExplicitAnimationExample>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _startAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          color: Colors.blue.withOpacity(_animation.value),
        ),
        
        ElevatedButton(
          onPressed: _startAnimation,
          child: Text("Animate"),
        ),
      ],
    );
  }
}
```

### Multiple Animations:

```dart
class MultiAnimationExample extends StatefulWidget {
  @override
  State<MultiAnimationExample> createState() => _MultiAnimationExampleState();
}

class _MultiAnimationExampleState extends State<MultiAnimationExample>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _sizeAnimation = Tween<double>(
      begin: 100,
      end: 200,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.easeOut),
    ));
    
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: _sizeAnimation.value,
          height: _sizeAnimation.value,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(_sizeAnimation.value / 4),
          ),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Center(
              child: Text(
                "Animated",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: () {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
          child: Text("Animate"),
        ),
      ],
    );
  }
}
```

---

## Transitions

Smooth transitions between different UI states.

### Page Transitions:

```dart
class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  
  CustomPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

// Usage
Navigator.push(
  context,
  CustomPageRoute(page: SecondPage()),
);
```

### Fade Transition:

```dart
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  
  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
```

### Scale Transition:

```dart
class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  
  ScaleRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                ),
              ),
              child: child,
            );
          },
        );
}
```

### Custom Transition Builder:

```dart
class CustomTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        // Background animation
        FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 0.3).animate(animation),
          child: Container(color: Colors.black),
        ),
        
        // Main content animation
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

// In MaterialApp
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomTransitionBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  ),
)
```

---

## Hero Animation

Seamless transitions between screens for shared elements.

### Basic Hero:

```dart
class HeroExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(index: index),
              ),
            );
          },
          child: Hero(
            tag: 'hero_$index',
            child: Container(
              margin: EdgeInsets.all(8),
              color: Colors.blue,
              child: Center(
                child: Text('$index'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;
  
  const DetailPage({required this.index});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Hero(
          tag: 'hero_$index',
          child: Container(
            width: 300,
            height: 300,
            color: Colors.blue,
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Advanced Hero:

```dart
class AdvancedHeroExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Hero(
            tag: 'avatar_$index',
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('$index'),
            ),
          ),
          title: Text('Item $index'),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return DetailPage(index: index);
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;
  
  const DetailPage({required this.index});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'avatar_$index',
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(fontSize: 100, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(16),
                child: Text('Details for item $index'),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
```

### Hero with Flight Shuttle:

```dart
class HeroFlightShuttle extends StatelessWidget {
  final Animation<double> animation;
  final HeroFlightDirection flightDirection;
  final Object tag;
  final BuildContext fromHeroContext;
  final BuildContext toHeroContext;
  
  const HeroFlightShuttle({
    required this.animation,
    required this.flightDirection,
    required this.tag,
    required this.fromHeroContext,
    required this.toHeroContext,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.blue,
              Colors.red,
              animation.value,
            ),
            borderRadius: BorderRadius.circular(
              Tween<double>(begin: 0, end: 20).evaluate(animation),
            ),
          ),
          child: Center(
            child: Text(
              tag.toString().split('_').last,
              style: TextStyle(
                fontSize: Tween<double>(begin: 24, end: 48).evaluate(animation),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Usage
Hero(
  tag: 'hero_$index',
  flightShuttleBuilder: (
    flightContext,
    animation,
    flightDirection,
    fromHeroContext,
    toHeroContext,
  ) {
    return HeroFlightShuttle(
      animation: animation,
      flightDirection: flightDirection,
      tag: 'hero_$index',
      fromHeroContext: fromHeroContext,
      toHeroContext: toHeroContext,
    );
  },
  child: Container(...),
)
```

---

## Curves

Mathematical functions that define animation timing.

### Built-in Curves:

```dart
// Linear
Curves.linear

// Ease functions
Curves.ease
Curves.easeIn
Curves.easeOut
Curves.easeInOut

// Bounce
Curves.bounceIn
Curves.bounceOut
Curves.bounceInOut

// Elastic
Curves.elasticIn
Curves.elasticOut
Curves.elasticInOut

// Back
Curves.backIn
Curves.backOut
Curves.backInOut

// Cubic
Curves.fastOutSlowIn
Curves.slowMiddle

// Custom curve
class CustomCurve extends Curve {
  @override
  double transform(double t) {
    // Custom mathematical function
    return t * t * (3 - 2 * t); // Smooth step
  }
}
```

### Curve Combinations:

```dart
// Chained curves
CurvedAnimation(
  parent: _controller,
  curve: Curves.easeInOut,
)

// Interval curves
CurvedAnimation(
  parent: _controller,
  curve: Interval(0.0, 0.5, curve: Curves.easeIn),
)

// Saw tooth curve
class SawToothCurve extends Curve {
  final int count;
  
  const SawToothCurve(this.count);
  
  @override
  double transform(double t) {
    return (t * count) % 1.0;
  }
}

// Spring curve
class SpringCurve extends Curve {
  final double a;
  final double w;
  
  const SpringCurve(this.a, this.w);
  
  @override
  double transform(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}
```

---

## Staggered Animations

Animations that start at different times for a cascading effect.

### Basic Staggered Animation:

```dart
class StaggeredAnimationExample extends StatefulWidget {
  @override
  State<StaggeredAnimationExample> createState() => _StaggeredAnimationExampleState();
}

class _StaggeredAnimationExampleState extends State<StaggeredAnimationExample>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _animations = List.generate(5, (index) {
      final start = index * 0.2;
      final end = start + 0.2;
      
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
    
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _animations.length; i++)
          Opacity(
            opacity: _animations[i].value,
            child: Transform.translate(
              offset: Offset(0, (1 - _animations[i].value) * 50),
              child: Container(
                margin: EdgeInsets.all(8),
                height: 50,
                color: Colors.blue,
                child: Center(
                  child: Text('Item ${i + 1}'),
                ),
              ),
            ),
          ),
        
        ElevatedButton(
          onPressed: () {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
          child: Text("Animate"),
        ),
      ],
    );
  }
}
```

### Advanced Staggered Animation:

```dart
class AdvancedStaggeredAnimation extends StatefulWidget {
  @override
  State<AdvancedStaggeredAnimation> createState() => _AdvancedStaggeredAnimationState();
}

class _AdvancedStaggeredAnimationState extends State<AdvancedStaggeredAnimation>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
    
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: _slideAnimation.value * 200,
        child: Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Animated!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Custom Paint

Drawing custom graphics and animations.

### Basic Custom Paint:

```dart
class CustomPaintExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(),
      size: Size(200, 200),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

### Animated Custom Paint:

```dart
class AnimatedCustomPaint extends StatefulWidget {
  @override
  State<AnimatedCustomPaint> createState() => _AnimatedCustomPaintState();
}

class _AnimatedCustomPaintState extends State<AnimatedCustomPaint>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(_animation.value),
          size: Size(300, 200),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  
  WavePainter(this.progress);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height / 2);
    
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + 
                sin((x / size.width * 2 * pi) + (progress * 2 * pi)) * 30;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

### Complex Custom Animation:

```dart
class ParticleSystem extends StatefulWidget {
  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  final List<Particle> _particles = [];
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    // Create particles
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle.random());
    }
    
    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(_particles),
      size: Size(double.infinity, 400),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
  
  factory Particle.random() {
    return Particle(
      position: Offset(Random().nextDouble() * 400, Random().nextDouble() * 400),
      velocity: Offset(
        (Random().nextDouble() - 0.5) * 2,
        (Random().nextDouble() - 0.5) * 2,
      ),
      color: Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
      size: Random().nextDouble() * 10 + 5,
      life: Random().nextDouble() * 100 + 50,
    );
  }
  
  void update() {
    position += velocity;
    life--;
    
    // Bounce off edges
    if (position.dx < 0 || position.dx > 400) velocity = Offset(-velocity.dx, velocity.dy);
    if (position.dy < 0 || position.dy > 400) velocity = Offset(velocity.dx, -velocity.dy);
    
    // Reset if dead
    if (life <= 0) {
      position = Offset(Random().nextDouble() * 400, Random().nextDouble() * 400);
      life = Random().nextDouble() * 100 + 50;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  
  ParticlePainter(this.particles);
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life / 150)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return true;
  }
}
```

---

## Summary

- **Implicit Animations**: AnimatedContainer, AnimatedOpacity, and other automatic transitions
- **Explicit Animations**: AnimationController with manual control and multiple animations
- **Transitions**: Page transitions, fade, scale, and custom transition builders
- **Hero Animation**: Seamless element transitions between screens
- **Curves**: Built-in and custom animation timing functions
- **Staggered Animations**: Cascading animations with different start times
- **Custom Paint**: Drawing custom graphics and complex animations

Animations enhance user experience and make apps feel more polished and responsive.

// AnimatedAlign
AnimatedAlign(
  alignment: _isLeft ? Alignment.centerLeft : Alignment.centerRight,
  duration: Duration(seconds: 1),
  child: Container(),
)

// AnimatedDefaultTextStyle
AnimatedDefaultTextStyle(
  style: TextStyle(fontSize: _isBig ? 32 : 16),
  duration: Duration(seconds: 1),
  child: Text("Text"),
)

// AnimatedCrossFade
AnimatedCrossFade(
  firstChild: Container(color: Colors.red),
  secondChild: Container(color: Colors.blue),
  crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  duration: Duration(seconds: 1),
)

// TweenAnimatedBuilder
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 100),
  duration: Duration(seconds: 2),
  builder: (context, value, child) {
    return Padding(
      padding: EdgeInsets.only(left: value),
      child: child,
    );
  },
  child: Container(),
)
```

---

## Explicit Animations

Animations with more control using AnimationController.

### Basic AnimationController:

```dart
class AnimationControllerExample extends StatefulWidget {
  @override
  State<AnimationControllerExample> createState() =>
      _AnimationControllerExampleState();
}

class _AnimationControllerExampleState
    extends State<AnimationControllerExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,  // Synchronizes animation with screen refresh
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.5)
              .animate(_animationController),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_animationController.isAnimating) {
              _animationController.stop();
            } else {
              _animationController.forward();
            }
          },
          child: Text("Play"),
        ),
      ],
    );
  }
}
```

### Tween and Animation:

```dart
// Tween: interpolate between two values
final tween = Tween<Offset>(
  begin: Offset(0, 0),
  end: Offset(1, 0),
);

final animation = tween.animate(_animationController);

// Or with curve
final animation = tween.animate(
  CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ),
);

// Use in widget
SlideTransition(
  position: animation,
  child: Container(),
)
```

### Complex Sequences:

```dart
Future<void> _playSequence() async {
  // First: 0 to 0.5 seconds
  await _animationController.forward();
  
  // Then: immediately reverse
  await _animationController.reverse();
}

// Or use interval
class SequencedAnimation {
  final AnimationController _controller;

  SequencedAnimation({required AnimationController controller})
      : _controller = controller;

  late final Animation<double> opacity = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.ease),
    ),
  );

  late final Animation<double> scale = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.ease),
    ),
  );
}
```

---

## Built-in Transition Widgets

### SlideTransition:

```dart
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(-1, 0),
    end: Offset(0, 0),
  ).animate(_animationController),
  child: Container(),
)
```

### ScaleTransition:

```dart
ScaleTransition(
  scale: Tween<double>(begin: 0, end: 1)
      .animate(_animationController),
  child: Container(),
)
```

### FadeTransition:

```dart
FadeTransition(
  opacity: Tween<double>(begin: 0, end: 1)
      .animate(_animationController),
  child: Container(),
)
```

### RotationTransition:

```dart
RotationTransition(
  turns: Tween<double>(begin: 0, end: 1)
      .animate(_animationController),
  child: Container(),
)
```

### SizeTransition:

```dart
SizeTransition(
  sizeFactor: Tween<double>(begin: 0, end: 1)
      .animate(_animationController),
  child: Container(),
)
```

---

## Hero Animation

Animation that shares a widget between screens.

### Basic Hero:

```dart
// First screen
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen()),
    );
  },
  child: Hero(
    tag: 'image',
    child: Image.asset('assets/image.png', width: 100, height: 100),
  ),
)

// Second screen
Hero(
  tag: 'image',
  child: Image.asset('assets/image.png'),
)
```

### Custom Hero Animation:

```dart
class CustomHeroAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ScaleTransition(
                scale: animation,
                child: SecondScreen(),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'profile',
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('...'),
        ),
      ),
    );
  }
}
```

---

## Curves

Different easing curves for animations.

```dart
// Common curves
Curves.linear         // Constant speed
Curves.easeIn         // Starts slow, ends fast
Curves.easeOut        // Starts fast, ends slow
Curves.easeInOut      // Slow -> fast -> slow
Curves.elasticIn      // Elastic effect at start
Curves.elasticOut     // Elastic effect at end
Curves.bounceIn       // Bounces at start
Curves.bounceOut      // Bounces at end
Curves.decelerate     // Decelerate
Curves.fastOutSlowIn  // Material standard curve

// Custom curve
CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeInOut,
)
```

---

## Staggered Animation

Multiple animations at different times.

```dart
class StaggeredAnimationExample extends StatefulWidget {
  @override
  State<StaggeredAnimationExample> createState() =>
      _StaggeredAnimationExampleState();
}

class _StaggeredAnimationExampleState
    extends State<StaggeredAnimationExample> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First animation (0-1 seconds)
        StaggeredAnimationItem(
          controller: _controller,
          interval: Interval(0.0, 0.33),
          child: Container(color: Colors.red, width: 50, height: 50),
        ),
        SizedBox(height: 20),
        // Second animation (1-2 seconds)
        StaggeredAnimationItem(
          controller: _controller,
          interval: Interval(0.33, 0.66),
          child: Container(color: Colors.blue, width: 50, height: 50),
        ),
        SizedBox(height: 20),
        // Third animation (2-3 seconds)
        StaggeredAnimationItem(
          controller: _controller,
          interval: Interval(0.66, 1.0),
          child: Container(color: Colors.green, width: 50, height: 50),
        ),
      ],
    );
  }
}

class StaggeredAnimationItem extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  const StaggeredAnimationItem({
    required this.controller,
    required this.interval,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: interval,
        ),
      ),
      child: child,
    );
  }
}
```

---

## Animation Controller Options

```dart
// Forward
_animationController.forward();

// Reverse
_animationController.reverse();

// Repeat
_animationController.repeat();

// Loop with reverse
_animationController.repeat(reverse: true);

// Get status
if (_animationController.isAnimating) {
  print("Animating");
}
if (_animationController.isCompleted) {
  print("Completed");
}

// Listen to animation
_animationController.addListener(() {
  print("Animation progress: ${_animationController.value}");
});

// Add status listener
_animationController.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    // Animation finished
  }
});
```

---

## Custom Paint Animation

Complex animations with CustomPaint.

```dart
class CustomPaintAnimation extends StatefulWidget {
  @override
  State<CustomPaintAnimation> createState() => _CustomPaintAnimationState();
}

class _CustomPaintAnimationState extends State<CustomPaintAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AnimatedCirclePainter(_controller),
      size: Size(200, 200),
    );
  }
}

class AnimatedCirclePainter extends CustomPainter {
  final Animation<double> animation;

  AnimatedCirclePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * animation.value;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(AnimatedCirclePainter oldDelegate) => true;
}
```

---

## Performance Tips

1. **Use `const` animations** when possible
2. **Dispose controllers** in `dispose()`
3. **Use `SingleTickerProviderStateMixin`** for single animations
4. **Use `TickerProviderStateMixin`** for multiple animations
5. **Avoid expensive computations** in animation callbacks
6. **Profile animations** using DevTools
7. **Use `RepaintBoundary`** for optimization

---

## Summary

- **Implicit Animations**: Easy, automatic transitions
- **Explicit Animations**: More control with AnimationController
- **Transitions**: PrebuiltWidgets for common animations
- **Hero Animation**: Shared element transitions
- **Curves**: Different easing effects
- **Staggered Animations**: Multiple animations with timing
- **CustomPaint**: Complex custom animations
- Always dispose of controllers
- Profile and optimize animations
