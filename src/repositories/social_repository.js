const google = require('googleapis').google;
const OAuth2 = google.auth.OAuth2;

module.exports.getUserGoogleInfo = async (googleToken) => {
    var socialRes;
    try{
        const oAuth2Client = new OAuth2();
        oAuth2Client.setCredentials({access_token: googleToken});
        const oauth2 = google.oauth2({
            auth: oAuth2Client,
            version: 'v2'
        });
        socialRes = await oauth2.userinfo.get();
    }catch(e){
        throw Error('can not authentication user');
    }
    return socialRes.data;
}