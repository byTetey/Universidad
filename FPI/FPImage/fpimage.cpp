#include "fpimage.h"
#include "ui_fpimage.h"

#include <QFileDialog>
#include <QPainter>
#include <QtMath>
#include <QImage>
#include <algorithm>
#include <QDebug>

//--------------------------------------------------
//-- Filtro de eventos para capturar mouse clicks --
//--------------------------------------------------
bool FPImage::eventFilter(QObject *Ob, QEvent *Ev)
{
    // Comprobamos que el evento capturado es un  mouseclick
    if(Ev->type()==QEvent::MouseButtonPress) {
        // Comprobamos que el click ocurrió sobre nuestro QLabel
        if(Ob==ui->Ecran) {
            // Hacemos un cast del evento para poder acceder a sus propiedades
            const QMouseEvent *me=static_cast<const QMouseEvent *>(Ev);
            // Nos interesan las coordenadas del click
            int y=me->y(), x=me->x();
            // Si estamos fuera de la imagen, nos vamos
            if(y>=H||x>=W) return true;
            // Hacemos algo con las coordenadas y el píxel
            uchar L;
            uchar H;
            uchar S;
            RGB2LHS(pixR[(y*S+3*x)],pixG[(y*S+3*x)],pixB[(y*S+3*x)],L,H,S);
            statusBar()->showMessage(QString::number(x)+":"+
                                      QString::number(y)+" "+
                                      QString::number(pixR[(y*S+3*x)])+":"+
                                      QString::number(pixG[(y*S+3*x)])+":"+
                                      QString::number(pixB[(y*S+3*x)])+" "+
                                      QString::number(L)+":"+
                                      QString::number(H)+":"+
                                      QString::number(S));
            // Devolvemos un "true" que significa que hemos gestionado el evento
            QPainter w(&Dib1);
            QPainter v(&Dib2);
            QPainter u(&Dib3);
            w.setPen(QPen(Qt::white));
            v.setPen(QPen(Qt::white));
            u.setPen(QPen(Qt::white));


            w.drawPoint(pixR[(y*S+3*x)]*100/255, 100 - pixB[(y*S+3*x)]*100/255);
            v.drawPoint(pixR[(y*S+3*x)]*100/255, 100 - pixG[(y*S+3*x)]*100/255);
            u.drawPoint(pixG[(y*S+3*x)]*100/255, 100 - pixB[(y*S+3*x)]*100/255);
            ui->EcranHistoR->setPixmap(Dib1);
            ui->EcranHistoG->setPixmap(Dib2);
            ui->EcranHistoB->setPixmap(Dib3);
            return true;
        } else return false;  // No era para nosotros, lo dejamos en paz
    } else return false;
}

//-------------------------------------------------
//-- Constructor: Conexiones e inicializaciones ---
//-------------------------------------------------
FPImage::FPImage(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::FPImage)
{
    ui->setupUi(this);

    // CONEXIONES de nuestros objetos (botones, etc...) a nuestros slots
    connect(ui->BLoad,SIGNAL(clicked()),this,SLOT(Load()));
    connect(ui->BDoIt,SIGNAL(clicked()),this,SLOT(DoIt()));


    // "Instalamos" un "filtro de eventos" en nuestro QLabel Ecran
    // para capturar clicks de ratón sobre la imagen
    ui->Ecran->installEventFilter(this);


    // INICIALIZACIONES
    W=H=0;      // Empezamos sin imagen cargada
    Path="..";  // Carpeta inicial
    Rpiel = 209;
    Gpiel = 158;
    Bpiel = 143;
    Rdesv = 33;
    Gdesv = 39;
    Bdesv = 41;

    Lpiel = 110;
    Ldesv = 50;
    Hpiel = 113;
    Hdesv = 89;
    Spiel = 14;
    Sdesv = 8;

    pixCopia=nullptr;
    // Inicializamos a negro los lienzos (QPixmap) y los asociamos a las "pantallas" gráficas (QLabel)
    //   Le damos tamaño
    Dib1=QPixmap(256,100);
    //   Lo pintamos de negro
    Dib1.fill(Qt::black);
    //   Lo asignamos a un QLabel
    ui->EcranHistoR->setPixmap(Dib1);

    //   Idem
    Dib2=QPixmap(256,100);
    Dib2.fill(Qt::black);
    ui->EcranHistoG->setPixmap(Dib2);

    // De ídem
    Dib3=QPixmap(256,100);
    Dib3.fill(Qt::black);
    n=0.0;
    pendiente=1.0;
    b=0.0;
    borde=255;
    dimEE = 3;
    label = 0;

}

