# This Python file uses the following encoding: utf-8
import sys
import os
import json
import time

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal

#import Result_reporter
import socket

class Communicator(QObject):
    def __init__(self):
        QObject.__init__(self)
        # load JSON database
        with open('test_json.json') as file:
            self.json_db = json.load(file)

        self.connection = None

    @Slot(result = 'int')
    def init_TCP(self):
        # initiate TCP port
        host, port = '127.0.0.1', 25001
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((host, port))
        print(host, port, "Waiting for recognition backend... Please run 'Backend.py' and complete the camera setup process.")
        self.sock.listen(1)
        self.connection, self.address = self.sock.accept()
        time.sleep(1)
        print(f"connected by {self.address}")
        self.connection.settimeout(1)
        self.connection.setblocking(False)  # so the action of receiving recognition results won't block my beautiful UI animation. UwU
        return 1

    @Slot(result='QVariant')
    def get_json_db(self):
        return self.json_db

    @Slot(str, result=str)
    def get_results(self, arg):
        try:
            data = self.connection.recv(512)
            decoded_data = data.decode('utf-8')
            return decoded_data
        except:
            return -1

    @Slot(result = 'QVariant')
    def get_connection(self):
        return self.connection

    ''' no it is not a good idea to let the UI poll for the recognition results, this way blocks operations so the UI will become laggy
    @Slot(result='int')
    def update(self): # updates the current recognition status, triggers the
        self.data_source.update()
        self.recognized = self.data_source.recognized
        self.current_object = self.data_source.recognized_object
        self.more_than_one = self.data_source.more_than_one
        # print('recognition triggered!')
        return 0

    @Slot(result='bool')
    def get_recognized(self):
        return self.recognized

    @Slot(result='int')
    def get_current_object(self):
        return self.current_object

    @Slot(result='bool')
    def get_more_than_one(self):
        return self.more_than_one
    '''

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))
    backend = Communicator()
    engine.rootContext().setContextProperty("backend", backend)


    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
