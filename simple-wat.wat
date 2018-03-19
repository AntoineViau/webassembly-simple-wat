(module
  ;; Our WAT code will use an imported function from JS (see $display42)
  (func $importedDisplayFunction (import "imports" "displayFunction") (param i32))

  ;; About WASM and memory : 
  ;; Memory is static and all the dynamic work (alloc, free...) has to be
  ;; done by hand. We are only given a linear memory space for each WASM
  ;; module instance. 
  ;; This memory can be provided by the host : 
  ;; Use WebAssembly.memory() in a JS environment (which is the only I know so far)
  ;; Then, WAT has just to import it (uncomment to try it) : 
  (memory (import "imports" "mem") 1)
  ;;
  ;; The other method is to declare the wanted memory in the WAT itself.
  ;; The unit is memory pages. Each page is 64 Kb.
  ;; (uncomment to try it) :
  ;; (memory (export "mem") 2)
  
  ;; This is an internal function (not exported)
  ;; It is called by the WAT it self and just returns 42 through the stack.
  (func $return42 (result i32)
    i32.const 42)

  ;; This exported function use the imported JS function given through
  ;; the importedObject in WebAssembly.instantiate()
  (func $display42 (export "display42")
    call $return42
    call $importedDisplayFunction)

  ;; This exported function read an argument from the stack and add 42.
  ;; The result is given back through the stack and can be used by the JS code :
  ;; instance.exports.add42To(1)
  (func (export "add42To")(param i32)(result i32)
    call $return42
    get_local 0
    i32.add)

  ;; This exported function will simply put the value 2501 at the very beginning
  ;; of the linear memory (given by JS or declared in the WAT, see above)
  (func (export "fillMemory")    
    i32.const 0       ;; Address    
    i32.const 2501    ;; Value    
    i32.store         ;; Store to the linear memory
  )
)
    

