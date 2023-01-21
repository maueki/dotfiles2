include!("../../online");

#[test]
fn is_collinear_test() {
    assert!(is_collinear(0,0, 1,1,2,2));

    assert!(is_collinear(1,2, 2,4,3,6));
}
