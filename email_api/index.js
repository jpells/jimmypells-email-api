const { SESClient, SendEmailCommand } = require("@aws-sdk/client-ses");
const ses = new SESClient();

async function verifyRecaptcha(recaptchaResponse) {
  const secretKey = process.env.RECAPTCHA_SECRET_KEY;
  const verifyUrl = "https://www.google.com/recaptcha/api/siteverify";

  const response = await fetch(verifyUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: `secret=${secretKey}&response=${recaptchaResponse}`,
  });

  const data = await response.json();

  // also check the score and action
  return data.success && data.score >= 0.5 && data.action === "contact_form";
}

exports.handler = async (event) => {
  try {
    const data = JSON.parse(event.body);

    // Check reCAPTCHA
    if (!data.recaptchaResponse) {
      return {
        statusCode: 400,
        headers: {
          "Access-Control-Allow-Origin": process.env.ALLOWED_CORS_ORIGIN,
        },
        body: JSON.stringify({ error: "reCAPTCHA verification is required" }),
      };
    }

    const isRecaptchaValid = await verifyRecaptcha(data.recaptchaResponse);
    if (!isRecaptchaValid) {
      return {
        statusCode: 400,
        headers: {
          "Access-Control-Allow-Origin": process.env.ALLOWED_CORS_ORIGIN,
        },
        body: JSON.stringify({ error: "reCAPTCHA verification failed" }),
      };
    }

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
