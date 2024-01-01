// Imports
const Discord = require('discord.js');
const Rcon = require('./rcon.js');

// Config
const COMMLINK_WEBHOOK_URL = process.env.COMMLINK_WEBHOOK_URL;
const COUNCIL_WEBHOOK_URL = process.env.COUNCIL_WEBHOOK_URL;
const COMMLINK_TARGETS = {
  'broadcast':  '<@&700727212457984081>', // @Resident
  'class':      '<@&501782073565118484> <@&501781730269593601>', // @Jedi Initiate @Jedi Padawan
  'students':   '<@&501782073565118484> <@&501781730269593601>', // @Jedi Initiate @Jedi Padawan
  'initiates':  '<@&501782073565118484>', // @Jedi Initiate
  'padawans':   '<@&501781730269593601>', // @Jedi Padawan
  'knights':    '<@&501781105272160285>', // @Jedi Knight
  'masters':    '<@&501780638295392256>', // @Jedi Master
  'council':    '<@&501780010089185281> <@&501779685961760779>', // @Councilor @High Councilor
  'councilors': '<@&501780010089185281> <@&501779685961760779>', // @Councilor @High Councilor
};

// Webhook
const commlinkWebhook = new Discord.WebhookClient({url: COMMLINK_WEBHOOK_URL});
const councilWebhook = new Discord.WebhookClient({url: COUNCIL_WEBHOOK_URL});

// Process function
async function processLog(log) {
  console.log(JSON.stringify(log));
  const commandargs = (typeof log.commandargs === 'string') ? log.commandargs.replaceAll(/\^[0-9a-zA-Z]/g, '').trim() : undefined;
  const playername = (typeof log.playername === 'string') ? log.playername.replaceAll(/:+JEDI:+/g, '').replaceAll('=', ' ').trim() : undefined;
  const targetname = (typeof log.targetname === 'string') ? log.targetname.replaceAll(/:+JEDI:+/g, '').replaceAll('=', ' ').trim() : undefined;
  switch (log.commandname) {
    case 'comm':
      // Relay Temple comm to #commlink Discord channel
      if (log.servername == 'jedi-temple') {
        const commlinkTarget = COMMLINK_TARGETS[targetname.toLowerCase()] || `@${targetname}:`;
        await commlinkWebhook.send({
          content: `${commlinkTarget} ${commandargs}`,
          username: playername
        });
      }
      break;
    case 'rpnotify':
      // Relay notification to #council-chamber Discord channel
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
