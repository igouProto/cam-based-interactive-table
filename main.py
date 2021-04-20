# This Python file uses the following encoding: utf-8
import sys
import os
import json
import time

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal

import socket


class Communicator(QObject):
    def __init__(self):
        QObject.__init__(self)
        # load JSON database
        with open('test_json.json') as file:
            self.json_db = json.load(file)

        self.sock = None
        self.connection = None
        self.address = None

    @Slot(result='int')
    def init_TCP(self):
        # initiate TCP port
        host, port = '127.0.0.1', 25001
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((host, port))
        print(host, port,
              "Waiting for recognition backend... Please run 'Backend.py' and complete the camera setup process.")
        self.sock.listen(1)
        self.connection, self.address = self.sock.accept()
        time.sleep(1)
        print(f"connected by {self.address}")
        self.connection.settimeout(1)
        self.connection.setblocking(
            False)  # so the action of receiving recognition results won't block my beautiful UI animation. UwU
        return 1

    @Slot(result='QVariant')
    def get_json_db(self):
        return self.json_db

    @Slot(str, result=str)
    def get_results(self, arg):  # get the recognition results sent from the backend
        try:
            data = self.connection.recv(512)
            decoded_data = data.decode('utf-8')
            return decoded_data
        except:
            return -1

    @Slot(result='QVariant')
    def get_connection(self):
        return self.connection


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))
    backend = Communicator()
    engine.rootContext().setContextProperty("backend", backend)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
