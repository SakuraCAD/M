const WebSocket = require('ws');
const { v4: uuid } = require('uuid');

const wsUrl = 'wss://api.sakuracad.app/';
const socket = new WebSocket(wsUrl);

const cbMap = new Map();

on('sakuram:horizon:send', (operation, data, callback) => {
    let r = null;

    if (callback) {
        r = uuid();
        cbMap.set(r, callback);
    }

    socket.send(JSON.stringify({ r, o: operation, d: data }));
});

socket.on('message', data => {
    const dataReceived = JSON.parse(data);

    if (dataReceived.r && cbMap.has(dataReceived.r)) {
        cbMap.get(dataReceived.r)({ operation: dataReceived.o, data: dataReceived.d });
        cbMap.delete(dataReceived.r);
    }
});

emit('sakuram:horizon:ready');