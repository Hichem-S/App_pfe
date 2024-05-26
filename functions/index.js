const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendMotionDetectedNotification = functions.firestore
    .document("sensorData/{docId}")
    .onUpdate((change, context) => {
      const data = change.after.data();
      const previousData = change.before.data();

      // Check if motion_detected has changed to true
      if (data.motion_detected && !previousData.motion_detected) {
        const payload = {
          notification: {
            title: "Motion Alert",
            body: "Motion has been detected!",
          },
          topic: "motionAlerts",
        };

        // Send a message to devices subscribed to the "motionAlerts" topic.
        return admin.messaging().send(payload)
          .then((response) => {
            console.log("Successfully sent message:", response);
            return null;
          })
          .catch((error) => {
            console.log("Error sending message:", error);
            return null;
          });
      } else {
        return null;
      }
    });
