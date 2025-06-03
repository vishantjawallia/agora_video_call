const { admin } = require('../config/firebase');

async function sendCallNotification(targetFcmToken, callerName, channelName) {
  const message = {
    token: targetFcmToken,
    notification: {
      title: "Incoming Call",
      body: `${callerName || 'Someone'} is calling you.`,
    },
    data: {
      type: "video_call",
      channelName,
    },
  };

  return await admin.messaging().send(message);
}

module.exports = { sendCallNotification };
