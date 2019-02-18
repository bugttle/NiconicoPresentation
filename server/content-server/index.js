import path from 'path';
import config from 'config';
import log4js from 'log4js';
import NetworkInterface from './libs/network-interface';
import Server from './libs/server';

// Configure
const AuthUsername = config.get('auth.username');
const AuthPassword = config.get('auth.password');
const HttpdHostname = config.get('httpd.hostname');
const HttpdPort = config.get('httpd.port');
const HttpdSetgid = config.get('httpd.setgid');
const HttpdSetuid = config.get('httpd.setuid');

// Logger
log4js.configure(config.get('log.configure'));
const logger = log4js.getLogger('socket.io');
logger.level = config.get('log.level');

// Show the url
console.log('Server running at:');
console.log(`  - Local:   http://localhost:${HttpdPort}/`);
const address = NetworkInterface.findFirstAddress();
if (address) {
    console.log(`  - Network: http://${address}:${HttpdPort}/`);
}

// Launch the server
const AppPath = path.join(__dirname, '../app/dist');
const server = new Server(AppPath);
server.setAdmin(AuthUsername, AuthPassword);
server.run(HttpdHostname, HttpdPort, HttpdSetgid, HttpdSetuid);
