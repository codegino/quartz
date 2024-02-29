Because Auth0 does not support Post Registration Action, a workaround must be made


```js
const axios = require("axios");

/**
* Handler that will be called during the execution of a PostLogin flow.
*
* @param {Event} event - Details about the user and the context in which they are logging in.
* @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
*/
exports.onExecutePostLogin = async (event, api) => {
  if (event.authorization) {
    api.accessToken.setCustomClaim(`${event.secrets.AUDIENCE}/claims/username`, event.user.email);
  }

  // Only register on first login
  if (event.stats.logins_count > 1) {
    return
  }

  async function getAccessToken() {
    const tokenUrl = `${event.secrets.DOMAIN}/oauth/token`;
    const payload = {
      client_id: event.secrets.CLIENT_ID,
      client_secret: event.secrets.CLIENT_SECRET,
      audience: event.secrets.AUDIENCE,
      grant_type: 'client_credentials'
    };

    try {
      const response = await axios.post(tokenUrl, payload);
      return response.data.access_token;
    } catch (error) {
      console.log('Error getting access token:', error);
      throw error;
    }
  }

  return await axios.post(`${event.secrets.API_HOST_URL}/api/users`, {
    firstName: event.user?.given_name ?? "",
    lastName: event.user?.family_name ?? "",
    username: event.user?.email ?? user_name
  },{
    headers: {
      'Content-Type': 'application/json',
      'x-auth': event.secrets.AUTH0_API_SECRET_KEY,
      'Authorization': `Bearer ${await getAccessToken()}`
    },
  })
  .then(e => {
    console.log(e.data)
  }).catch(function (error) {
    if (error.response) {
      console.log(error.response.data);
      console.log(error.response.status);
      console.log(error.response.headers);
    }
  });
};
```