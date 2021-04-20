import cv2 as cv


class DetectorOpenCV:
    def __init__(self, confThreshold, nmsThreshold, inpWidth, inpHeight, config, weights):
        self.confThreshold = confThreshold
        self.nmsThreshold = nmsThreshold
        self.inpWidth = inpWidth
        self.inpHeight = inpHeight

        self.configFile = config
        self.weightFile = weights
        self.net = cv.dnn_DetectionModel(self.configFile, self.weightFile)
        self.net.setPreferableBackend(cv.dnn.DNN_BACKEND_OPENCV)
        self.net.setPreferableTarget(cv.dnn.DNN_TARGET_OPENCL_FP16)
        self.net.setInputParams(size=(self.inpWidth, self.inpHeight), scale=1 / 255, swapRB=True)
        self.model = self.net

        self.more_than_one_on_table = False  # indicates whether there's more than one object on the table.
        self.recognized = False

        self.classes = None
        self.scores = None
        self.boxes = None

    def detect(self, imgSource):
        classes, scores, boxes = self.model.detect(imgSource, confThreshold=self.confThreshold, nmsThreshold=self.nmsThreshold)

        self.classes = classes
        self.scores = scores
        self.boxes = boxes

        if len(classes) > 0:
            if len(classes) > 1:
                self.more_than_one_on_table = True
            else:
                self.more_than_one_on_table = False
            return classes[0][0]  # returns only one recognition result
        else:
            self.more_than_one_on_table = False
            self.recognized = False
            return -1

    def more_than_one(self):
        return self.more_than_one_on_table

    def draw(self, window_name, imgSource):
        classes, scores, boxes = self.classes, self.scores, self.boxes
        for (classid, score, box) in zip(classes, scores, boxes):
            color = (255, 255, 255)
            label = "%s : %f" % (classid[0], score)
            cv.rectangle(imgSource, box, color, 2)
            cv.putText(imgSource, label, (box[0], box[1] - 10), cv.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)
        cv.imshow(window_name, imgSource)



