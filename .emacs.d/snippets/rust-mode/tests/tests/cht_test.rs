include!("../../cht");

#[test]
fn cht_test() {

    // https://atcoder.jp/contests/dp/tasks/dp_z ex.3

    let C = 5i64;
    let N = 8;
    let hs: Vec<i64> = vec![1, 3, 4, 5, 10, 11, 12, 13];

    let mut cht = ConvexHullTrick::new(|l,r| l >= r);
    let mut dp = vec![0i64;N];
    dp[0] = 0;
    for i in 1..N {
        cht.add((-2*hs[i-1], dp[i-1] + hs[i-1] * hs[i-1]));
        dp[i] = cht.cget(hs[i]) + hs[i] * hs[i] + C;
    }

    assert_eq!(dp[N-1], 62);
}
