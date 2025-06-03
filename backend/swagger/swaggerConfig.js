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
    // Do not set servers here statically
  },
  apis: ['./routes/*.js'], // Swagger will scan route files for documentation
};

const swaggerSpec = swaggerJSDoc(options);

function setupSwagger(app) {
  app.use('/api-docs', (req, res, next) => {
    // Build the full domain + port + /api dynamically
    const host = req.get('host'); // e.g., localhost:3000 or yourdomain.com
    const protocol = req.protocol; // http or https
    swaggerSpec.servers = [
      {
        url: `${protocol}://${host}/api`,
      },
    ];
    swaggerUi.setup(swaggerSpec)(req, res, next);
  });
  app.use('/api-docs', swaggerUi.serve);
}

module.exports = setupSwagger;
