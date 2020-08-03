const Sentry = require('@sentry/node');
Sentry.init({ dsn: 'https://bea59d3a829b4e7a83f5f463a65e7616@sentry.opxl.pw/4' });


onNet('sakura:logerror', (error) => {
    Sentry.captureException(new Error(error));
});