//-------------------------------------------------
//------ Destructor: Limpieza antes de salir ------
//-------------------------------------------------
FPImage::~FPImage()
{
    delete ui;
    delete [] nR;
    delete [] pixCopia;
    delete [] mask;
}

//-------------------------------------------------
//----------- Carga una imagen de disco -----------
//-------------------------------------------------
void FPImage::Load(void)
{
    // Permite al usuario escoger un fichero de imagen
    QString file=QFileDialog::getOpenFileName(this,tr("Abrir imagen"),Path,tr("Image Files (*.png *.jpg *.bmp)"));
    // Si no escogió nada, nos vamos
    if(file.isEmpty()) return;

    // Creamos un QFileInfo para manipular cómodamente el nombre del fichero a efectos informativos
    // Por ejemplo deshacernos del path para que el nombre no ocupe demasiado
    QFileInfo finfo(file);
    // Memorizamos la carpeta usando la variable global Path, para la próxima vez
    Path=finfo.path();
    // Ponemos el nombre del fichero en el recuadro de texto
    ui->EFile->setText(finfo.fileName());
    // Decoración: Añadimos el nombre del fichero al título de la ventana
    setWindowTitle("FPImage v0.1b - "+finfo.fileName());

    // Cargamos la imagen a nuestra variable "Image" usando la función apropiada de la clase QImage
    Image.load(file);
    // Convertimos a RGB (eliminamos el canal A)
    Image=Image.convertToFormat(QImage::Format_RGB888);

    // Almacenamos las dimensiones de la imagen
    W=Image.width();
    H=Image.height();

    // Ponemos nuestros punteros apuntando a cada canal del primer píxel
    pixB=(pixG=(pixR=Image.bits())+1)+1;

    // Ojo! La imagen puede llevar "relleno" ("zero padding"):

    // Longitud en bytes de cada línea incluyendo el padding
    S=Image.bytesPerLine();
    // Padding (número de zeros añadidos al final de cada línea)
    Padding=S-3*W;
    nR = new uchar [S*H];
    nG = nR + 1;
    nB = nR + 2;
    // Mostramos algo de texto informativo
    ui->ERes->appendPlainText("Loaded "+finfo.fileName());
    ui->ERes->appendPlainText("Size "+QString::number(W)+"x"+QString::number(H));
    ui->ERes->appendPlainText("Padded length "+QString::number(S));
    ui->ERes->appendPlainText("Pad "+QString::number(Padding));
    ui->ERes->appendPlainText("");

    // Ponemos algo en la barra de estado durante 2 segundos
    statusBar()->showMessage("Loaded.",2000);

    // Ajustamos el tamaño de la "pantalla" al de la imagen
    ui->Ecran->setFixedWidth(W);
    ui->Ecran->setFixedHeight(H);

    if(pixCopia)delete[]pixCopia;
    pixCopia = new uchar[S*H];
    mask = new uchar[W*H];
    labelling = new int[W*H];
    if(mask)delete [] mask;
    memcpy(pixCopia, pixR, S*H);
    // Volcamos la imagen a pantalla
    ShowIt();

  Histo();

}
//Regla de 3 y medio para hallar a donde corresponde cada pixel. si 0 es el nuevo minimo, y 255 el nuevo maximo, entonces para cada Bpix => ?
//Hacer un boton que haga stretch lineal y repinte el histograma
void FPImage::restore(void)
{
    memcpy(pixR, pixCopia, S*H);
}

//-------------------------------------------------
//------------- Jugamos con la imagen -------------
//-------------------------------------------------
void FPImage::DoIt(void)
{
    // Nos aseguramos de que hay una imagen cargada
    if(!H) return;

    // Ejemplo de procesamiento A BAJO NIVEL
    //   Recorremos toda la imagen manipulando los píxeles uno a uno
    //   Atención a los límites y a los saltos de 3 en 3 (3 canales)
    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
            uchar swap=pixG[i]; pixG[i]=pixR[i]; pixR[i]=swap;
            pixB[i]=255-pixB[i];
    }

    // Sacamos algo de texto informativo
    ui->ERes->appendPlainText("Did it");

    // Ponemos algo en la barra de estado durante 2 segundos
    statusBar()->showMessage("Did it.",2000);

    // Volcamos la imagen a pantalla
    // OJO: Si os olvidáis de esto, la imagen en pantalla no refleja los cambios y
    // pensaréis que no habéis hecho nada, pero Image e Ima (que son la misma) sí
    // que han cambiado aunqu eno lo veáis
    ShowIt();
}

