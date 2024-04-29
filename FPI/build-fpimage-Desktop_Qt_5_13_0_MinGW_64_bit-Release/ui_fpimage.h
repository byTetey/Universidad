/********************************************************************************
** Form generated from reading UI file 'fpimage.ui'
**
** Created by: Qt User Interface Compiler version 5.13.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_FPIMAGE_H
#define UI_FPIMAGE_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QRadioButton>
#include <QtWidgets/QScrollArea>
#include <QtWidgets/QSlider>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_FPImage
{
public:
    QWidget *centralWidget;
    QHBoxLayout *horizontalLayout_2;
    QVBoxLayout *verticalLayout;
    QPlainTextEdit *ERes;
    QGroupBox *groupBox;
    QVBoxLayout *verticalLayout_3;
    QRadioButton *rInfinito;
    QRadioButton *rManhattan;
    QRadioButton *rNorma2;
    QGroupBox *groupBox_2;
    QRadioButton *rCuadrado;
    QRadioButton *rCirculo;
    QLineEdit *EFile;
    QPushButton *bEtiquetar;
    QPushButton *bErosion;
    QPushButton *bDilatacion;
    QPushButton *bFiltrar;
    QPushButton *bPiel;
    QPushButton *bBW;
    QPushButton *bEcualizar;
    QPushButton *bStretch;
    QHBoxLayout *horizontalLayout;
    QPushButton *BLoad;
    QPushButton *BDoIt;
    QScrollArea *scrollArea;
    QWidget *scrollAreaWidgetContents;
    QGridLayout *gridLayout;
    QLabel *Ecran;
    QVBoxLayout *verticalLayout_2;
    QLabel *EcranHistoR;
    QLabel *EcranHistoG;
    QLabel *EcranHistoB;
    QSlider *Rpiel;
    QSpacerItem *verticalSpacer;
    QSlider *Rdesv;
    QSlider *Gpiel;
    QSlider *Gdesv;
    QSlider *Bpiel;
    QSlider *Bdesv;
    QFrame *line;
    QSlider *sBordes;
    QSlider *sContraste;
    QSlider *sBrillo;
    QFrame *line_2;
    QSlider *sDim;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *FPImage)
    {
        if (FPImage->objectName().isEmpty())
            FPImage->setObjectName(QString::fromUtf8("FPImage"));
        FPImage->resize(1140, 701);
        FPImage->setMinimumSize(QSize(200, 0));
        centralWidget = new QWidget(FPImage);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        horizontalLayout_2 = new QHBoxLayout(centralWidget);
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setSpacing(6);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setSizeConstraint(QLayout::SetDefaultConstraint);
        ERes = new QPlainTextEdit(centralWidget);
        ERes->setObjectName(QString::fromUtf8("ERes"));

        verticalLayout->addWidget(ERes);

        groupBox = new QGroupBox(centralWidget);
        groupBox->setObjectName(QString::fromUtf8("groupBox"));
        QSizePolicy sizePolicy(QSizePolicy::Preferred, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(groupBox->sizePolicy().hasHeightForWidth());
        groupBox->setSizePolicy(sizePolicy);
        groupBox->setMinimumSize(QSize(0, 100));
        verticalLayout_3 = new QVBoxLayout(groupBox);
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setContentsMargins(11, 11, 11, 11);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        rInfinito = new QRadioButton(groupBox);
        rInfinito->setObjectName(QString::fromUtf8("rInfinito"));

        verticalLayout_3->addWidget(rInfinito);

        rManhattan = new QRadioButton(groupBox);
        rManhattan->setObjectName(QString::fromUtf8("rManhattan"));

        verticalLayout_3->addWidget(rManhattan);

        rNorma2 = new QRadioButton(groupBox);
        rNorma2->setObjectName(QString::fromUtf8("rNorma2"));

        verticalLayout_3->addWidget(rNorma2);


        verticalLayout->addWidget(groupBox);

        groupBox_2 = new QGroupBox(centralWidget);
        groupBox_2->setObjectName(QString::fromUtf8("groupBox_2"));
        rCuadrado = new QRadioButton(groupBox_2);
        rCuadrado->setObjectName(QString::fromUtf8("rCuadrado"));
        rCuadrado->setGeometry(QRect(80, 0, 71, 17));
        rCirculo = new QRadioButton(groupBox_2);
        rCirculo->setObjectName(QString::fromUtf8("rCirculo"));
        rCirculo->setGeometry(QRect(160, 0, 82, 17));

        verticalLayout->addWidget(groupBox_2);

        EFile = new QLineEdit(centralWidget);
        EFile->setObjectName(QString::fromUtf8("EFile"));

        verticalLayout->addWidget(EFile);

        bEtiquetar = new QPushButton(centralWidget);
        bEtiquetar->setObjectName(QString::fromUtf8("bEtiquetar"));

        verticalLayout->addWidget(bEtiquetar);

        bErosion = new QPushButton(centralWidget);
        bErosion->setObjectName(QString::fromUtf8("bErosion"));

        verticalLayout->addWidget(bErosion);

        bDilatacion = new QPushButton(centralWidget);
        bDilatacion->setObjectName(QString::fromUtf8("bDilatacion"));

        verticalLayout->addWidget(bDilatacion);

        bFiltrar = new QPushButton(centralWidget);
        bFiltrar->setObjectName(QString::fromUtf8("bFiltrar"));

        verticalLayout->addWidget(bFiltrar);

        bPiel = new QPushButton(centralWidget);
        bPiel->setObjectName(QString::fromUtf8("bPiel"));

        verticalLayout->addWidget(bPiel);

        bBW = new QPushButton(centralWidget);
        bBW->setObjectName(QString::fromUtf8("bBW"));

        verticalLayout->addWidget(bBW);

        bEcualizar = new QPushButton(centralWidget);
        bEcualizar->setObjectName(QString::fromUtf8("bEcualizar"));

        verticalLayout->addWidget(bEcualizar);

        bStretch = new QPushButton(centralWidget);
        bStretch->setObjectName(QString::fromUtf8("bStretch"));

        verticalLayout->addWidget(bStretch);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        BLoad = new QPushButton(centralWidget);
        BLoad->setObjectName(QString::fromUtf8("BLoad"));

        horizontalLayout->addWidget(BLoad);

        BDoIt = new QPushButton(centralWidget);
        BDoIt->setObjectName(QString::fromUtf8("BDoIt"));

        horizontalLayout->addWidget(BDoIt);


        verticalLayout->addLayout(horizontalLayout);


        horizontalLayout_2->addLayout(verticalLayout);

        scrollArea = new QScrollArea(centralWidget);
        scrollArea->setObjectName(QString::fromUtf8("scrollArea"));
        scrollArea->setFrameShape(QFrame::Panel);
        scrollArea->setLineWidth(2);
        scrollArea->setWidgetResizable(true);
        scrollAreaWidgetContents = new QWidget();
        scrollAreaWidgetContents->setObjectName(QString::fromUtf8("scrollAreaWidgetContents"));
        scrollAreaWidgetContents->setGeometry(QRect(0, 0, 586, 626));
        gridLayout = new QGridLayout(scrollAreaWidgetContents);
        gridLayout->setSpacing(6);
        gridLayout->setContentsMargins(11, 11, 11, 11);
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        Ecran = new QLabel(scrollAreaWidgetContents);
        Ecran->setObjectName(QString::fromUtf8("Ecran"));

        gridLayout->addWidget(Ecran, 0, 0, 1, 1);

        scrollArea->setWidget(scrollAreaWidgetContents);

        horizontalLayout_2->addWidget(scrollArea);

        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        EcranHistoR = new QLabel(centralWidget);
        EcranHistoR->setObjectName(QString::fromUtf8("EcranHistoR"));
        EcranHistoR->setMinimumSize(QSize(260, 104));
        EcranHistoR->setMaximumSize(QSize(260, 104));
        EcranHistoR->setFrameShape(QFrame::Panel);
        EcranHistoR->setFrameShadow(QFrame::Sunken);
        EcranHistoR->setLineWidth(2);
        EcranHistoR->setMidLineWidth(0);

        verticalLayout_2->addWidget(EcranHistoR);

        EcranHistoG = new QLabel(centralWidget);
        EcranHistoG->setObjectName(QString::fromUtf8("EcranHistoG"));
        EcranHistoG->setMinimumSize(QSize(260, 104));
        EcranHistoG->setMaximumSize(QSize(260, 104));
        EcranHistoG->setFrameShape(QFrame::Panel);
        EcranHistoG->setFrameShadow(QFrame::Sunken);
        EcranHistoG->setLineWidth(2);

        verticalLayout_2->addWidget(EcranHistoG);

        EcranHistoB = new QLabel(centralWidget);
        EcranHistoB->setObjectName(QString::fromUtf8("EcranHistoB"));
        EcranHistoB->setMinimumSize(QSize(260, 104));
        EcranHistoB->setMaximumSize(QSize(260, 104));
        EcranHistoB->setFrameShape(QFrame::Panel);
        EcranHistoB->setFrameShadow(QFrame::Sunken);
        EcranHistoB->setLineWidth(2);

        verticalLayout_2->addWidget(EcranHistoB);

        Rpiel = new QSlider(centralWidget);
        Rpiel->setObjectName(QString::fromUtf8("Rpiel"));
        Rpiel->setMaximum(255);
        Rpiel->setValue(110);
        Rpiel->setSliderPosition(110);
        Rpiel->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Rpiel);

        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer);

        Rdesv = new QSlider(centralWidget);
        Rdesv->setObjectName(QString::fromUtf8("Rdesv"));
        Rdesv->setMaximum(150);
        Rdesv->setValue(50);
        Rdesv->setSliderPosition(50);
        Rdesv->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Rdesv);

        Gpiel = new QSlider(centralWidget);
        Gpiel->setObjectName(QString::fromUtf8("Gpiel"));
        Gpiel->setMaximum(255);
        Gpiel->setValue(113);
        Gpiel->setSliderPosition(113);
        Gpiel->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Gpiel);

        Gdesv = new QSlider(centralWidget);
        Gdesv->setObjectName(QString::fromUtf8("Gdesv"));
        Gdesv->setMaximum(150);
        Gdesv->setValue(89);
        Gdesv->setSliderPosition(89);
        Gdesv->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Gdesv);

        Bpiel = new QSlider(centralWidget);
        Bpiel->setObjectName(QString::fromUtf8("Bpiel"));
        Bpiel->setMaximum(255);
        Bpiel->setValue(14);
        Bpiel->setSliderPosition(14);
        Bpiel->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Bpiel);

        Bdesv = new QSlider(centralWidget);
        Bdesv->setObjectName(QString::fromUtf8("Bdesv"));
        Bdesv->setMaximum(150);
        Bdesv->setValue(8);
        Bdesv->setSliderPosition(8);
        Bdesv->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(Bdesv);

        line = new QFrame(centralWidget);
        line->setObjectName(QString::fromUtf8("line"));
        line->setFrameShape(QFrame::HLine);
        line->setFrameShadow(QFrame::Sunken);

        verticalLayout_2->addWidget(line);

        sBordes = new QSlider(centralWidget);
        sBordes->setObjectName(QString::fromUtf8("sBordes"));
        sBordes->setLayoutDirection(Qt::RightToLeft);
        sBordes->setMinimum(0);
        sBordes->setMaximum(255);
        sBordes->setValue(255);
        sBordes->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(sBordes);

        sContraste = new QSlider(centralWidget);
        sContraste->setObjectName(QString::fromUtf8("sContraste"));
        sContraste->setMinimum(0);
        sContraste->setMaximum(890);
        sContraste->setSliderPosition(450);
        sContraste->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(sContraste);

        sBrillo = new QSlider(centralWidget);
        sBrillo->setObjectName(QString::fromUtf8("sBrillo"));
        sBrillo->setMinimum(-255);
        sBrillo->setMaximum(255);
        sBrillo->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(sBrillo);

        line_2 = new QFrame(centralWidget);
        line_2->setObjectName(QString::fromUtf8("line_2"));
        line_2->setFrameShape(QFrame::HLine);
        line_2->setFrameShadow(QFrame::Sunken);

        verticalLayout_2->addWidget(line_2);

        sDim = new QSlider(centralWidget);
        sDim->setObjectName(QString::fromUtf8("sDim"));
        sDim->setMinimum(3);
        sDim->setMaximum(100);
        sDim->setOrientation(Qt::Horizontal);

        verticalLayout_2->addWidget(sDim);


        horizontalLayout_2->addLayout(verticalLayout_2);

        horizontalLayout_2->setStretch(1, 1);
        FPImage->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(FPImage);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1140, 21));
        FPImage->setMenuBar(menuBar);
        mainToolBar = new QToolBar(FPImage);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        FPImage->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(FPImage);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        FPImage->setStatusBar(statusBar);

        retranslateUi(FPImage);

        QMetaObject::connectSlotsByName(FPImage);
    } // setupUi

    void retranslateUi(QMainWindow *FPImage)
    {
        FPImage->setWindowTitle(QCoreApplication::translate("FPImage", "FPImage", nullptr));
        groupBox->setTitle(QCoreApplication::translate("FPImage", "GroupBox", nullptr));
        rInfinito->setText(QCoreApplication::translate("FPImage", "norma infinito", nullptr));
        rManhattan->setText(QCoreApplication::translate("FPImage", "norma Manhattan", nullptr));
        rNorma2->setText(QCoreApplication::translate("FPImage", "norma 2", nullptr));
        groupBox_2->setTitle(QCoreApplication::translate("FPImage", "GroupBox", nullptr));
        rCuadrado->setText(QCoreApplication::translate("FPImage", "Cuadrado", nullptr));
        rCirculo->setText(QCoreApplication::translate("FPImage", "Circulo", nullptr));
        bEtiquetar->setText(QCoreApplication::translate("FPImage", "Etiquetar", nullptr));
        bErosion->setText(QCoreApplication::translate("FPImage", "Erosion", nullptr));
        bDilatacion->setText(QCoreApplication::translate("FPImage", "Dilatacion", nullptr));
        bFiltrar->setText(QCoreApplication::translate("FPImage", "Filtrar", nullptr));
        bPiel->setText(QCoreApplication::translate("FPImage", "Reconocedor facial", nullptr));
        bBW->setText(QCoreApplication::translate("FPImage", "B/W", nullptr));
        bEcualizar->setText(QCoreApplication::translate("FPImage", "Ecualizador", nullptr));
        bStretch->setText(QCoreApplication::translate("FPImage", "Stretch Lineal", nullptr));
        BLoad->setText(QCoreApplication::translate("FPImage", "Load", nullptr));
        BDoIt->setText(QCoreApplication::translate("FPImage", "Do it", nullptr));
        Ecran->setText(QString());
        EcranHistoR->setText(QString());
        EcranHistoG->setText(QString());
        EcranHistoB->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class FPImage: public Ui_FPImage {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_FPIMAGE_H
