use std::prelude::v1::*; // Import the prelude which includes Result

fn main() -> anyhow::Result<()> {
    println!("Hello from WASM in Docker! 🚀");
    Ok(())
}

/// The above Rust function is a main function that prints "Hello from WASM!" when compiled to
/// WebAssembly.
// #[no_mangle]
// pub extern "C" fn main() {
//     println!("Hello from WASM!");
// }