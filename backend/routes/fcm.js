
const express = require('express');
const router = express.Router();
const { db } = require('../config/firebase');
const { sendCallNotification } = require('../utils/sendNotification');


/**
 * @swagger
 * /notify/call:
 *   post:
 *     summary: Send a call notification to a user via FCM
 *     tags:
 *       - Firebase
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               otherUserId:
 *                 type: string
 *                 description: The ID of the user to call
 *                 example: "target-user-id"
 *               channelName:
 *                 type: string
 *                 description: The Agora channel name for the call
 *                 example: "agora-channel-xyz"
 *               callerName:
 *                 type: string
 *                 description: The name of the user making the call
 *                 example: "John Doe"
 *     responses:
 *       200:
 *         description: Call notification sent successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Call notification sent
 *       400:
 *         description: Target user has no FCM token
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */


router.post('/call', async (req, res) => {
  const { otherUserId, channelName, callerName } = req.body;

  try {
    const userDoc = await db.collection("users").doc(otherUserId).get();
    if (!userDoc.exists) return res.status(404).json({ message: "User not found" });

    const targetToken = userDoc.data().fcmToken;
    if (!targetToken) return res.status(400).json({ message: "Target user has no FCM token" });

    await sendCallNotification(targetToken, callerName || "Someone", channelName);
    res.status(200).json({ message: "Call notification sent" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;

module.exports = router;
