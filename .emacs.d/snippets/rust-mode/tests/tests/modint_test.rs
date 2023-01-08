
include!("../../modint");

#[test]
fn modint_test() {
    type MI = ModInt1000000007;
    {
        let mut m = MI::new(1000000006);
        assert_eq!(1000000006, m.val());
        m += 1;
        assert_eq!(0, m.val());
    }

    {
        let m = MI::new(-1);
        assert_eq!(1000000006, m.val());
    }

    {
        let m1 = MI::new(1);
        let m2 = MI::new(1);
        assert_eq!(m1, m2);
    }
}

#[test]
fn modint_tessoku_a76_test() {
    use superslice::Ext as _;

    let (n, w, l, r) = (5, 65, 7, 37);
    let xs = vec![5, 15, 30, 50, 55];

    type MI = ModInt1000000007;

    let xs = [&[0], xs.as_slice(), &[w]].concat();

    let mut v = vec![MI::new(0); n+4];
    v[0] = MI::new(1);
    v[1] = MI::new(-1);

    let mut s = MI::new(0);

    for i in 0..=n+1 {
        let pos = xs[i];
        s += v[i];
        let lp = xs.lower_bound(&(pos+l));
        let rp = xs.upper_bound(&(pos+r));
        v[lp] += s;
        v[rp] -= s;
    }

    assert_eq!(7, s.val());
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Mod7 {}

impl Modulus for Mod7 {
    fn modulus() -> usize {
        7
    }
}

#[test]
fn modint_mod7_test() {
    type MI = ModInt<Mod7>;

    {
        let mut v = MI::new(3);
        v *= 3;
        assert_eq!(v.val(), 2);
    }

    {
        let mut v = MI::new(2);
        assert_eq!(v.inv().val(), 4); // (2 ^ (7-2)) % 7
    }

}
