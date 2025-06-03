const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const app = express();
// const swaggerUi = require('swagger-ui-express');
// const swaggerSpec = require('./swagger/swaggerConfig');

dotenv.config();

// Swagger
const setupSwagger = require('./swagger/swaggerConfig');

app.use(cors());
app.use(bodyParser.json());




// Routes
const userRoutes = require('./routes/user');
const agoraRoutes = require('./routes/agora');
const fcmRoutes = require('./routes/fcm');

app.use('/api/user', userRoutes);
app.use('/api/agora', agoraRoutes);
app.use('/api/notify', fcmRoutes);

app.get("/", (req, res) => res.send("Backend is running ✅"));

// after route definitions

// Swagger setup
setupSwagger(app);

app.listen(process.env.PORT || 3000, () => {
  console.log(`Server running on http://localhost:${process.env.PORT || 3000}`);
});