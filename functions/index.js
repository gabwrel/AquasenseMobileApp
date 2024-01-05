const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.monitorSystemError = functions.database.ref("/NOTIFICATIONS/system_ERROR").onUpdate(async (change, context) => {
    const newValue = change.after.val();

    if (newValue === "1") {
        const payload = {
            notification: {
                title: "System Error",
                body: "System failed to start"
            }
        };

        const tokensSnapshot = await admin.database().ref("fcm-token").once("value");
        const tokens = tokensSnapshot.val();

        if (tokens) {
            const deviceTokens = Object.keys(tokens);

            const notifications = deviceTokens.map(deviceToken => {
                return admin.messaging().sendToDevice(deviceToken, payload);
            });

            return Promise.all(notifications);
        }
    }

    return null;
});
