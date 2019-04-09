const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const cors = require('cors');
const passport = require('passport');

const app = express();

const port = 3000;

// CORS Middleware
app.use(cors());

// Body Parser Middleware
app.use(bodyParser.json());

// Passport Middleware
app.use(passport.initialize());
app.use(passport.session());

// indexRoute
app.get('/', (req,res) => {
  res.send("Invalid Endpoint");
})

app.listen(port, () => {
  console.log("server started @ port: "+port);
})