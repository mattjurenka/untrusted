#![no_main]
use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let input = untrusted::Input::from(data);
    assert_eq!(input.as_slice_less_safe(), data);
});
