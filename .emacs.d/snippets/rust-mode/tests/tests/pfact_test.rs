include!("../../pfact");

#[test]
fn pfact_test() {
    assert_eq!(pfact(6), vec![2,3]);
    assert_eq!(pfact(8), vec![2,2,2]);
}
