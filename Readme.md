# stripeR

An interface with the [Stripe](https://stripe.com) API for user payments.

## Setup

1. Sign up for a [Stripe account](https://dashboard.stripe.com/register) and get your API keys.  You will need to add a bank account and await approval.
2. Load stripeR() package then set your API keys.  **Protect your live API keys!!** - people could charge your card otherwise.
 e.g.
 
```r
library(stripeR)

options('stripeR.secret_test') <- SECRET_TEST_KEY
options('stripeR.secret_live') <- SECRET_LIVE_KEY
options('stripeR.public_test') <- PUBLIC_TEST_KEY
options('stripeR.public_live') <- PUBLIC_LIVE_KEY
```

Or set them in the `stripeR_options.R` file, but be careful publishing to say Github. The tests ones are ok as they can't charge against a card. 

3. Before any stripeR session initialise using the `stripeR_init()` command.  Set to TRUE when you are ready to test against your live account.  It defaults to FALSE.

e.g.

```r
library(stripeR)

options('stripeR.secret_test') <- SECRET_TEST_KEY
options('stripeR.secret_live') <- SECRET_LIVE_KEY
options('stripeR.public_test') <- PUBLIC_TEST_KEY
options('stripeR.public_live') <- PUBLIC_LIVE_KEY


stripeR_init(live=FALSE)

## Check the balance of your Stripe account.
balance()

```
