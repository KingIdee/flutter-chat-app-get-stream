const express = require('express');
const StreamChat = require('stream-chat').StreamChat;
const bodyParser = require('body-parser');
const app = express();

const client = new StreamChat('STREAM_API_KEY', 'STREAM_API_SECRET');

app.use(bodyParser.json());
app.post('/token', (req, res, next) => {
    const userToken = client.createToken(req.body.userId);
    res.json({success: 200, token: userToken});
});

app.listen(4000, _ => console.log('App listening on port 4000!'));