#include <QtGui>

#include <hellotriangle/AAPLRenderer.h>

int main(int argc, char **argv)
{
    // This example demonstrates how to integreate Metal rendering
    // with Qt by controlling a Metal view using QWindow. The Metal
    // part of the example is copied from the hellotriangle example.

    QGuiApplication app(argc, argv);
    QWindow *window = nullptr;
    AAPLRenderer *renderer = nil;

    // Create UI after event loop has started.
    QTimer::singleShot(0, [&window, &renderer]() {

        // Create Metal view and default device
        MTKView *view = [[[MTKView alloc] init] autorelease];
        view.device = MTLCreateSystemDefaultDevice();
        if (!view.device)
            qFatal("Metal is not supported");

        // Load shaders from Qt resources
        QFile shadersFile(":/hellotriangleshaders.metallib");
        shadersFile.open(QIODevice::ReadOnly);
        QByteArray shaders = shadersFile.readAll();
        dispatch_data_t data = dispatch_data_create(shaders.constData(), shaders.size(),
                               dispatch_get_main_queue(), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
        NSError *error = nil;
        id <MTLLibrary> library = [view.device newLibraryWithData:data error:&error];
        if (error)
            qWarning() << "Shader Error" << error;

        // Create Renderer
        renderer = [[AAPLRenderer alloc] initWithMetalKitView:view library:library];
        [renderer mtkView:view drawableSizeWillChange:view.drawableSize];
        view.delegate = renderer;

        // Create and show Qt Window which controls the metal view
        window = QWindow::fromWinId((WId)view);
        window->setTitle("QWindow with MTKView");
        window->resize(640, 480);
        window->show();
    });

    // Start the event loop
    int code = app.exec();

    // Clean up on exit. The MTKView is owned by the QWindow and need not be released.
    delete window;
    [renderer release];

    return code;
}