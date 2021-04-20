# example followed: https://gist.github.com/allskyee/7749b9318e914ca45eb0a1000a81bf56
from threading import Thread, Lock
import cv2
import time


class CameraThread:
    def __init__(self, port, width, height):
        self.source = cv2.VideoCapture(port, cv2.CAP_AVFOUNDATION)
        self.source.set(3, height)
        self.source.set(4, width)
        (self.ret, self.img) = self.source.read()
        self.started = False
        self.lock = Lock()

    def start(self):
        if self.started:
            print("camera thread already started!")
            return None

        self.started = True
        self.thread = Thread(target=self.update, args=())
        self.thread.start()
        return self

    def update(self):
        while self.started:  # while the thread is running
            ret, img = self.source.read()
            self.lock.acquire()  # it's my turn to use the thread
            self.ret, self.img = ret, img
            self.lock.release()  # ok i'm done
            time.sleep(0.5)

    def read_frame(self):  # return the img read from update()
        self.lock.acquire()
        img = self.img.copy()
        self.lock.release()
        return img

    def stop(self):
        self.started = False
        self.thread.join()  # tells that the thread is finished

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.source.release()
