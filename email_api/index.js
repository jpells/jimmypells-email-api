const { SESClient, SendEmailCommand } = require("@aws-sdk/client-ses");
const ses = new SESClient();

exports.handler = async (event) => {
  try {
    const data = JSON.parse(event.body);
    const params = {
      Destination: {
        ToAddresses: [process.env.TO_EMAIL],
      },
      Message: {
        Body: {
          Text: { Data: data.message },
        },
        Subject: { Data: data.subject },
      },
      Source: process.env.FROM_EMAIL,
    };

    const command = new SendEmailCommand(params);
    await ses.send(command);

    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": process.env.ALLOWED_CORS_ORIGIN,
      },
      body: JSON.stringify({ message: "Email sent!" }),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      headers: {
        "Access-Control-Allow-Origin": process.env.ALLOWED_CORS_ORIGIN,
      },
      body: JSON.stringify({ error: "Failed to send email" }),
    };
  }
};
