#![no_main]
use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let _ = untrusted::Input::from(data).read_all(untrusted::EndOfInput, |input| {
        let first = input.read_byte();
        if data.len() == 0 {
            assert!(first.is_err());
            assert!(input.at_end());
        } else if data.len() == 1 {
            assert!(input.at_end());
            assert!(first.unwrap() == data[0]);
        } else {
            assert!(!input.at_end());
            assert!(first.unwrap() == data[0]);
        }
        Ok(())
    });
});
