from time import sleep
from pyModbusTCP.client import ModbusClient
from app.view import Ui_MainWindow
from threading import Thread

class modbusController():
    def __init__(self, MainWindow):
        self.address = ''
        self.client = ModbusClient(host='127.0.0.1', port=9999, auto_open=True)
        self.data = ''
        self.MainWindow = MainWindow
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self.MainWindow)
        self.MainWindow.show()
        self.updateDataTerbaru = Thread(target=self.updateData)
        self.updateDataTerbaru.start()
        self.ui.pushButton.clicked.connect(self.resetData)
        self.ui.pushButton_2.clicked.connect(self.kirimData)

    def bacaData(self):
        self.result = self.client.read_holding_registers(self.address, 1)
        if self.result:
            return self.result[0]
        else:
            return None

    def kirimData(self):
        try:
            dataBaru = int(self.ui.lineEdit_2.text())
            sleep(1)
            modifData = self.bacaData(dataBaru)
            self.ui.lineEdit.setText(str(modifData))
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")

    def resetData(self):
        try:
            dataBaru = int(0)
            modifData = self.bacaData(dataBaru)
            self.ui.lineEdit.setText(str(modifData))
            sleep(1)
        except Exception as e:
            print(f"Terjadi kesalahan: {e}")

    def tulisData(self):
        self.client.write_single_register(self.address, self.value)

    def updateData(self):
        while True:
            dataLama = self.bacaData(0)
            self.ui.lineEdit.setText(str(dataLama))
            self.plot(dataLama)

    def plot(self):
        self.ax.clear()
        self.ax.plot([0, 1, 2], [self.data, self.data + 10, self.data - 5])
        self.ax.set_xlabel('X Label')
        self.ax.set_ylabel('Y Label')
        self.canvas.draw()