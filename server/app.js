// config
var config = require('config');

// logger
var log4js = require('log4js');
log4js.configure(config.log.configure);
var logger = log4js.getLogger('socketio');
logger.setLevel(config.log.level);

// httpd
var http = require('http');
var fs = require('fs');
var static = require('node-static');
var fileServer = new static.Server('public');
var events = require('events');

//
// httpd server
//
var adminIpAddress;

var server = http.createServer(function(request, response) {
    if (request && request.url.match('/admin/?.*')) {
        // admin
        if (!isAuthorization(request)) {
            responseAuthenticate(request, response);
        } else {
            var remoteAddress = request.connection.remoteAddress;
            logger.info('admin ip address: ' + remoteAddress);
            adminIpAddress = remoteAddress;
            serveFile(request, response);
        }
    } else {
        // user
        serveFile(request, response);
    }
}).listen(config.httpd.port, config.httpd.host, function() {
    process.setuid(config.httpd.setuid)
});

function serveFile(request, response) {
    request.addListener('end', function() {
        fileServer.serve(request, response, function(e, res) {
            if (e && (e.status === 404)) {
                response404(request, response);
            }
        });
    }).resume();
}

function response404(request, response) {
    logger.info('404 [' + request.connection.remoteAddress + ']');
    response.writeHead(301, {Location: '/404/js-moonwarriors/index.html'});
    response.end();
}

function responseAuthenticate(request, response) {
    logger.info("realm: " + config.auth.realm);
    response.writeHead(401, {'WWW-Authenticate':'Basic realm="' + config.auth.realm + '"'});
    response.end('Authentication failed');
}

function isLocalHost(ip) {
    return (ip === "127.0.0.1" || ip === "::1" || ip === "localhost");
}

function isAdminAddress(ip) {
    return (ip === adminIpAddress);
}

function isAuthorization(request) {
    var authorization = request.headers.authorization;
    if (authorization) {
        var auth = (new Buffer(authorization.replace(/^Basic /, ''), 'base64')).toString('utf-8');
        var login = auth.split(':');
        // [0]:username;[1]:password
        if (login[0] === config.auth.username && login[1] === config.auth.password) {
            return true;
        }
    }
    return false;
}

//
// socekt.io
//
var io = require('socket.io').listen(server);

var likeCount = 0;

var chat = io.sockets.on('connection', function(socket) {
    var remoteAddress = socket.request.connection.remoteAddress;

    socket.on('connected', function() {
       if (isLocalHost(remoteAddress) || isAdminAddress(remoteAddress)) {
            logger.info('connected(admin) [' + remoteAddress + ']');
            socket.join('admin');
        } else {
            logger.info('connected [' + remoteAddress + ']');
            socket.join('users');
        }
        socket.emit('init', {likeCount:likeCount});
    });

    socket.on('like', function(data) {
        ++likeCount;
        logger.info('like [' + remoteAddress + ']: ' + likeCount);
        io.sockets.emit('like', {value:likeCount});
    });

    socket.on('publish', function(data) {
        logger.info('publish [' + remoteAddress + ']: ' + data.value);
        chat.to('admin').emit('publish', {date:formatDate(new Date(), 'MM/DD hh:mm:ss'), value:data.value});
    });

    socket.on('keyEvent', function(data) {
        logger.info('keyEvent [' + remoteAddress + ']: ' + data.keyCode);
        chat.to('admin').emit('keyEvent', data);
    });

    socket.on('doTest', function(data) {
        logger.info('doTest [' + remoteAddress + ']');
        if (isLocalHost(remoteAddress) || isAdminAddress(remoteAddress)) {
            chat.to('admin').emit('doTest');
	}
    });

    socket.on('disconnect', function() {
        logger.info('disconnect [' + remoteAddress + ']');
    });
});

/**
 * 日付をフォーマットする
 * @param  {Date}   date     日付
 * @param  {String} [format] フォーマット
 * @return {String}          フォーマット済み日付
 */
var formatDate = function (date, format) {
    if (!format) format = 'YYYY-MM-DD hh:mm:ss.SSS';
    format = format.replace(/YYYY/g, date.getFullYear());
    format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
    format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
    format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
    format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
    format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
    if (format.match(/S/g)) {
        var milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
        var length = format.match(/S/g).length;
        for (var i = 0; i < length; i++) format = format.replace(/S/, milliSeconds.substring(i, i + 1));
    }
    return format;
}

