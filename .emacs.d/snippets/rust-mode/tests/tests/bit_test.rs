include!("../../bit");

#[test]
fn bit_test() {
    // アリ本初版 p.162

    let aa = vec![3,1,4,2];
    let n = aa.len();

    let mut bit = Bit::new(4);
    let mut ans = 0;
    for i in 0..n {
        ans += i - bit.sum(aa[i]);
        bit.add(aa[i], 1);
    }

    assert_eq!(ans, 3);
}
