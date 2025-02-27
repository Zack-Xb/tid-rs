use std::env;
use std::process::Command;
use cc;

fn main() {


    println!("cargo:rustc-link-lib=framework=Foundation");
    println!("cargo:rustc-link-lib=framework=LocalAuthentication");
    println!("cargo:rerun-if-changed=foreign/tid.m");
    println!("cargo:rerun-if-changed=foreign/tid.h");

    
    // // FIXME: how to use cc?
     cc::Build::new()
         .file("foreign/tid.m")
         .include("foreign/tid.h")
         .pic(true)
         .flag("-arch")
         .flag("arm64")
         .flag("-framework")
         .flag("Foundation")
         .flag("-framework")
         .flag("LocalAuthentication")
         .compile("tid");

    
    println!("cargo:rustc-link-lib=static=tid");

    

  
/* 
    let output = env::var("OUT_DIR").unwrap();
    Command::new("clang")
        .arg(concat!("-I", env!("CARGO_MANIFEST_DIR"), "/foreign"))
        .arg("-c")
        .arg("-o")
        .arg(format!("{}/lib_test.o", output))
        .arg(concat!(env!("CARGO_MANIFEST_DIR"), "/foreign/tid.m"))
        .arg("-fPIC")
        .spawn()
        .unwrap()
        .wait()
        .unwrap();
    Command::new("ar")
        .arg("r")
        .arg(format!("{}/libtest.a", output))
        .arg(format!("{}/lib_test.o", output))
        .spawn()
        .unwrap()
        .wait()
        .unwrap();

    println!("cargo:rustc-link-arg={}/libtest.a", output)
    */
}
