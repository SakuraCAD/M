/*
________           _____                
__  ___/_____________  /____________  __
_____ \_  _ \_  __ \  __/_  ___/_  / / /
____/ //  __/  / / / /_ _  /   _  /_/ / 
/____/ \___//_/ /_/\__/ /_/    _\__, /  
                               /____/       
    Horizon Websockets for FiveM
    Developed by LewisTehMinerz#1337
    https://sakuracad.app
    Made using Visual Studio Code - Insiders
*/


const Sentry = require('@sentry/node');
Sentry.init({ dsn: 'https://bea59d3a829b4e7a83f5f463a65e7616@sentry.opxl.pw/4' });


onNet('sakura:logerror', (error) => {
    Sentry.captureException(new Error(error));
});