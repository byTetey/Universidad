#include "fpimage.h"
#include "ui_fpimage.h"

#include <QFileDialog>
#include <QPainter>
#include <QDebug>

#include <math.h>



//-------------------------------------------------
//-- Constructor: Conexiones e inicializaciones ---
//-------------------------------------------------
FPImage::FPImage(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::FPImage)
{

    ui->setupUi(this);

    // CONEXIONES de nuestros objetos (botones, etc...) a nuestros slots
    connect(ui->BSelectFile,SIGNAL(clicked()),this,SLOT(Load()));
    connect(ui->BRestore,SIGNAL(clicked()),this,SLOT(DoIt()));

    // Synchronize the scroll bars of both Ecrans
    connect((const QObject*)ui->scrollArea->verticalScrollBar(), SIGNAL(valueChanged(int)),(const QObject*)ui->scrollArea_2->verticalScrollBar(), SLOT(setValue(int)));
    connect((const QObject*)ui->scrollArea_2->verticalScrollBar(), SIGNAL(valueChanged(int)),(const QObject*)ui->scrollArea->verticalScrollBar(), SLOT(setValue(int)));
    connect((const QObject*)ui->scrollArea->horizontalScrollBar(), SIGNAL(valueChanged(int)),(const QObject*)ui->scrollArea_2->horizontalScrollBar(), SLOT(setValue(int)));
    connect((const QObject*)ui->scrollArea_2->horizontalScrollBar(), SIGNAL(valueChanged(int)),(const QObject*)ui->scrollArea->horizontalScrollBar(), SLOT(setValue(int)));


    // INICIALIZACIONES
    Wlow=Hlow=0;      // Empezamos sin imagen cargada
    Path="..";  // Carpeta inicial

}

//-------------------------------------------------
//------ Destructor: Limpieza antes de salir ------
//-------------------------------------------------
FPImage::~FPImage()
{

    delete ui;

}

//-------------------------------------------------
//--------- Load and show a low-res image ---------
//-------------------------------------------------
void FPImage::Load(void)
{

    QString file=QFileDialog::getOpenFileName(this,tr("Open image"),Path,tr("BMP Image Files (*.bmp)"));
    if(file.isEmpty()) return;

	// Extract the base name common to all low-resolution images
    QFileInfo finfo(file);
    Path=finfo.path();
    BaseName=finfo.baseName();
    BaseName=BaseName.left(BaseName.indexOf('_'));

	// Show the base name in the screen and in the window title
    ui->EFile->setText(BaseName);
    setWindowTitle("Super resolutive v0.1b - "+BaseName);
	
	

	// Load the first low-resolution image


    //Make sure the pixel matrix is in the right format (R|G|B|R|G|B|R|G|B|... 1 byte per channel)
    QImage LowRes(Path+"/"+BaseName+"_"+QString::number(0)+"_"+QString::number(0)+".bmp");
    LowRes=LowRes.convertToFormat(QImage::Format_RGB888);

    // Get the relevant image parameters
    Wlow=LowRes.width();
    Hlow=LowRes.height();
    Slow=LowRes.bytesPerLine();
    uchar *pixlow=LowRes.bits();
	
	

    // Show the LowRes image in the screen with x25 magnified pixels
    QImage AuxIma=LowRes.scaled(25*Wlow,25*Hlow);
    ui->Ecran->setPixmap(QPixmap::fromImage(AuxIma));

	// Show the suspect in the screen
    AuxIma.load(Path+"/Suspect.jpg");
    ui->EcranSuspect->setPixmap(QPixmap::fromImage(AuxIma));

}

//-------------------------------------------------
//-------------- Build high-res image -------------
//-------------------------------------------------
void FPImage::DoIt(void)
{
    // Make sure a base name was selected (with Load button)
    if(BaseName.isEmpty()) return;
    ui->ERes->appendPlainText("Building "+BaseName);


    // This may come in handy: Prepare an empty HiRes pixel matrix
    const int W = Wlow*5+4;
    const int H = Hlow*5+4;
    const int S=3*W; // No padding in our custom image
    uchar *HiRes=new uchar[S*H]; // A uchar matrix for the *final* HiRes image

    memset(HiRes,0,S*H); // Clean slate
    
    // Sacamos algo de texto informativo
    ui->ERes->appendPlainText("Doing it");

    int *HiResInt=new int[S*H];
    memset(HiResInt,0,S*H*sizeof(int));

    for (int j=0; j<=4; j++) {
        for (int k = 0; k<=4; k++) {
           QImage LRes(Path+"/"+BaseName+"_"+QString::number(k)+"_"+QString::number(j)+".bmp");

           LRes=LRes.convertToFormat(QImage::Format_RGB888);
           pixB=(pixG=(pixR=LRes.bits())+1)+1;
           for(int y=0,i=0;y<H-4;y++,i+=0) for(int x=0;x<W-4;x++,i+=3) {


               HiResInt[(y+j)*S + 3*(x+k)] += pixR[((y)/5)*Slow + 3*(x/5)];
               HiResInt[((y+j)*S + 3*(x+k))+1] += pixG[((y)/5)*Slow + 3*(x/5)];
               HiResInt[((y+j)*S + 3*(x+k))+2] += pixB[((y)/5)*Slow + 3*(x/5)];



           }
        }
    }

    for(int y=0,i=0;y<H;y++,i+=0) for(int x=0;x<W;x++,i+=3) {

        HiRes[(y)*S + 3*(x)] = HiResInt[(y)*S + 3*(x)]/25;
        HiRes[((y)*S + 3*(x))+1] = HiResInt[(y)*S + 3*(x)+1]/25;
        HiRes[((y)*S + 3*(x))+2] = HiResInt[(y)*S + 3*(x)+2]/25;

    }

    //pixB=(pixG=(pixR=HiRes)+1)+1;
	// Do the thing, i.e. build a HiRes from the LowRes images
	

    //
    //
    // YES: HERE IT IS WHERE YOU HAVE TO WORK IT OUT
    //
    //
	
	
	
	// ShowIt!
    ui->EcranBis->setPixmap(QPixmap::fromImage(QImage(HiRes,W,H,S,QImage::Format_RGB888).scaled(5*W,5*H)));

    // Clean up after yourself
    delete [] HiRes;

    statusBar()->showMessage("Done.");
       
}







