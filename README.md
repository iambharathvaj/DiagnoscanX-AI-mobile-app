# DiagnoscanX-AI-mobile-app
Deep Learning based MVP for a MedTech AI startup prototype using Flutter with payment integration

## DiagnoscanX
DiagnoscanX is an AI powered mobile app which can classify patient's Chest X-ray images as affected by PNEUMONIA or NORMAL.

## Dataset- from Kaggle
https://www.kaggle.com/paultimothymooney/chest-xray-pneumonia

## Training Process - Using Transfer Learning
DiagnoscanX uses the pre-trained Inception v3 model as a base model and it uses transfer learning technique to build on top of it in order to gain knowledge (train) from our Pneumonia dataset.

## User login/authentication and storage - Database
DiagnoscanX uses Firebase to store the details of the users and for user authentication

## Payment Service
Using Stripe

## Deploying the Web API
DiagnoscanX uses python (TensorFlow + Keras) to build the deep learning model, store it as a .pkl file and host it on the render platform

## Mobile app - UI
Single codebase to build both Android and iOS apps using Flutter (Dart language)


## Future improvements / ideas
To make our image classifier free from Adversarial attacks (for example, FGSM attack) - Need to build a defense mechanism
