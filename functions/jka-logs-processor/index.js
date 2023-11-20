// Imports
const Discord = require('discord.js');
const Rcon = require('./rcon.js');

// Config
const COMMLINK_WEBHOOK_URL = process.env.COMMLINK_WEBHOOK_URL;
const COUNCIL_WEBHOOK_URL = process.env.COUNCIL_WEBHOOK_URL;

// Webhook
const commlinkWebhook = new Discord.WebhookClient({url: COMMLINK_WEBHOOK_URL});
const councilWebhook = new Discord.WebhookClient({url: COUNCIL_WEBHOOK_URL});

// Process function
async function processLog(log) {
  console.log(JSON.stringify(log));
  const commandargs = log.commandargs?.replaceAll(/\^[0-9a-zA-Z]/g, '').trim();
  const playername = log.playername?.replaceAll(/:+JEDI:+/g, '').replaceAll('=', ' ').trim();
  const targetname = log.targetname?.replaceAll(/:+JEDI:+/g, '').replaceAll('=', ' ').trim();
  switch (log.commandname) {
    case 'say':
      // Don't invoke Him.
      if (commandargs.match(/Soh Raun/i)) {
        await Rcon.exec(log.servername, 'rpeffect camerashake 1 1');
      }
      break;
    case 'comm':
      // Relay commlink to Discord channel
      if (targetname == 'Broadcast') {
        await commlinkWebhook.send({
          content: `Broadcast @here: ${commandargs}`,
          username: playername
        });
      } else {
        await commlinkWebhook.send({
          content: `To ${targetname}: ${commandargs}`,
          username: playername
        });
      }
      break;
    case 'rpnotify':
      // Relay notification to Discord channel
      const questMatch = /message: (.* has completed the .* quest!)/i.exec(commandargs);
      if (questMatch !== null) {
        await councilWebhook.send(questMatch[1]);
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
