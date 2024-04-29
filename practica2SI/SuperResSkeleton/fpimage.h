#ifndef FPIMAGE_H
#define FPIMAGE_H


#include <QMainWindow>


namespace Ui {
class FPImage;
}

class FPImage : public QMainWindow
{
    Q_OBJECT
    
public:

    explicit FPImage(QWidget *parent = 0);
    ~FPImage();
    
private:

    Ui::FPImage *ui;

    QString Path;         // Para recordar la carpeta al cargar imágenes
    QString BaseName;     // Nombres de los archivos a manejar
    QImage LowRes;
    uchar *pixR, *pixG, *pixB;

    int Wlow, Hlow;       // Ancho y alto de una imagen LowRes
    int Slow;             // "Step" (bytes por línea) de una imagen LowRes


private slots:

    void Load(void);    // Slot para el botón de carga de imagen de baja resolución
    void DoIt(void);    // Slot para el botón de construir la imagen de alta resolución

};



#endif // FPIMAGE_H
