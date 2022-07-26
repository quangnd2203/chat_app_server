const google = require('googleapis').google;
const OAuth2 = google.auth.OAuth2;
const axios = require('axios');

module.exports.loginSocial = async (socialToken, accountType) => {
    switch(accountType){
        case 'facebook': 
            return await this.getUserFacebookInfo(socialToken);
        case 'google':
            return await this.getUserGoogleInfo(socialToken);
    }
} 

module.exports.getUserGoogleInfo = async (googleToken) => {
    try {
        const oAuth2Client = new OAuth2();
        oAuth2Client.setCredentials({ access_token: googleToken });
        const oauth2 = google.oauth2({
            auth: oAuth2Client,
            version: 'v2'
        });
        const socialRes = await oauth2.userinfo.get();
        return socialRes.data;
    } catch (e) {
        throw Error('can not authentication user');
    }
}

module.exports.getUserFacebookInfo = async (facebookToken) => {
    try{
        const facebookRes = await axios.get(`https://graph.facebook.com/me?access_token=${facebookToken}`);
        return facebookRes.data;
    }catch(e){
        throw Error('can not authentication user');
    }
}