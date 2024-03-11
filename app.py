from PyQt5 import QtCore, QtGui, QtWidgets
import matplotlib.pyplot as plt
from PyQt5.QtCore import QCoreApplication
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
from pyModbusTCP.client import ModbusClient
from time import sleep
from threading import Thread

class Ui_MainWindow(object):
    def __init__(self):
        super().__init__()
        self.client = ModbusClient(host='127.0.0.1', port=9999, auto_open=True)
        self.address = ''
        self.figure = Figure()

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(900, 800)
        MainWindow.setMinimumSize(QtCore.QSize(900, 800))
        MainWindow.setMaximumSize(QtCore.QSize(900, 800))
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.widget = QtWidgets.QWidget(self.centralwidget)
        self.widget.setStyleSheet("border: none;\n"
"background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:1, stop:0 rgba(23, 204, 38, 255), stop:1 rgba(0, 122, 0, 255));\n"
"border-radius: 10px;")
        self.widget.setObjectName("widget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.widget)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.widget_2 = QtWidgets.QWidget(self.widget)
        self.widget_2.setObjectName("widget_2")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.widget_2)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.widget_11 = QtWidgets.QWidget(self.widget_2)
        self.widget_11.setMinimumSize(QtCore.QSize(0, 450))
        self.widget_11.setMaximumSize(QtCore.QSize(16777215, 450))
        self.widget_11.setStyleSheet("background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:1, stop:0 rgba(37, 150, 190, 255), stop:1 rgba(26, 81, 91, 255));")
        self.widget_11.setObjectName("widget_11")
        self.verticalLayout_4 = QtWidgets.QVBoxLayout(self.widget_11)
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.label_3 = QtWidgets.QLabel(self.widget_11)
        self.label_3.setMinimumSize(QtCore.QSize(0, 50))
        self.label_3.setMaximumSize(QtCore.QSize(16777215, 150))
        font = QtGui.QFont()
        font.setPointSize(25)
        self.label_3.setFont(font)
        self.label_3.setStyleSheet("background-color: none;\n"
"color: white;")
        self.label_3.setObjectName("label_3")
        self.verticalLayout_4.addWidget(self.label_3, 0, QtCore.Qt.AlignHCenter)
        self.graphicsView = QtWidgets.QGraphicsView(self.widget_11)
        self.graphicsView.setMinimumSize(QtCore.QSize(0, 175))
        self.graphicsView.setMaximumSize(QtCore.QSize(16777215, 200))
        self.graphicsView.setStyleSheet("background-color: rgb(255, 255, 255);")
        self.graphicsView.setObjectName("graphicsView")
        self.verticalLayout_4.addWidget(self.graphicsView)
        self.widget_3 = QtWidgets.QWidget(self.widget_11)
        self.widget_3.setObjectName("widget_3")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.widget_3)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.widget_4 = QtWidgets.QWidget(self.widget_3)
        self.widget_4.setStyleSheet("background-color: none;")
        self.widget_4.setObjectName("widget_4")
        self.verticalLayout_5 = QtWidgets.QVBoxLayout(self.widget_4)
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.label_4 = QtWidgets.QLabel(self.widget_4)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.label_4.setFont(font)
        self.label_4.setStyleSheet("color: white;")
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.verticalLayout_5.addWidget(self.label_4)
        self.lineEdit_3 = QtWidgets.QLineEdit(self.widget_4)
        self.lineEdit_3.setMinimumSize(QtCore.QSize(0, 50))
        self.lineEdit_3.setMaximumSize(QtCore.QSize(16777215, 50))
        self.lineEdit_3.setStyleSheet("QLineEdit {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 1px;\n"
"}\n"
"QLineEdit:hover {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.lineEdit_3.setObjectName("lineEdit_3")
        self.verticalLayout_5.addWidget(self.lineEdit_3)
        self.pushButton_3 = QtWidgets.QPushButton(self.widget_4)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.pushButton_3.setFont(font)
        self.pushButton_3.setStyleSheet("QPushButton {\n"
"    color: rgb(255, 255, 255);\n"
"    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:1, stop:0 rgba(23, 204, 38, 255), stop:1 rgba(0, 122, 0, 255));\n"
"    border-radius: 15px;\n"
"    border: 1px;\n"
"}\n"
"\n"
"QPushButton:hover {\n"
"    background-color: rgb(0, 255, 0);\n"
"    color: rgb(0, 0, 0);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.pushButton_3.setObjectName("pushButton_3")
        self.verticalLayout_5.addWidget(self.pushButton_3)
        self.horizontalLayout_2.addWidget(self.widget_4)
        self.widget_7 = QtWidgets.QWidget(self.widget_3)
        self.widget_7.setStyleSheet("background-color: none;")
        self.widget_7.setObjectName("widget_7")
        self.verticalLayout_6 = QtWidgets.QVBoxLayout(self.widget_7)
        self.verticalLayout_6.setObjectName("verticalLayout_6")
        self.label_5 = QtWidgets.QLabel(self.widget_7)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.label_5.setFont(font)
        self.label_5.setStyleSheet("color: white;")
        self.label_5.setAlignment(QtCore.Qt.AlignCenter)
        self.label_5.setObjectName("label_5")
        self.verticalLayout_6.addWidget(self.label_5)
        self.lineEdit_4 = QtWidgets.QLineEdit(self.widget_7)
        self.lineEdit_4.setMinimumSize(QtCore.QSize(0, 50))
        self.lineEdit_4.setMaximumSize(QtCore.QSize(16777215, 50))
        self.lineEdit_4.setStyleSheet("QLineEdit {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 1px;\n"
"}\n"
"QLineEdit:hover {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.lineEdit_4.setObjectName("lineEdit_4")
        self.verticalLayout_6.addWidget(self.lineEdit_4)
        self.pushButton_4 = QtWidgets.QPushButton(self.widget_7)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.pushButton_4.setFont(font)
        self.pushButton_4.setStyleSheet("QPushButton {\n"
"    color: rgb(255, 255, 255);\n"
"    background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:1, stop:0 rgba(170, 0, 0, 255), stop:1 rgba(40, 10, 12, 255));\n"
"    border-radius: 15px;\n"
"    border: 1px;\n"
"}\n"
"\n"
"QPushButton:hover {\n"
"    background-color: rgb(255, 0, 0);\n"
"    color: rgb(0, 0, 0);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.pushButton_4.setObjectName("pushButton_4")
        self.verticalLayout_6.addWidget(self.pushButton_4)
        self.horizontalLayout_2.addWidget(self.widget_7)
        self.widget_8 = QtWidgets.QWidget(self.widget_3)
        self.widget_8.setMinimumSize(QtCore.QSize(50, 0))
        self.widget_8.setMaximumSize(QtCore.QSize(16777215, 16777215))
        self.widget_8.setStyleSheet("background-color: qlineargradient(spread:pad, x1:0, y1:0.489, x2:0.762, y2:0.5, stop:0 rgba(192, 192, 192, 255), stop:1 rgba(209, 209, 209, 255));")
        self.widget_8.setObjectName("widget_8")
        self.verticalLayout_7 = QtWidgets.QVBoxLayout(self.widget_8)
        self.verticalLayout_7.setObjectName("verticalLayout_7")
        self.label_6 = QtWidgets.QLabel(self.widget_8)
        self.label_6.setStyleSheet("background-color: none;")
        self.label_6.setObjectName("label_6")
        self.verticalLayout_7.addWidget(self.label_6, 0, QtCore.Qt.AlignHCenter)
        self.label_7 = QtWidgets.QLabel(self.widget_8)
        self.label_7.setStyleSheet("background-color: none;")
        self.label_7.setObjectName("label_7")
        self.verticalLayout_7.addWidget(self.label_7, 0, QtCore.Qt.AlignHCenter)
        self.horizontalLayout_2.addWidget(self.widget_8)
        self.verticalLayout_4.addWidget(self.widget_3)
        self.verticalLayout_2.addWidget(self.widget_11)
        self.widget_6 = QtWidgets.QWidget(self.widget_2)
        self.widget_6.setStyleSheet("background-color: none;")
        self.widget_6.setObjectName("widget_6")
        self.gridLayout_4 = QtWidgets.QGridLayout(self.widget_6)
        self.gridLayout_4.setObjectName("gridLayout_4")
        self.widget_10 = QtWidgets.QWidget(self.widget_6)
        self.widget_10.setObjectName("widget_10")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.widget_10)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.label = QtWidgets.QLabel(self.widget_10)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.verticalLayout_3.addWidget(self.label, 0, QtCore.Qt.AlignHCenter)
        self.lineEdit = QtWidgets.QLineEdit(self.widget_10)
        self.lineEdit.setMinimumSize(QtCore.QSize(0, 100))
        self.lineEdit.setMaximumSize(QtCore.QSize(16777215, 100))
        font = QtGui.QFont()
        font.setPointSize(25)
        self.lineEdit.setFont(font)
        self.lineEdit.setStyleSheet("QLineEdit {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 1px;\n"
"}\n"
"QLineEdit:hover {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.lineEdit.setObjectName("lineEdit")
        self.verticalLayout_3.addWidget(self.lineEdit)
        spacerItem = QtWidgets.QSpacerItem(5, 5, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.verticalLayout_3.addItem(spacerItem)
        self.pushButton = QtWidgets.QPushButton(self.widget_10)
        self.pushButton.setMinimumSize(QtCore.QSize(0, 100))
        self.pushButton.clicked.connect(self.resetData)
        font = QtGui.QFont()
        font.setPointSize(20)
        self.pushButton.setFont(font)
        self.pushButton.setStyleSheet("QPushButton {\n"
"    color: rgb(255, 255, 255);\n"
"    background-color: qlineargradient(spread:pad, x1:0, y1:0.505, x2:0.99435,     y2:0.517, stop:0 rgba(37, 150, 190, 255), stop:1 rgba(26, 81, 91, 255));\n"
"    border-radius: 15px;\n"
"    border: 1px;\n"
"}\n"
"\n"
"QPushButton:hover {\n"
"    background-color: rgb(37, 150, 190);\n"
"    color: rgb(0, 0, 0);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.pushButton.setObjectName("pushButton")
        self.verticalLayout_3.addWidget(self.pushButton)
        spacerItem1 = QtWidgets.QSpacerItem(2, 2, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.verticalLayout_3.addItem(spacerItem1)
        self.gridLayout_4.addWidget(self.widget_10, 1, 0, 1, 1)
        self.widget_5 = QtWidgets.QWidget(self.widget_6)
        self.widget_5.setMinimumSize(QtCore.QSize(0, 200))
        self.widget_5.setStyleSheet("background-color: none;")
        self.widget_5.setObjectName("widget_5")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.widget_5)
        self.verticalLayout.setObjectName("verticalLayout")
        self.label_2 = QtWidgets.QLabel(self.widget_5)
        font = QtGui.QFont()
        font.setPointSize(25)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.verticalLayout.addWidget(self.label_2, 0, QtCore.Qt.AlignHCenter)
        self.lineEdit_2 = QtWidgets.QLineEdit(self.widget_5)
        self.lineEdit_2.setMinimumSize(QtCore.QSize(0, 100))
        self.lineEdit_2.setMaximumSize(QtCore.QSize(16777215, 100))
        font = QtGui.QFont()
        font.setPointSize(25)
        self.lineEdit_2.setFont(font)
        self.lineEdit_2.setStyleSheet("QLineEdit {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 1px;\n"
"}\n"
"QLineEdit:hover {\n"
"    background-color: rgb(255, 255, 255);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.lineEdit_2.setObjectName("lineEdit_2")
        self.verticalLayout.addWidget(self.lineEdit_2)
        spacerItem2 = QtWidgets.QSpacerItem(5, 5, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.verticalLayout.addItem(spacerItem2)
        self.pushButton_2 = QtWidgets.QPushButton(self.widget_5)
        self.pushButton_2.setMinimumSize(QtCore.QSize(0, 100))
        self.pushButton_2.clicked.connect(self.kirimData)
        font = QtGui.QFont()
        font.setPointSize(20)
        self.pushButton_2.setFont(font)
        self.pushButton_2.setStyleSheet("QPushButton {\n"
"    color: rgb(255, 255, 255);\n"
"    background-color: qlineargradient(spread:pad, x1:0, y1:0.505, x2:0.99435,     y2:0.517, stop:0 rgba(37, 150, 190, 255), stop:1 rgba(26, 81, 91, 255));\n"
"    border-radius: 15px;\n"
"    border: 1px;\n"
"}\n"
"\n"
"QPushButton:hover {\n"
"    background-color: rgb(37, 150, 190);\n"
"    color: rgb(0, 0, 0);\n"
"    border-radius:10px;\n"
"    border: 2px solid black;\n"
"}")
        self.pushButton_2.setObjectName("pushButton_2")
        self.verticalLayout.addWidget(self.pushButton_2)
        spacerItem3 = QtWidgets.QSpacerItem(2, 2, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.verticalLayout.addItem(spacerItem3)
        self.gridLayout_4.addWidget(self.widget_5, 1, 1, 1, 1)
        self.verticalLayout_2.addWidget(self.widget_6)
        self.horizontalLayout.addWidget(self.widget_2)
        self.gridLayout.addWidget(self.widget, 0, 0, 1, 1)
        self.updateDataTerbaru = Thread(target=self.updateData)
        self.updateDataTerbaru.start()
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MODBUSMON"))
        self.label_3.setText(_translate("MainWindow", "MODBUS CLIENT SERVER MONITORING"))
        self.label_4.setText(_translate("MainWindow", "IP"))
        self.pushButton_3.setText(_translate("MainWindow", "Connect"))
        self.label_5.setText(_translate("MainWindow", "PORT"))
        self.pushButton_4.setText(_translate("MainWindow", "Disconnect"))
        self.label_6.setText(_translate("MainWindow", "Status Koneksi"))
        self.label_7.setText(_translate("MainWindow", "Bagus"))
        self.label.setText(_translate("MainWindow", "SERVER"))
        self.pushButton.setText(_translate("MainWindow", "RESET"))
        self.label_2.setText(_translate("MainWindow", "CLIENT"))
        self.lineEdit_2.setText(_translate("MainWindow", " Silahkan isikan data baru"))
        self.pushButton_2.setText(_translate("MainWindow", "UPDATE"))

    def bacaData(self, address):
        result = self.client.read_holding_registers(address, 1)
        if result:
            return result[0]
        else:
            return None

    def kirimData(self):
        try:
            dataBaru = int(self.lineEdit_2.text())
            sleep(1)
            modifData = self.bacaData(dataBaru)
            self.lineEdit.setText(str(modifData))
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")

    def resetData(self):
        try:
            dataBaru = int(0)
            modifData = self.bacaData(dataBaru)
            self.lineEdit.setText(str(modifData))
            sleep(1)
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")

    def tulisData(self, value):
        self.client.write_single_register(self.address, value)

    def updateData(self):
        while True:
            dataLama = self.bacaData(0)
            self.lineEdit.setText(str(dataLama))
            self.plot(dataLama)

    def plot(self, data):
        self.ax.clear()
        self.ax.plot([0, 1, 2], [data, data + 10, data - 5])
        self.ax.set_xlabel('X Label')
        self.ax.set_ylabel('Y Label')
        self.canvas.draw()
    
if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())