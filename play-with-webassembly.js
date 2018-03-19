let createImportObject = () => {
    // Create a linear memory space in JS.
    // It will be given to the WASM module through the import object at instantiation time.
    global.memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });
    global.memoryJsView = new Uint32Array(global.memory.buffer);
    return {
        imports: {
            displayFunction: arg => console.log('display', arg),
            mem: global.memory
        }
    };
}

let playWithWebAssembly = instance => {

    instance.exports.display42();

    console.log(instance.exports.add42To(1));

    instance.exports.fillMemory();
    let mem = instance.exports.mem ?
        // If the linear memory space has been declared in the WAT/WASM module,
        // it has been exported :
        new Uint32Array(instance.exports.mem.buffer)
        // If we created the memory from the JS code, we use it :
        : global.memoryJsView;

    console.log(mem[0]);
}

if (typeof module !== 'undefined') {
    module.exports.createImportObject = createImportObject;
    module.exports.playWithWebAssembly = playWithWebAssembly;
}
