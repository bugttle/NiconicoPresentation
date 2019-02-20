import http from 'http';
import auth from 'basic-auth'
import express from 'express';
import moment from 'moment';
import SocketIO from 'socket.io';
import NetworkInterface from './network-interface';
import Security from './security';

const ROOMS = {
    ADMIN: 'admin',
    GUESTS: 'guests',
    VIEWER: 'viewer',
};

const EVENTS = {
    COMMENT: 'comment',
    CONNECT: 'connect',
    INIT: 'init',
    JOIN: 'join',
    KEY: 'key',
    LIKE: 'like',
    TEST: 'test',
};

export default class Server {
    constructor(appPath) {
        const socketIOAuthKey = Security.generateRandomKey();
        this.httpServer = new HttpServer(appPath, socketIOAuthKey);
        this.socketIOServer = new SocketIOServer(this.httpServer, socketIOAuthKey);
    }

    setAdmin(userName, password) {
        this.httpServer.setAdmin(userName, password);
    }

    run(hostname, port, gid, uid) {
        this.httpServer.run(hostname, port, gid, uid);
    }
}

class HttpServer {
    constructor(appPath, socketIOAuthKey) {
        this.appPath = appPath;
        this.socketIOAuthKey = socketIOAuthKey;
        this.app = this.createExpress();
        this.server = http.createServer(this.app);
    }

    createExpress() {
        return express();
    }

    setAdmin(userName, password) {
        this.app.use('/admin', (req, res, next) => {
            const user = auth(req);
            if (!user || user.name !== userName || user.pass !== password) {
                res.set('WWW-Authenticate', 'Basic realm="Niconico Presentation Admin"');
                return res.status(401).send();
            }

            if (req.query.key) {
                return next();
            } else {
                return res.redirect(`/admin?key=${this.socketIOAuthKey}`);
            }
        }, express.static(this.appPath));
    }

    run(hostname, port, gid, uid) {
        // Default path
        this.app.get('/*', express.static(this.appPath));

        // 404 not found
        this.app.use((req, res, next) => {
            res.status(404).send('Not Found');
        });

        this.server.listen(port, hostname, () => {
            process.setgid(gid);
            process.setuid(uid);
        });
    }
}

class SocketIOServer {
    constructor(httpServer, socketIOAuthKey) {
        this.createSocketIO(httpServer, socketIOAuthKey);
        this.likeCount = 0;
    }

    createSocketIO(httpServer, socketIOAuthKey) {
        const ioServer = new SocketIO(httpServer.server);
        ioServer.on(EVENTS.CONNECT, (socket) => {
            socket.on(EVENTS.JOIN, (data) => {
                if (data && data.key === socketIOAuthKey) {
                    socket.join(ROOMS.ADMIN); // for admin
                } else if (NetworkInterface.isLocalhost(socket.request.connection.remoteAddress)) {
                    socket.join(ROOMS.VIEWER); // for viewer
                } else {
                    socket.join(ROOMS.GUESTS); // for other users
                }

                ioServer.emit(EVENTS.INIT, {
                    like: this.likeCount
                });
            });
            socket.on(EVENTS.COMMENT, (data) => {
                ioServer.to(ROOMS.ADMIN).emit(EVENTS.COMMENT, {
                    date: moment().format('MM/DD hh:mm:ss'),
                    text: data.text
                });
                ioServer.to(ROOMS.VIEWER).emit(EVENTS.COMMENT, {
                    text: data.text
                });
            });
            socket.on(EVENTS.LIKE, () => {
                this.likeCount++;
                ioServer.emit(EVENTS.LIKE, {
                    count: this.likeCount
                });
            });
            socket.on(EVENTS.KEY, (data) => {
                ioServer.to(ROOMS.VIEWER).emit(EVENTS.KEY, {
                    code: data
                });
            });
            socket.on(EVENTS.TEST, (data) => {
                ioServer.to(ROOMS.VIEWER).emit(EVENTS.TEST);
            });
        });
        return ioServer;
    }
}
