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

    QString Path;               // Para recordar la carpeta al cargar imágenes
    QImage Image;               // Imagen Qt
    uchar *pixR, *pixG, *pixB, *pixCopia, *nR, *nG, *nB;  // Punteros a los tres canales R, G y B
    int W, H;                   // Tamaño de la imagen actual
    int S, Padding;                // Step en imágenes no continuas
    float pendiente;
    float n;
    int b;
    int label;
    int borde;
    int dimEE;
    uchar *mask;
    int *labelling;
    int NPix, Perim;
    int Area [1000];
    int Perims [1000];
    int Ymin, Ymax, Xmin, Xmax, AH, AW;
    float AR;
    float C;
    int Rpiel, Rdesv, Gpiel, Gdesv, Bpiel, Bdesv;
    uchar Lpiel, Hpiel, Spiel, Ldesv, Hdesv, Sdesv;
    int histoR[256]; int histoG[256]; int histoB[256];
    QPixmap Dib1, Dib2, Dib3;   // Tres lienzos en los que dibujar

    void ShowIt(void);          // Muestra la imagen actual
    void Histo();

    bool eventFilter(QObject *Ob, QEvent *Ev);  // Un "filtro de eventos"

private slots:
    void Load(void);    // Slot para el botón de carga de imagen
    void DoIt(void);    // Slot para el botón de hacer algo con la imagen
    void restore(void);
    void on_bBW_clicked();
    void on_sBrillo_valueChanged(int value);
    void on_sContraste_valueChanged(int contraste);
    void valueChanged();
    void pBordes();
    void on_sBordes_valueChanged(int value);
    void on_bStretch_clicked();
    void on_bEcualizar_clicked();
    void on_bPiel_clicked();
    void RGB2LHS (uchar r, uchar g, uchar b, uchar &L, uchar &H, uchar &S);
    void on_Rpiel_valueChanged(int value);
    void on_Rdesv_valueChanged(int value);
    void on_Gpiel_valueChanged(int value);
    void on_Gdesv_valueChanged(int value);
    void on_Bpiel_valueChanged(int value);
    void on_Bdesv_valueChanged(int value);
    void Filtrar(int dim, int tipo);
    void on_bFiltrar_clicked();
    void on_bErosion_clicked();
    void on_bDilatacion_clicked();
    void on_sDim_valueChanged(int value);
    void ShowMask();
    void PutLabel(int x, int y);

    void on_bEtiquetar_clicked();
};

#endif // FPIMAGE_H
