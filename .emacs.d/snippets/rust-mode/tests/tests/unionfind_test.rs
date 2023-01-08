
include!("../../uf");

#[test]
fn uf_test() {
    let mut uf = UnionFind::new(3);

    uf.unite(1,2);

    assert_eq!(uf.size(1), 2);
    assert_eq!(uf.size(0), 1);
}

