
include!("../../crt");

#[test]
fn crt_test() {
    let r = [2,3,2];
    let m = [3,5,7];
    assert_eq!(crt(&r, &m), (23, 105));
}
