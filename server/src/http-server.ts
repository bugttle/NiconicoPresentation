import * as express from 'express';
import * as http from 'http';
import * as moment from 'moment';
import * as basicAuth from 'express-basic-auth'
import * as SocketIO from 'socket.io';

export default class HttpServer {
  httpServer!: http.Server;
  ioServer!: SocketIO.Server;


  adminAddress = "";
  likeCount = 0;

  constructor(authUser: string, authPassword: string) {
    this.httpServer = this.createExpress(authUser, authPassword);
    this.ioServer = this.createSocketIO(this.httpServer);
  }

  createExpress(authUser: string, authPassword: string): http.Server {
    // app
    const app = express();
    app.get('/', express.static('public'));
    app.use((req, res, next) => {
      res.status(404).send('Sorry page not found');
    });

    // admin
    const admin = express.Router();
    admin.use(basicAuth({
      authorizeAsync: true,
      authorizer: (user, password, authorize) => {
        const isAuthorized = (user == authUser && authPassword == password);
        authorize(null, isAuthorized);
      }
    }));
    admin.get('/admin', (req, res, next) => {
      this.adminAddress = req.ip;
      next();
    }, express.static('public/admin'));

    // this.app.use('/', admin);

    return http.createServer(app);
  }

  createSocketIO(httpServer: http.Server): SocketIO.Server {
    const ioServer = SocketIO(httpServer);
    ioServer.on('connection', (socket) => {
      const remoteAddress = socket.request.connection.remoteAddress;
      if (remoteAddress == this.adminAddress) {
        socket.join('admin');
      } else if (this.isLocalHost(remoteAddress)) {
        socket.join('viewer');
      } else {
        socket.join('guests');
      }

      // init
      ioServer.emit('init', this.likeCount);

      // event handlers
      socket.on('comment', (data) => {
        ioServer.to('admin').emit({date:moment().format('MM/DD hh:mm:ss'), text:data} as any);
        ioServer.to('viewer').emit(data);
      });

      socket.on('like', () => {
        this.likeCount++;
        // logger.info('like [' + remoteAddress + ']: ' + likeCount)
        ioServer.emit('like', this.likeCount);
      });

      socket.on('keyEvent', (data) => {
        ioServer.to('viewer').emit(data);
      });

      socket.on('doTest', (data) => {
        //         logger.info('doTest [' + remoteAddress + ']');
        ioServer.to('viewer').emit('doTest');
      });
//     socket.on('doTest', function(data) {
//         logger.info('doTest [' + remoteAddress + ']');
//         if (isLocalHost(remoteAddress) || isAdminAddress(remoteAddress)) {
//             chat.to('admin').emit('doTest');
//         }
//     });
    });
    return ioServer;

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
//  }
  }

  public run(hostname: string, port: number, gid: string, uid: string) {
    this.httpServer.listen(port, hostname, () => {
      process.setgid(gid);
      process.setuid(uid);
    });
  }

  isLocalHost(ip: string): boolean {
    return (ip == '127.0.0.1' || ip == '::1' || ip == 'localhost');
  }
}