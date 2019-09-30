# hack-a-thing-2

Hack-a-thing 2 for CS98

Qirong Li and Xinchen (Olivia) Zhao

### Our Project

The first part is to use set up the UI and the Earth using a scene kit. We  followed [this tutorial](https://www.youtube.com/watch?v=3rpNDENQgPM) to set up the scene, a camera, the Earth, the particle system in the background, and the lighting.

The second part is to use ARKit to implement placing the Earth in the augmented reality world on your phone. We also implement plane detection and light estimation which allow us to place the earth above the plane detected and adjust the lighting of the Earth based on the light of surroundings. For this part we followed [this tutorial](https://www.youtube.com/watch?v=4aIVHV5Q7a0) for AR setup and [this tutorial](https://www.youtube.com/watch?v=mkD5Jw-bLLs) for plane detceetion and light estimation.

### How It Works

For the ar version of the app, open the app and it will automatically detect the plane your camera is capturing. Touch the plane to place an Earth above it. Change the lighting of the surroudings and observe how the 3D earth changes with the lighting.

<img src="IMG_3788.PNG" style="float: right;" width="300">

### Distribution of Work

Qirong Li:

Olivia Zhao: 
- Add AR feature to the app using ARKit
- Implement plane detection
- Implement light estimation

### What We Learned

We learned how to use SceneKit together with ARKit to put 3D Objects into the real world. We also learned how to use ARKit to detect plane surfaces and how 3D objects can be affected by its environment using light estimation.


### What Didn't Work

We didn't have time to implement zooming the earth in the AR versison.