//-------------------------------------------------
//-------------- Mostramos la imagen --------------
//-------------------------------------------------
inline void FPImage::ShowIt(void)
{
    // Creamos un lienzo (QPixmap) a partir de la QImage
    // y lo asignamos a la QLabel central
    ui->Ecran->setPixmap(QPixmap::fromImage(Image));
}

void FPImage::on_bBW_clicked()
{
    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
        if (pixR[i] <= 140 && pixG[i] >= 25) {
            int luma;
            luma = 0.3*pixR[i] + 0.59*pixG[i] + 0.11*pixB[i];
            pixR[i]=luma; pixG[i]=luma; pixB[i] = luma;

        }
    }

    ShowIt();
}

void FPImage::on_sBrillo_valueChanged(int value)
{
    b=value;
    valueChanged();
}

void FPImage::on_sContraste_valueChanged(int contraste)
{
    float grados = contraste/10.0f;
    float angulo = qDegreesToRadians(grados);
    pendiente = qTan(angulo);
    n = 127 - pendiente*127;

    valueChanged();
}

void FPImage::valueChanged()
{
    uchar LUT[256];
    for(int i=0;i<255;i++){

        if ((pendiente*i + n + b) > 255) LUT[i] = 255;
        else if ((pendiente*i + n + b) < 0) LUT[i] = 0;
        else LUT[i]=pendiente*i + n + b;
    }

    restore();
    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {

    pixR[i]=LUT[pixR[i]];
    pixG[i]=LUT[pixG[i]];
    pixB[i]=LUT[pixB[i]];

    }
    ShowIt();
}
void FPImage::Histo(){

    QPainter r(&Dib1);
    QPainter g(&Dib2);
    QPainter b(&Dib3);
    r.setPen(QPen(Qt::red));
    g.setPen(QPen(Qt::green));
    b.setPen(QPen(Qt::blue));
    int maxHistoR = 0;
    int maxHistoG = 0;
    int maxHistoB = 0;
    memset(histoR, 0, 256*sizeof(int));
    memset(histoG, 0, 256*sizeof(int));
    memset(histoB, 0, 256*sizeof(int));
    Dib1.fill(Qt::black);
    Dib2.fill(Qt::black);
    Dib3.fill(Qt::black);
    // for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
    //     histoR[pixR[i]]++;
    //     histoG[pixG[i]]++;
    //     histoB[pixB[i]]++;
    // }

     //for (int index=0; index<255; index++) {
//     ui->ERes->appendPlainText("histoR "+QString::number(histoR[index]));
//     ui->ERes->appendPlainText("histoG "+QString::number(histoG[index]));
//     ui->ERes->appendPlainText("histoB "+QString::number(histoB[index]));
    // if (maxHistoR < histoR[index]) maxHistoR = histoR[index];
    // if (maxHistoG < histoG[index]) maxHistoG = histoG[index];
    // if (maxHistoB < histoB[index]) maxHistoB = histoB[index];

     //}
     //for (int index=0; index<255; index++) {
     //r.drawLine(index,100,index,100-(100*histoR[index])/maxHistoR);
     //g.drawLine(index,100,index,100-(100*histoG[index])/maxHistoG);
     //b.drawLine(index,100,index,100-(100*histoB[index])/maxHistoB);
     //}
     ui->EcranHistoR->setPixmap(Dib1);
     ui->EcranHistoG->setPixmap(Dib2);
     ui->EcranHistoB->setPixmap(Dib3);

}
void FPImage::pBordes() //usar la y (filas) y x (columnas) para comprobar si se va fuera el indice
{
    int distE;
    int distS;
    restore();
     for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
        if ((x<W-1 && pixR[i] - pixR[i+3] > borde) || (y<H-1 && pixR[i] - pixR[i+S] > borde) ||(x<W-1 && pixG[i] - pixG[i+3] > borde) || (y<H-1 && pixG[i] - pixG[i+S] > borde) || (x<W-1 && pixB[i] - pixB[i+3] > borde) || (y<H-1 && pixB[i] - pixB[i+S] > borde) ) {
         pixR[i]=0;pixG[i]=0;pixB[i]=0;}
     }

        if(ui->rManhattan->isChecked()) {
            for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
                if ((x<W-1) || (y<H-1) |(x<W-1) || (y<H-1) || (x<W-1) || (y<H-1) ) {
                    distE= qFabs(pixR[i] - pixR[i+3]) +qFabs(pixG[i] - pixG[i+3]) + qFabs(pixB[i] - pixB[i+3]);
                    distS= qFabs(pixR[i] - pixR[i+S]) +qFabs(pixG[i] - pixG[i+S]) + qFabs(pixB[i] - pixB[i+S]);
                    if (distE > borde || distS > borde) {
                     pixR[i]=0;pixG[i]=0;pixB[i]=0;
                    }else {pixR[i]=255;pixG[i]=255;pixB[i]=255;}
                }
            }
        }

        if(ui->rNorma2->isChecked()) {
            for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
                if ((x<W-1) || (y<H-1) |(x<W-1) || (y<H-1) || (x<W-1) || (y<H-1) ) {
                    distE= qSqrt(qPow((pixR[i] - pixR[i+3]), 2) + qPow((pixG[i] - pixG[i+3]), 2) + qPow((pixB[i] - pixB[i+3]), 2));
                    distS= qSqrt(qPow((pixR[i] - pixR[i+S]), 2) + qPow((pixG[i] - pixG[i+S]), 2) + qPow((pixB[i] - pixB[i+S]), 2));
                    if (distE > borde || distS > borde) {
                     pixR[i]=0;pixG[i]=0;pixB[i]=0;
                    }else {pixR[i]=255;pixG[i]=255;pixB[i]=255;}
                }
            }
        }

        if(ui->rInfinito->isChecked()) {
            for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
                if ((x<W-1) || (y<H-1) |(x<W-1) || (y<H-1) || (x<W-1) || (y<H-1) ) {
                    distE= qMax(qMax(qFabs(pixR[i] - pixR[i+3]), qFabs(pixG[i] - pixG[i+3])), qFabs(pixB[i] - pixB[i+3]));
                    distS= qMax(qMax(qFabs(pixR[i] - pixR[i+S]), qFabs(pixG[i] - pixG[i+S])), qFabs(pixB[i] - pixB[i+S]));
                    if (distE > borde || distS > borde) {
                     pixR[i]=0;pixG[i]=0;pixB[i]=0;
                    }else {pixR[i]=255;pixG[i]=255;pixB[i]=255;}
                }
            }
        }
   ShowIt();
}

