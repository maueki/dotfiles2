
include!("../../uf");

#[test]
fn uf_test() {
    let mut uf = Dsu::new(3);

    uf.merge(1,2);

    assert_eq!(uf.size(1), 2);
    assert_eq!(uf.size(0), 1);
}

