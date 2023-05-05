include!("../../sum_acc");

#[test]
// 累積和
fn sum_acc_test() {
    let v = [1,2,3,4];
    assert_eq!(sum_acc(&v), vec![0,1,3,6,10]);
}
