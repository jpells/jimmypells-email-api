const AWS = require("aws-sdk");
const ses = new AWS.SES();

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

    await ses.sendEmail(params).promise();

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
