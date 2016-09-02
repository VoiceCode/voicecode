var v8 = require('v8');
v8.setFlagsFromString('--harmony_proxies');

require('coffee-script/register')
require('./src/app/startup')
