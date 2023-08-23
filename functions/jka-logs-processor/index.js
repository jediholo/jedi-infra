// Process function
async function processLog(log) {
  console.log(JSON.stringify(log));
}

// Process entrypoint
module.exports.process = async (message, context) => {
  const data = Buffer.from(message.data, 'base64').toString();
  const log = JSON.parse(data);
  await processLog(log);
};
