const admin = require('firebase-admin');
const serviceAccount = require('../firebaseServiceAccountKey.json');
const dotenv = require('dotenv');

dotenv.config();

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DB_URL,
});

const db = admin.firestore();
// \end{code}

module.exports = { admin, db };
