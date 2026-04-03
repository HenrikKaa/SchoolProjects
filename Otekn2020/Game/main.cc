#include <QApplication>
#include <QStyle>
#include <QDesktopWidget>
#include "../CourseLib/graphics/simplemainwindow.hh"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Q_INIT_RESOURCE(offlinedata);
	CourseSide::SimpleMainWindow w;

	w.show();

	w.setGeometry(
		QStyle::alignedRect(
			Qt::LeftToRight,
			Qt::AlignCenter,
			w.size(),
			qApp->desktop()->availableGeometry()
		)
	);

    return a.exec();
}
