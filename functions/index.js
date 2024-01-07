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

exports.monitorTurbidity = functions.database.ref("/ERROR_CODES/turbidityCorrection_ERROR").onUpdate(async (change, context) => {
    const newValue = change.after.val();

    if (newValue === "301" || newValue === "302" || newValue == "303" || newValue == "304") {
        let title, body;

        if (newValue === "301") {
            title = "Turbidity Alert";
            body = "High turbidity levels.";
        } else if (newValue === "302") {
            title = "Turbidity Alert";
            body = "Water Turbidity High! AQUAssist will initiate a 15% water change to optimize water quality.";
        } else if (newValue === "303") {
            title = "Turbidity Alert";
            body = "Water Turbidity High! AQUAssist will initiate another 15% water change to optimize water quality.";
        } else if (newValue === "304") {
            title = "Turbidity Alert";
            body = "AQUAssist cannot optimize water turbidity after 2 water corrective iterations. Please perform manual maintenance.";
        }

        const payload = {
            notification: {
                title,
                body
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

exports.monitorpH = functions.database.ref("ERROR_CODES/phCorrection_ERROR").onUpdate(async (change, context) => {
    const newValue = change.after.val();

    if (newValue === '201' || newValue == '202' || newValue == '203' || newValue == '204' || newValue == '205' || newValue == '206'|| newValue == '207') {
        let title, body;

        if (newValue === '201') {
            title = "pH Level Alert";
            body = "pH Level Critical";
        } else if (newValue == '202') {
            title = "pH Level Alert";
            body = "pH Level Critical";
        } else if (newValue == '203') {
            title = "pH Level Alert";
            body = "pH Level Critical";
        } else if (newValue == '204') {
            title = "pH Level Alert";
            body = "pH Level Critical! AQUAssist will initiate a 10% water change to optimize water quality. ";
        } else if (newValue == '205') {
            title = "pH Level Alert";
            body = "pH Level Critical! AQUAssist will initiate another 15% water change to optimze water quality. System observations will follow. ";
        } else if (newValue == '206') {
            title = "pH Level Alert";
            body = "pH Level Critical! AQUAssist will initiate another 15% water change to optimze water quality. System observations will follow. ";
        } else if (newValue == '207') {
            title = "pH Level Alert";
            body = "AQUAssist cannot optimize pH levels after 3 water corrective iterations. Please perform manual maintenance. ";
        }

        const payload = {
            notification: {
                title,
                body
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