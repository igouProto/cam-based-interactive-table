Steps for running the interactive table software:

0. Connect the display of the table and the cameras to the computer.

1. Run 'main.py' by Python. You should see a message like this in the console:

'127.0.0.1 25001 Waiting for recognition backend... Please run 'Backend.py' and complete the camera setup process.'

2. Upon seeing the above message, run 'Backend.py' by Python in a separate terminal window.

3. Go through the camera process of 'Backend.' The UI will begin running once the camera setup is finished.

4. Move the UI window to the display of the table and put it into full screen.

5. To stop the process, kill 'Backend.py' first. You may need to press ctrl+c multiple times since there are separate threads grabbing frames from the camera.

6. Then quit the UI program by closing the window. (Kill 'main.py' if needed)

-

How to terminate both process correctly:

Terminate the UI window, the backend will quit automatically.
