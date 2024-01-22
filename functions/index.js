const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

async function sendNotification(newValue, category) {
    let title, body;

    switch (category) {
        case 'system':
            title = "System Error";
            body = "System failed to start";
            break;
        case 'turbidity':
            switch (newValue) {
                case '301':
                    title = "Turbidity Alert";
                    body = "High turbidity levels.";
                    break;
                case '302':
                    title = "Turbidity Alert";
                    body = "Water Turbidity High! AQUAssist will initiate a 15% water change to optimize water quality.";
                    break;
                case '303':
                    title = "Turbidity Alert";
                    body = "Water Turbidity High! AQUAssist will initiate another 15% water change to optimize water quality.";
                    break;
                case '304':
                    title = "Turbidity Alert";
                    body = "AQUAssist cannot optimize water turbidity after 2 water corrective iterations. Please perform manual maintenance.";
                    break;
            }
            break;
        case 'pH':
            switch (newValue) {
                case '201':
                case '202':
                case '203':
                    title = "pH Level Alert";
                    body = "pH Level Critical";
                    break;
                case '204':
                    title = "pH Level Alert";
                    body = "pH Level Critical! AQUAssist will initiate a 10% water change to optimize water quality.";
                    break;
                case '205':
                case '206':
                    title = "pH Level Alert";
                    body = "pH Level Critical! AQUAssist will initiate another 15% water change to optimize water quality. System observations will follow.";
                    break;
                case '207':
                    title = "pH Level Alert";
                    body = "AQUAssist cannot optimize pH levels after 3 water corrective iterations. Please perform manual maintenance.";
                    break;
            }
            break;
        case 'temperature':
            switch (newValue) {
                case '401':
                    title = "Water Temperature Alert";
                    body = "Water temperature critical";
                    break;
                case '402':
                    title = "Water Temperature Alert";
                    body = "Low temperature! AQUAssist will now activate heater.";
                case '403':
                    title = "Water Temperature Alert";
                    body = "High temperature! AQUAssist will now deactivate heater.";
            }
    }

    if (title && body) {
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
}

exports.monitorSystemError = functions.database.ref("/NOTIFICATIONS/system_ERROR").onUpdate((change, context) => {
    const newValue = change.after.val();
    if (newValue === "1") {
        return sendNotification(newValue, 'system');
    }
    return null;
});

exports.monitorTurbidity = functions.database.ref("/ERROR_CODES/turbidityCorrection_ERROR").onUpdate((change, context) => {
    const newValue = change.after.val();
    if (['301', '302', '303', '304'].includes(newValue)) {
        return sendNotification(newValue, 'turbidity');
    }
    return null;
});

exports.monitorpH = functions.database.ref("ERROR_CODES/phCorrection_ERROR").onUpdate((change, context) => {
    const newValue = change.after.val();
    if (['201', '202', '203', '204', '205', '206', '207'].includes(newValue)) {
        return sendNotification(newValue, 'pH');
    }
    return null;
});

exports.monitorTemperature = functions.database.ref("ERROR_CODES/temperature_ERROR").onUpdate((change, context) => {
    const newValue = change.after.val();
    if (['401', '402', '403'].includes(newValue)) {
        return sendNotification(newValue, 'temperature');
    }
    return null;
});
 