const express = require('express');
const router = express.Router();
const { RtcTokenBuilder, RtcRole } = require('agora-access-token');

/**
 * @swagger
 * /agora/generate-token:
 *   post:
 *     summary: Generate an Agora RTC token
 *     tags:
 *       - Agora
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               channelName:
 *                 type: string
 *                 example: "agoraChannel123"
 *               uid:
 *                 type: integer
 *                 example: 123456
 *     responses:
 *       200:
 *         description: Token generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   example: "0068d22cb493d054b3794615e4e85d70544..."
 *       400:
 *         description: Missing or invalid request body
 *       500:
 *         description: Internal server error
 */

router.post('/generate-token', (req, res) => {
  const { channelName, uid } = req.body;

  try {
    if (!channelName || uid == null) {
      // return res.status(400).json({ message: "channelName and uid are required" });
    }

    const appID = process.env.AGORA_APP_ID;
    const appCertificate = process.env.AGORA_APP_CERT;
    const role = RtcRole.PUBLISHER;
    const expirationTimeInSeconds = 3600;

    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    const token = RtcTokenBuilder.buildTokenWithUid(
      appID,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpiredTs
    );

    res.json({ token });
  } catch (err) {
    console.error('Token generation error:', err.message);
    res.status(500).json({ error: 'Failed to generate token' });
  }
});

module.exports = router;
