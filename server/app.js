// logger
var log4js = require('log4js');
log4js.configure('config/log4js.json');
var logger = log4js.getLogger('socketio');
logger.setLevel('DEBUG');
logger.info('testlog');

// httpd
var static = require('node-static');
var fileServer = new static.Server('public');

var server = require('http').createServer(function(request, response) {
    request.addListener('end', function() {
        fileServer.serve(request, response, function(e, res) {
            if (e && (e.status === 404)) {
                logger.info('404');
                response.writeHead(301, {Location: '/404/js-moonwarriors/index.html'});
                response.end();
            }
        });
    }).resume();
}).listen(8080, "0.0.0.0");

var io = require('socket.io').listen(server);

var ownerUserId = null;
var userHash = {};
var likeCount = 0;

var chat = io.sockets.on('connection', function(socket) {
    var isOwner = false;
    if (socket.request.connection.remoteAddress == "127.0.0.1") {
        isOwner = true;
//        ownerUserId = socket.id;
    }
    console.log("isOwner:" + isOwner);

    socket.on('connected', function(name) {
        logger.info('connected' + name);
        var msg = name + 'が入室しました。';
//        console.log('rooms:', io.sockets.manager.rooms);
        if (isOwner) {
            socket.join('admin');
            io.to('admin').emit('publish', {value: msg});
//            socket.set('room', 'admin');
//            socket.join('admin');
//            chat.join('admin');
        } else {
            userHash[socket.id] = name;
            socket.join('users');
//            socket.set('room', 'users');
//            socket.join('users');
//            chat.join('users');
        }
//        socket.set('name', name);
        io.sockets.emit('init', {like:likeCount});
    });

    socket.on('like', function(data) {
        io.sockets.emit('like', {value:(++likeCount)});
    });

    socket.on('publish', function(data) {
//        chat.to('admin').emit('publish', {value:data.value});
        logger.info('publish:' + data.value);
        io.sockets.emit('publish', {value:data.value});
    });

    socket.on('disconnect', function() {
//        var room, name;
//        socket.get('room', function(error, r) {
//            room = r;
//        });
//        socket.get('name', function(error, n) {
//            name = n;
//        });
//        socket.leave(room);
//
//        if (userHash[socket.id]) {
//            var message = userHash[socket.id] + 'が退出しました';
//            delete userHash[socket.id];
//            chat.to('admin').emit('publish', {value:message});
//        }
    });

});
