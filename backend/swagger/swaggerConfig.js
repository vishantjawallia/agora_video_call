const swaggerJSDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Agora Video Call API',
      version: '1.0.0',
      description: 'API documentation for the Agora video calling backend',
    },
    servers: [
      {
        url: 'http://192.168.56.1:3000/api',
      },
    ],
  },
  apis: ['./routes/*.js'], // Swagger will scan route files for documentation
};

const swaggerSpec = swaggerJSDoc(options);

function setupSwagger(app) {
  app.use('/api-docs',
    (req, res, next) => {
  const host = req.get('host');
  swaggerSpec.servers = [
    {
      url: `${req.protocol}://${host}/api`,
    },
  ];
  next();
}, swaggerUi.serve, swaggerUi.setup(swaggerSpec),);
}

module.exports = setupSwagger;
