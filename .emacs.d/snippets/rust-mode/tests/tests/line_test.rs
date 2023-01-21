include!("../../line");

#[test]
fn line_coefficients_test() {
    assert_eq!(line_coefficients(1 , 2, 0, 1), (1.into(), (-1).into(), 1.into()));
}