void FPImage::on_sBordes_valueChanged(int value)
{
    borde=value;
    pBordes();
}
//stretch lineal => regla de 3 y medio (operacion de realce)

void FPImage::on_bStretch_clicked()
{
    if(!H) return;
       int minR = 0;
       int minG = 0;
       int minB = 0;
       int maxR = 255;
       int maxG = 255;
       int maxB = 255;
       uchar LUTR[256];
       uchar LUTG[256];
       uchar LUTB[256];
       while (histoR[++minR] < 100);

       while (histoR[--maxR] < 100);

       while (histoG[++minG] < 100);

       while (histoG[--maxG] < 100);

       while (histoB[++minB] < 100);

       while (histoB[--maxB] < 100);

       for(int i=0;i<255;i++){
           if (((255*(i-minR))/(maxR-minR)) > 255) LUTR[i] = 255;
           else if (((255*(i-minR))/(maxR-minR)) < 0) LUTR[i] = 0;
           else {
              LUTR[i] = (255*(i-minR))/(maxR-minR);
           }

           if (((255*(i-minG))/(maxG-minG)) > 255) LUTG[i] = 255;
           else if (((255*(i-minG))/(maxG-minG)) < 0) LUTG[i] = 0;
           else {
              LUTG[i] = (255*(i-minG))/(maxG-minG);
           }

           if (((255*(i-minB))/(maxB-minB)) > 255) LUTB[i] = 255;
           else if (((255*(i-minB))/(maxB-minB)) < 0) LUTB[i] = 0;
           else {
              LUTB[i] = (255*(i-minB))/(maxB-minB);
           }

       }
       for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
           pixR[i] = LUTR[pixR[i]];
           pixG[i] = LUTG[pixG[i]];
           pixB[i] = LUTB[pixB[i]];
      }
       Histo();
       ShowIt();
}



