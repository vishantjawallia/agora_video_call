const express = require('express');
const router = express.Router();
const { db } = require('../config/firebase');

router.post('/save-token', async (req, res) => {
  const { fcmToken, uid } = req.body;

  try {
    await db.collection("users").doc(uid).set({ fcmToken }, { merge: true });
    res.status(200).json({ message: "Token saved successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;

/**
 * @swagger
 * /user/save-token:
 *   post:
 *     summary: Save the FCM token for the user
 *     tags:
 *       - Firebase
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - uid
 *               - fcmToken
 *             properties:
 *               uid:
 *                 type: string
 *                 description: The Firebase UID of the user
 *                 example: "user-abc123"
 *               fcmToken:
 *                 type: string
 *                 description: The FCM token to save
 *                 example: "your-fcm-token-here"
 *     responses:
 *       200:
 *         description: Token saved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Token saved successfully
 *       500:
 *         description: Internal server error
 */
