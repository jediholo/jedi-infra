// Imports
const { InteractionResponseType, InteractionType, verifyKey } = require('discord-interactions');
const Discord = require('discord.js');

// Config
const CLIENT_PUBLIC_KEY = process.env.CLIENT_PUBLIC_KEY;
const WEBHOOK_ID = process.env.WEBHOOK_ID;
const WEBHOOK_TOKEN = process.env.WEBHOOK_TOKEN;
const ADMIN_ROLE_ID = process.env.ADMIN_ROLE_ID.split(',');
const ADMIN_COMMANDS = ['announce'];

// Webhook
const webhook = new Discord.WebhookClient(WEBHOOK_ID, WEBHOOK_TOKEN);

// Function to process command
async function processCommand(interaction) {
  // Check admin permissions
  if (ADMIN_COMMANDS.includes(interaction.data.name) && ADMIN_ROLE_ID.filter(role => interaction.member.roles.includes(role)).length == 0) {
    return {
      type: InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
      data: {
        content: `:no_entry: You are not allowed to use this command.`,
      },
    };
  }

  // Check command name
  switch (interaction.data.name) {
    case 'announce':
      // Publish announcement message using webhook
      await webhook.send(interaction.data.options[0].value);
      return {
        type: InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
        data: {
          content: `:white_check_mark: Announcement published successfully.`,
        },
      };

    default:
      // Unknown command
      return {
        type: InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
        data: {
          content: `:x: Unknown command '/${interaction.data.name}'`,
        },
      };
  }
}

// Interaction entrypoint
module.exports.interaction = async (req, res) => {
  // Verify the request
  const signature = req.get('X-Signature-Ed25519');
  const timestamp = req.get('X-Signature-Timestamp');
  const isValidRequest = await verifyKey(req.rawBody, signature, timestamp, CLIENT_PUBLIC_KEY);
  if (!isValidRequest) {
    return res.status(403).end('Bad request signature');
  }

  // Handle the payload
  const interaction = req.body;
  if (interaction && interaction.type === InteractionType.APPLICATION_COMMAND) {
    resData = await processCommand(interaction);
    if (resData != null) {
      res.send(resData);
    } else {
      res.send({
        type: InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
        data: {
          content: `:white_check_mark: Command executed successfully.`,
        }
      });
    }
  } else {
    res.send({
      type: InteractionResponseType.PONG,
    });
  }
};
