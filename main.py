from PyQt5 import QtWidgets
import sys
from app.controller import modbusController
    
def main():
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    modbusController(MainWindow)
    sys.exit(app.exec_())
    
if __name__ == "__main__":
    main()