void FPImage::on_bEcualizar_clicked()
{
    int histoAcR[256]; int histoAcG[256]; int histoAcB[256];
    uchar LUTR[256];
    uchar LUTG[256];
    uchar LUTB[256];
    histoAcR[0] = histoR[0];
    histoAcG[0] = histoG[0];
    histoAcB[0] = histoB[0];
    for (int i = 1; i<256; i++) {

        histoAcR[i] = histoR[i]+histoAcR[i-1];
        histoAcG[i] = histoG[i]+histoAcG[i-1];
        histoAcB[i] = histoB[i]+histoAcB[i-1];
    }
    for (int i = 1; i<256; i++) {
        LUTR[i]=(histoAcR[i]*255)/histoAcR[255];
        LUTG[i]=(histoAcG[i]*255)/histoAcG[255];
        LUTB[i]=(histoAcB[i]*255)/histoAcB[255];

    }
    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
        pixR[i] = LUTR[pixR[i]];
        pixG[i] = LUTG[pixG[i]];
        pixB[i] = LUTB[pixB[i]];
   }

    ShowIt();
    Histo();
}
//CUBO
//void FPImage::on_bPiel_clicked()
//{
//    restore();
//    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
//        if (((pixR[i] < Rpiel - Rdesv) || (pixR[i] > Rpiel + Rdesv)) || ((pixG[i] < Gpiel - Gdesv) || (pixG[i] > Gpiel + Gdesv)) || ((pixB[i] < Bpiel - Bdesv) || (pixB[i] > Bpiel + Bdesv))) {
            //Fuera de la nube
//            pixR[i] = 0;
//            pixG[i] = 0;
//            pixB[i] = 0;
//        }
//
//    }
//    ShowIt();
//}

// ELIPSE
void FPImage::on_bPiel_clicked()
{


 restore();
 for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
     uchar L, H, S;
     RGB2LHS(nR[i], nG[i], nB[i], L, H, S);
     if (((pow(L - Lpiel,2)/pow(Ldesv,2)) + (pow(H - Hpiel,2)/pow(Hdesv,2)) + (pow(S - Spiel,2)/pow(Sdesv,2))) > 1) {
         mask[i/3] = 0;
       }
     else {
         mask[i/3] = 1;
     }
 }
 ShowMask();

}

void FPImage::RGB2LHS (uchar r, uchar g, uchar b, uchar &L, uchar &H, uchar &S) {

    double X = (0.412453*r + 0.357580*g + 0.180423*b)/255;
    double Y = (0.212671*r + 0.715160*g + 0.072169*b)/255;
    double Z = (0.019334*r + 0.119193*g + 0.950227*b)/255;
    double fY;
    double fZ;
    double fX;
    double XW = 0.950456;
    double ZW = 1.088754;
    double A;
    double B;

    if (Y > 0.008856) {
        L = 116*pow(Y, 1.0/3) - 16;
    }
    else {
        L = 903.3*Y;
    }

    if (Y > 0.008856) {
        fY = pow(Y, 1.0/3);
    }
    else {
        fY = 7.787*Y + 16.0/116;
    }


    if ((X/XW) > 0.008856) {
        fX = pow((X/XW), 1.0/3);
    }
    else {
        fX = 7.787*(X/XW) + 16.0/116;
    }


    if ((Z/ZW) > 0.008856) {
        fZ = pow((Z/ZW), 1.0/3);
    }
    else {
        fZ = 7.787*(Z/XW) + 16.0/116;
    }

    A = ((1000*(fX - fY)) + 1)/255.0;
    B = (400*(fY-fZ)+1)/255.0;

    S = qSqrt(A*A + B*B)*255.0/qSqrt(2);
    H = (qAtan2(A,B) + M_PI)*255.0/M_PI;


}

