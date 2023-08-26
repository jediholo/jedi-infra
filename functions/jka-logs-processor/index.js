// Imports
const Discord = require('discord.js');
const Rcon = require('./rcon.js');

// Config
const COMMLINK_WEBHOOK_URL = process.env.COMMLINK_WEBHOOK_URL;

// Webhook
const commlinkWebhook = new Discord.WebhookClient({url: COMMLINK_WEBHOOK_URL});

// Process function
async function processLog(log) {
  console.log(JSON.stringify(log));
  switch (log.commandname) {
    case 'say':
      // Don't invoke Him.
      if (log.commandargs.match(/Soh Raun/i)) {
        await Rcon.exec(log.servername, 'rpeffect camerashake 1 1');
      }
      break;
    case 'comm':
      // Relay commlink to Discord channel
      const playerName = log.playername.replaceAll(/:+JEDI:+/g, '').replaceAll('=', ' ').trim();
      if (log.targetname == 'Broadcast') {
        await commlinkWebhook.send({
          content: `Broadcast @here: ${log.commandargs}`,
          username: playerName
        });
      } else {
        await commlinkWebhook.send({
          content: `To ${log.targetname}: ${log.commandargs}`,
          username: playerName
        });
      }
      break;
  }
}

// Process entrypoint
module.exports.process = async (message, context) => {
  const data = Buffer.from(message.data, 'base64').toString();
  const log = JSON.parse(data);
  await processLog(log);
};
