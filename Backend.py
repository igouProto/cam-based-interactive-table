# source of sample code followed: https://gist.github.com/YashasSamaga/e2b19a6807a13046e399f4bc3cca3a49
# stripped some excessive stuff
import errno
import json
import socket

import cv2 as cv
import numpy as np
import time

import DetectorOpenCV
import CameraThread


def list_ports():
    # Test all the ports and returns a tuple with the available ports and the ones that are working.
    is_working = True
    dev_port = 0
    note = '----\n'
    while is_working:
        camera = cv.VideoCapture(dev_port, cv.CAP_AVFOUNDATION)
        if not camera.isOpened():
            is_working = False
            print("Port %s is not working." % dev_port)
        else:
            is_reading, img = camera.read()  # attempt to read something from the present camera
            w = camera.get(3)
            h = camera.get(4)
            label = input("Watch the LED! Which camera is on? take note...")
            if is_reading:
                note += ("Port %s is working and reads images (%s x %s) [%s]\n" % (dev_port, h, w, label))
            else:
                note += ("Port %s for camera (%s x %s) is present but does not reads. [%s]\n" % (dev_port, h, w, label))
        dev_port += 1
    print(note)


# Initialize the parameters
confThreshold = 0.85  # Confidence threshold
nmsThreshold = 0.3  # Non-maximum suppression threshold for cleaning up overlapping bounding boxes
inpWidth = 480  # Width of network's input image
inpHeight = 480  # Height of network's input image


# Load names of classes
classesFile = "obj.names"
classes = None
with open(classesFile, 'rt') as f:
    classes = f.read().rstrip('\n').split('\n')
    print(classes)

modelCfgSide = "snacks_0307.cfg"
modelWeightsSide = "snacks_last_0307.weights"

detector_A = DetectorOpenCV.DetectorOpenCV(confThreshold=confThreshold,
                                           nmsThreshold=nmsThreshold,
                                           inpWidth=inpWidth,
                                           inpHeight=inpHeight,
                                           config=modelCfgSide,
                                           weights=modelWeightsSide)

detector_B = DetectorOpenCV.DetectorOpenCV(confThreshold=confThreshold,
                                           nmsThreshold=nmsThreshold,
                                           inpWidth=inpWidth,
                                           inpHeight=inpHeight,
                                           config=modelCfgSide,
                                           weights=modelWeightsSide)

# setup the cameras
list_ports()
side = int(input('enter the port to use for side-view: '))
side2 = int(input('enter the port to use for side-view: '))

# setup camera threads
cam2 = CameraThread.CameraThread(side, 640, 480)
cam3 = CameraThread.CameraThread(side2, 640, 480)
cam2.start()
cam3.start()

recognition_array = [-1, -1, -1, -1, -1]  # merge the recognition results of the 2 cameras into this array
more_than_one = False
recognized = False

host, port = '127.0.0.1', 25001
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((host, port))

# prepare for the dict for passing the recognition result
recog_result = {
    'recognized': False,
    'more_than_one': False,
    'id': '-1',
}

print('recognition is now running...remember to move the client window to the table\'s surface.')

# main recognition and reporting loop
while cv.waitKey(1) < 1:
    frame2 = cam2.read_frame()
    frame3 = cam3.read_frame()

    resultA = detector_A.detect(frame2)
    # print(f"detector_A: [{detector_A.more_than_one()}]{resultA}")
    recognition_array.append(resultA)
    if len(recognition_array) >= 5:
        recognition_array.pop(0)
    resultB = detector_B.detect(frame3)
    # print(f"detector_B: [{detector_B.more_than_one()}]{resultB}")
    recognition_array.append(resultB)
    if len(recognition_array) >= 5:
        recognition_array.pop(0)

    # prepare to report the recog result
    common_in_list = max(recognition_array, key=recognition_array.count)  # yes, I just let the 2 cameras race for the result.
    print(f'[{more_than_one}][{recognized}][{common_in_list}] {recognition_array}')

    more_than_one = (detector_A.more_than_one() or detector_B.more_than_one()) or (
                (resultA != resultB) and ((resultA != -1) and (resultB != -1)))
    recognized = common_in_list != -1

    recog_result['recognized'] = bool(recognized)
    recog_result['more_than_one'] = bool(more_than_one)
    recog_result['id'] = int(common_in_list)

    # cv.imshow('SIDE_A', frame2)
    # cv.imshow('SIDE_B', frame3)

    result_to_be_sent = json.dumps(recog_result).encode('utf-8')
    print(result_to_be_sent)
    try:
        sock.sendall(result_to_be_sent)
    except IOError as e:
        if e.errno == errno.EPIPE:
            print('UI process was terminated.')
            break
    # the UI will first check for more_than_one.
    # if there's more than one item on the table,
    # the incoming recognition will be ignored by the ui, and the Ui will prompt the user to keep only one object on the table.
    time.sleep(0.45)  # seems like i don't need that much frame rate

# sock.sendall("stop".encode("utf-8"))
sock.close()
cv.destroyAllWindows()
print('backend terminated.')
cam2.stop()
cam3.stop()