void FPImage::Filtrar(int dim, int tipo) {
    uchar *newPixR = new uchar[S*H];
    uchar *newPixG = newPixR + 1;
    uchar *newPixB = newPixR + 2;
    float normz = 0;
    float *kernel = new float[dim*dim];

    if (tipo == 1) { //emborronar
        for (int w=0, c=0; w<dim;w++) for (int v=0; v<dim; v++, c++) {
            normz += (kernel[c]=1);
    }
    }
    if (tipo == 2) { //enfocar
        for (int w=0, c=0; w<dim;w++) for (int v=0; v<dim; v++, c++) {
            normz += (kernel[c]=-1);
    }
    kernel[(dim*dim)/2] = -normz;
    normz = 1; //suma de coeficientes
    }
    if (tipo == 3) { //vertical
        for (int w=0, c=0; w<dim;w++) for (int v=0; v<dim; v++, c++) {
            if (v == 0) {
                kernel[c] = 1;
            }
            if (v == 1) {
                kernel[c] = 0;
            }
            if (v == 2) {
                kernel[c] = -1;
            }

        }
        normz = 1;
    }


    for(int y=dim/2;y<H-dim/2;y++) for(int x=dim/2;x<W-dim/2;x++) {
        float sumarR = 0.0;
        float sumarG = 0.0;
        float sumarB = 0.0;
        for (int w=y-dim/2,c=0; w<=y+dim/2; w++) for (int v=x-dim/2; v<=x+dim/2; v++, c++) {
            if ((pixR[w*S + v*3]*kernel[c]) > 255) {
                sumarR = 255;
            }
            else if ((pixR[w*S + v*3]*kernel[c]) < 0) {
                sumarR = 0;
            }

            else {
                sumarR+=pixR[w*S + v*3]*kernel[c];
            }

            if ((pixG[w*S + v*3]*kernel[c]) > 255) {
                sumarG = 255;
            }
            else if ((pixG[w*S + v*3]*kernel[c]) < 0) {
                sumarG = 0;
            }
            else {
                sumarG+=pixG[w*S + v*3]*kernel[c];
            }

            if ((pixR[w*S + v*3]*kernel[c]) > 255) {
                sumarB = 255;
            }
            else if ((pixR[w*S + v*3]*kernel[c]) < 0) {
                sumarB = 0;
            }
            else {
            sumarB+=pixB[w*S + v*3]*kernel[c];
            }
        }
            newPixR[y*S+x*3] = sumarR/(normz);
            newPixG[y*S+x*3] = sumarG/(normz);
            newPixB[y*S+x*3] = sumarB/(normz);

    }

    memcpy(pixR, newPixR, S*H);
    memcpy(nR, newPixR, S*H);

    delete [] kernel;
    delete [] newPixR;
}

void FPImage::on_Rpiel_valueChanged(int value)
{
    Lpiel = value;
    on_bPiel_clicked();
}

void FPImage::on_Rdesv_valueChanged(int value)
{
    Ldesv = value;
    on_bPiel_clicked();
}

void FPImage::on_Gpiel_valueChanged(int value)
{
    Hpiel = value;
    on_bPiel_clicked();
}

void FPImage::on_Gdesv_valueChanged(int value)
{
    Hdesv = value;
    on_bPiel_clicked();
}

void FPImage::on_Bpiel_valueChanged(int value)
{
    Spiel = value;
    on_bPiel_clicked();
}

void FPImage::on_Bdesv_valueChanged(int value)
{
    Sdesv = value;
    on_bPiel_clicked();
}

void FPImage::on_bFiltrar_clicked()
{
    for (int i=0; i<15; i++) {
        Filtrar(5,1);
    }
    //Filtrar(5,1);

    ShowIt();
}


//Erosion + Dilatacion para eliminar elementos pequeños, inverso para eliminar huecos


void FPImage::on_bErosion_clicked()
{
    int k2=dimEE*dimEE;
    uchar *SE= new uchar[k2];

    if(ui->rCuadrado->isChecked()) { //SE CUADRADO
        memset(SE, 1, k2);
    }

    if(ui->rCirculo->isChecked()) { //SE CIRCULO
        int r=dimEE/2, r2=r*r;
        for (int c=0, y=-r; y<=r; ++y) for (int x=-r; x<=r; ++x,++c) {SE[c] = y*y +x*x <= r2?1:0;}
    }

    uchar *OldMask = new uchar [W*H];
    memcpy(OldMask, mask, W*H);
    for (int y=dimEE/2;y<H-dimEE/2;++y) for(int x=dimEE/2;x<W-dimEE/2;x++){
        uchar &center = mask[y*W + x];
        for (int c=0, yy=y-dimEE/2; center && yy<=y+dimEE/2; ++yy) for(int xx=x-dimEE/2; center && xx<=x+dimEE/2; ++xx, ++c)
            if (SE[c] && !OldMask[yy*W+xx]) center = 0;

    }
    delete [] OldMask;
    delete [] SE;
    ShowMask();
}

