
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");


const sendNotification = async (topic, payload) => {
    try {
        const response = await admin.messaging().sendToTopic(topic, payload);
        logger.info("Successfully sent message:", response);
    } catch (error) {
        logger.error("Error sending message:", error);
    }
}

sendNotification("test", {
    notification: {
        title: "Test",
        body: "Test"
    }
});

