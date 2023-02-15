
struct Bit {
    n: usize,
    tree: Vec<usize>
}

impl Bit {
    fn new(n: usize) -> Self {
        Bit {
            n,
            tree: vec![0; n+1]
        }
    }

    fn sum(&self, i: usize) -> usize {
        let mut i = i as isize;
        let mut s = 0;
        while i > 0 {
            s += self.tree[i as usize];
            i -= i & -i;
        }
        s
    }

    fn add(&mut self, i: usize, x: usize) {
        let mut i = i as isize;
        while i <= self.n as isize {
            self.tree[i as usize] += x;
            i += i & -i;
        }
    }
}

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
