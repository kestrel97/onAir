// var FCM = require('fcm-node')
// var serverKey = require('utils/onair-ab0e2-firebase-adminsdk-jmqrz-f979f05dd0.json')
// var fcm = new FCM(serverKey)

function sendNotification(fcm_token) {
    // var message = {
    //     to: fcm_token, 
    //     // collapse_key: 'your_collapse_key',
        
    //     notification: {
    //         title: 'OnAir - Personalized news broadcasting portal', 
    //         body: 'There is a new request near to your location which you can assist with.' 
    //     }
    // }
    
    // fcm.send(message, function(err, response){
    //     if (err) {
    //         console.log("Something has gone wrong!")
    //         console.log(err);
    //     } else {
    //         console.log(response.results);
    //         console.log("Successfully sent with response: ", response)
    //     }
    // })
}

module.exports = {
    sendNotification
}