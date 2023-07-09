use std::cmp::min;

include!("../../st");

#[test]
fn st_test() {

    let mut st = SegTree::new(100, std::usize::MAX, min);

    st.update(50, 1);
    assert_eq!(st.get(50), 1);

    assert_eq!(st.query(0, 51), 1);
}