void FPImage::on_bDilatacion_clicked()
{
    int k2=dimEE*dimEE;
    uchar *SE= new uchar[k2];

    if(ui->rCuadrado->isChecked()) { //SE CUADRADO
        memset(SE, 1, k2);
    }

    if(ui->rCirculo->isChecked()) { //SE CIRCULO
        int r=dimEE/2, r2=r*r;
        for (int c=0, y=-r; y<=r; ++y) for (int x=-r; x<=r; ++x,++c) {SE[c] = y*y +x*x <= r2?1:0;}
    }
    uchar *OldMask = new uchar [W*H];
    memcpy(OldMask, mask, W*H);
    for (int y=dimEE/2;y<H-dimEE/2;++y) for(int x=dimEE/2;x<W-dimEE/2;x++){
        uchar &center = mask[y*W + x];
        for (int c=0, yy=y-dimEE/2; !center && yy<=y+dimEE/2; ++yy) for(int xx=x-dimEE/2; !center && xx<=x+dimEE/2; ++xx, ++c)
            if (SE[c] && OldMask[yy*W+xx]) center = 1;
    }
    delete [] OldMask;
    delete [] SE;
    ShowMask();
}

void FPImage::on_sDim_valueChanged(int value)
{
    dimEE = value;
    ShowMask();
}

void FPImage::ShowMask() {
    //memcpy(mask, pixR, S*H);
    restore();
    for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) if(!mask[i/3]) {
        pixR[i] = 0;
        pixG[i] = 0;
        pixB[i] = 0;
    }
    ShowIt();

}

void FPImage::PutLabel(int x, int y){


    labelling[x + y*W] = label;
    NPix++;
    if (x>0 && labelling[(x - 1) + y*W] < 0) PutLabel(x - 1, y);
    if (y>0 && labelling[x + (y-1)*W] < 0) PutLabel(x, y - 1);
    if ((x+1<W) && labelling[(x + 1) + y*W] < 0) PutLabel(x + 1, y);
    if ((y+1<H) && labelling[x + (y+1)*W] < 0) PutLabel(x, y + 1);

    if (x < Xmin) Xmin = x;
    if (y < Ymin) Ymin = y;
    if (x > Xmax) Xmax = x;
    if (y > Ymax) Ymax = y;

    if (labelling[(x - 1) + y*W] == 0 || labelling[x + (y-1)*W] == 0 || labelling[(x + 1) + y*W] == 0 || labelling[x + (y+1)*W] == 0) Perim++;

}

void FPImage::on_bEtiquetar_clicked()
{   //memcpy(labelling, mask, W*H);
    label = 0;
    /*for (int i = 0; i<7; i++) {
        Filtrar(5,1);
    }
    for (int i = 0; i<15; i++) {
        Filtrar(5,2);
    }*/
    for (int i=0; i<W*H; i++) {
        if (mask[i] == 1) labelling[i] = -1;
        else {
            labelling[i] = 0;
        }

    }
    restore();
    for(int y=0;y<H;y++) for(int x=0;x<W;x++) {
        if (labelling[x + y*W] < 0) {
            NPix = Perim = 0;
            label++;
            Ymax = Xmax = 0;
            Ymin =H;
            Xmin =W;
            PutLabel(x, y);
            Area[label] = NPix;
            Perims[label] = Perim;
            AH = Ymax - Ymin;
            AW = Xmax - Xmin;


            C = 4*M_PI*Area[label]/(Perims[label]*Perims[label]);
            AR = AW*1.0/AH*1.0;
            qDebug() << "C: " << C;
            qDebug() << "Area: " << Area[label];
            qDebug() << "Perims: " << Perims[label];
            qDebug() << "AR: " << AR;
            qDebug() << "AW: " << AW;
            qDebug() << "AH: " << AH;

            if (AR < 1 && C < 1.5) {

                QPainter rect(&Image);
                rect.setPen(QPen(Qt::yellow));
                rect.drawRect(Xmin, Ymin, AW, AH);
            }

        }

    }

    //for(int y=0,i=0;y<H;y++,i+=Padding) for(int x=0;x<W;x++,i+=3) {
    //    pixR[i] = labelling[i/3]*17;
    //    pixG[i] = labelling[i/3]*43;
    //    pixB[i] = labelling[i/3]*73;
    //}

    ShowIt();
}
