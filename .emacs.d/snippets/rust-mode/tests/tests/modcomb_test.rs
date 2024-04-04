include!("../../modcomb");

#[test]
fn arc156_b_test() {
    use proconio::{input, source::once::OnceSource};
    use itertools::Itertools;
    use superslice::Ext as _;

    input! {
        from OnceSource::from("\n\
            5 10\n\
            3 1 4 1 5"),
        n: usize, k: usize,
        aa: [usize; n]
    }

    Mint::set_modulus(MODULUS);

    let mut v = aa.into_iter().unique().collect::<Vec<_>>();
    v.sort();

    let mut ans = Mint::new(1); // x==0の場合は1通り
    for x in 1..n+k {

        let p = v.lower_bound(&x);

        if x - p + 1 > k {
            continue;
        }

        let y = k - (x-p+1);
        ans += comb_raw(y+x, x);
    }


    assert_eq!(7109, ans.val());
}
