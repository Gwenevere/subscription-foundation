# BigCommerce Subscription Foundation

🚀 Fast tracks builds of custom subscription experiences on the BigCommerce platform. Save 100s of hours.

💰 **Pre-integrated into Stripe Billing**, including authentication, merchant onboarding, subscription product management, subscription creation, and customer-facing subscription management.

💅 Utilizes the Channels Toolkit to provide a natively integrated subscription channel that fits nicely within the BigCommerce Control Panel.

| Product Management                       | Storefront Widget                     |
| ---------------------------------------- | ------------------------------------- |
| ![App Preview](sample-control-panel.png) | ![App Preview](sample-storefront.png) |

## Getting Started

Run:

```bash
npm install
npx prisma generate
npm run dev
```

_Note: `npx prisma generate` is what creates the DB client. If you miss this step, you'll see an error about it missing._

The app should now be running at: http://localhost:3000

## Environment

At a minimum, the following .env variables need to be updated for the app to run successfully

`NEXT_PUBLIC_APP_URL`: This should be a publicly accessible URL so the BigCommerce Stripe webhooks can be recieved. See the section on ngrok below.

`NEXT_PUBLIC_APP_ID`, `BC_APP_CLIENT_ID`, and `BC_APP_SECRET`: Follow the BigCommerce setup instructions below to get these.

`STRIPE_SECRET_KEY` and `NEXT_PUBLIC_STRIPE_CLIENT_ID`: Follow the Stripe setup instructions below to get these.

## Using ngrok

In order webhooks to be received, we recommend setting up ngrok locally on your machine to create a public facing URL that tunnels to your localhost: https://ngrok.com/

After you are running the app, you'd run this in directory ngrok is located within: `./ngrok http localhost:3000`

## BigCommerce Setup

This app gets access to the BigCommerce API by being installed on store. You'll need two things to test out the this flow:

1. Create BigCommerce store: go to https://www.bigcommerce.com/essentials/ and signup for a free trial if you don't have one

2. Create BigCommerce app: go to https://devtools.bigcommerce.com and create a draft app with the following callbacks (in the 2nd, 'Technical' step of app creation):

- Auth Callback URL: http://localhost:3000/api/auth
- Load Callback URL: http://localhost:3000/api/load
- Uninstall Callback URL: http://localhost:3000/api/uninstall

_If you are using ngrok, provide the ngrok URL instead of localhost._

In the next section below, set the following OAuth Scopes for the app:

```
Orders: MODIFY
Order Transactions: MODIFY
Products: MODIFY
Customers: MODIFY
Content: MODIFY
Carts: MODIFY
Channel Listings: MODIFY
Channel Settings: MODIFY
Information & Settings: MODIFY
Sites & Routes: READ-ONLY
Storefront API Tokens: GENERATE TOKENS
```

3. After creating the app, click on 'View Client ID' within the Dev Tools app list to get your Client ID and Client Secret that should be used in the local .env file.

## Stripe Setup

The app is setup to connect multiple BC Stores into one instance. Because of this, you’ll need two Stripe accounts. One for the ‘Connect’ account which the app will use and another which is what the merchant connects to the app and BC store (in the payments area) themselves.

To accomplish this:

1. Create a Stripe account you’ll use to accept payments and manage subscriptions on BigCommerce: https://stripe.com/
2. After that account is created, log into the Stripe Dashboard: https://dashboard.stripe.com/
3. Create a separate Stripe account that will be what the application uses to OAuth the merchant
   1. This can be done by selecting ‘+ New Account’ after clicking the name of the current account on the top left of your Stripe Dashboard
   2. Pick a name for this account, like ‘BigCommerce App’ that helps you differentiate it from the Stripe payment account
4. Get your Stripe secret key here: https://dashboard.stripe.com/test/apikeys
   1. Reveal the secret key under ’Standard Keys’
   2. Copy it into your STRIPE_SECRET_KEY env variable
5. Enable Stripe Connect for Platforms here: https://dashboard.stripe.com/test/connect/accounts/overview
   1. Select ‘Platform or Marketplace’ and continue
   2. While not required for testing, as part of going live later, you’ll need to fill out the platform profile. We suggest using these answers at that point:
      - Select ‘Other’ for industry
      - Select ‘From your seller/service provider’s website or app’ for where customers purchase products or services
      - Select ‘The name of the seller/service provider using your platform’ for whose name is on the customer’s credit card statement
      - Select ‘The seller/service provider using your platform’ for who should be contacted if customers have a dispute or complaint
6. Configure your Connect settings here: https://dashboard.stripe.com/test/settings/connect
   1. Copy ’Test mode client ID’ into your NEXT_PUBLIC_STRIPE_CLIENT_ID env variable
   2. Under ‘OAuth settings’ enable ‘OAuth for Standard accounts’
   3. Under ‘Redirects’ add the following URI: https://{your-app-domain}}/stripe/callback
      - Since we’re recommending using ngrok for local development the url would look similar to https://xxxx-xxx-xxx-xx-x.ngrok.io/stripe/callback
7. Your app should now be set up to handle Stripe OAuth, API requests, and webhooks
   1. Remember the merchant must OAuth the same Stripe payments account (what you created first) to this app that their BigCommerce store uses. Otherwise, the payment intent created when the shopper pays for the original order won’t be readable when creating subscriptions.
   2. When testing:
      - Make sure test mode is set to ‘Yes’ in the merchant’s Stripe settings within BigCommerce: https://login.bigcommerce.com/deep-links/settings/payment/stripev3
      - A vaulted card must be used when checking out. Turn on that functionality by going to ‘Stored Credit Cards’ in the Stripe payments section in BigCommerce and toggling on ‘Enable stored credit cards with Stripe’
      - When checking out on the BigCommerce store, you can save the card by logging in as a customer (or creating a new account during checkout) and selecting ‘save this card for later’ in the payments step.

## Managing Subscription Products

Subscription specific product configuration, like available intervals and the discount associated with them, is done within the app, inside Channel Manager. Only products that are listed on the subscription channel show up here. You can list products to the channel from within the Products section of the BigCommerce control panel.

## Prisma Database Config

To host publicly, you'll most likely want to switch away from SQLite. To do this you would:

1. Update the `/prisma/schema.prisma` file with a `provider` other `sqlite` (i.e. `mysql`. info on options are here: https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-schema/data-sources/)
2. Update the `DATABASE_URL` var in `/prisma/.env` to match your new DB connection string
3. Run `npx prisma migrate dev` (this creates tables and inserts related data as defined in `/prisma/migrations/*` into the DB)
4. Run `npx prisma generate` (this generates a new client for the app using the new DB provider setting)

After all this, if you run `npx prisma studio` you'll be able to access this database locally via a visual editor and verify the table have been created.

## Learn More

Looking to help the world's leading brands and the next generation of successful merchants take flight? To learn more about developing on top of the BigCommerce platform, take a look at the following resources:

- [BigCommerce Developer Center](https://developer.bigcommerce.com/) - Learn more about BigCommerce platform features, APIs and SDKs
- [BigDesign](https://developer.bigcommerce.com/big-design/) - An interactive site for BigCommerce's React Components with live code editing
- [Building BigCommerce Apps](https://developer.bigcommerce.com/api-docs/getting-started/building-apps-bigcommerce/building-apps) - Learn how to build apps for the BigCommerce marketplace

## Troubleshooting

### Seeing {"error": "Not found"} when installing the app

If you don't request the proper scopes, the /api/auth request might fail. Check your scopes in the BigCommerc Dev Tools area. Look at the scopes listed above in the "BigCommerce Setup" section above.