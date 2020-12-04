const axios = require('axios');
const winston = require('winston');

const log = winston.createLogger({
  transports: [
    new winston.transports.Console({
      format: winston.format.simple(),
    }),
  ],
});

const OK_RESPONSES = [200, 204];

const checkResponse = (res) => {
  if (!OK_RESPONSES.includes(res.status)) {
    throw new Error(`API check returned HTTP ${res.status}: ${res.statusText}`);
  }
}

const apiChecks = async function () {
  log.info('Calling GET API on /')
  let response = await axios({
    method: 'get',
    url: `http://example.com/`,
    timeout: 2500,
  });
  checkResponse(response);
  log.debug(`API returned: `, response.data);
};

module.exports = {
  handler: async function () {
    return await apiChecks();
  },
};
