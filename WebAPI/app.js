'use strict';

const PORT = process.env.PORT || 3002;

const app = require('./config/app');

const server = app.listen(PORT, () => console.log(`Magic happening at http://localhost:${PORT}`));