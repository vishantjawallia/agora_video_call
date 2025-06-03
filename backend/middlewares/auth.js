const { admin } = require('../config/firebase');

async function verifyFirebaseToken(req, res, next) {
  const token = req.headers.authorization?.split("Bearer ")[1];
  if (!token) return res.status(401).json({ message: "Token missing" });

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ message: "Invalid token" });
  }
}

module.exports = { verifyFirebaseToken };
