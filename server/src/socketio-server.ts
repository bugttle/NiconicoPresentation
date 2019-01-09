
class SocketIOServer {
  constructor() {

  }

  // //
// // socekt.io
// //
// var io = require('socket.io').listen(server);
//
// var likeCount = 0;
//
// var chat = io.sockets.on('connection', function(socket) {
//     var remoteAddress = socket.request.connection.remoteAddress;
//
//     socket.on('connected', function() {
//        if (isLocalHost(remoteAddress) || isAdminAddress(remoteAddress)) {
//             logger.info('connected(admin) [' + remoteAddress + ']');
//             socket.join('admin');
//         } else {
//             logger.info('connected [' + remoteAddress + ']');
//             socket.join('users');
//         }
//         socket.emit('init', {likeCount:likeCount});
//     });
//
//     socket.on('enabled', function(data) {
//         logger.info('enabled [' + remoteAddress + ']: ' + data.value);
//         io.sockets.emit('enabled', {value:data.value});
//     });
//
//     socket.on('like', function(data) {
//         ++likeCount;
//         logger.info('like [' + remoteAddress + ']: ' + likeCount);
//         io.sockets.emit('like', {value:likeCount});
//     });
//
//     socket.on('publish', function(data) {
//         logger.info('publish [' + remoteAddress + ']: ' + data.value);
//         chat.to('admin').emit('publish', {date:formatDate(new Date(), 'MM/DD hh:mm:ss'), value:data.value});
//     });
//
//     socket.on('keyEvent', function(data) {
//         logger.info('keyEvent [' + remoteAddress + ']: ' + data.keyCode);
//         chat.to('admin').emit('keyEvent', data);
//     });
//
//     socket.on('doTest', function(data) {
//         logger.info('doTest [' + remoteAddress + ']');
//         if (isLocalHost(remoteAddress) || isAdminAddress(remoteAddress)) {
//             chat.to('admin').emit('doTest');
//         }
//     });
//
//     socket.on('disconnect', function() {
//         logger.info('disconnect [' + remoteAddress + ']');
//     });
// });
//
}