Qt and Metal
============

This example shows how to combine Metal and Qt by using
a QWindow instance to control a MTKView instance. The QWindow
can be shown as a top-level window or embedded as a child of
another window.

Shaders are compiled using custom qmake targets. The compiled
shader library is embedded in the executable as a Qt resource.

```C++

MTKView *view = [[[MTKView alloc] init] autorelease];
(Metal view setup omitted)

window = QWindow::fromWinId((WId)view);
window->resize(640, 480);
window->show();

```

![QWindow with MTKView](https://user-images.githubusercontent.com/296277/29745576-ed0f2e34-8abe-11e7-9088-b6ca163c1bff.png?s=263)
