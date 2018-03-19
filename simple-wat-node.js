const play = require('./play-with-webassembly.js');

const buffer = require('fs').readFileSync('simple-wat.wasm');
var uintBuffer = new Uint8Array(buffer.length)
for (var i = 0; i < buffer.length; ++i) {
    uintBuffer[i] = buffer[i]
}

let importObject = play.createImportObject();

return WebAssembly.instantiate(uintBuffer, importObject)
    .then(obj => {
        play.playWithWebAssembly(obj.instance);
    })
    .catch(console.log)
