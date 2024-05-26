const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendMotionDetectedNotification = functions.firestore
  .document("sensorData/{docId}")
  .onUpdate((change, context) => { // Parentheses already present here
    const data = change.after.data();
    const previousData = change.before.data();

    if (data.motion_detected && !previousData.motion_detected) {
      const payload = {
        notification: {
          title: "Motion Alert",
          body: "Motion has been detected!",
        },
        topic: "motionAlerts",
      };

      return admin.messaging().send(payload)
        .then((response) => { // Parentheses added around 'response'
          console.log("Successfully sent message:", response);
          return null;
        })
        .catch((error) => { // Parentheses added around 'error'
          console.log("Error sending message:", error);
          return null;
        });
    } else {
      return null;
    }
  });
