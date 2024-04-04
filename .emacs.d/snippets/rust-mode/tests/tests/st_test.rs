use std::cmp::min;

include!("../../st");

#[test]
fn st_test() {

    let mut st: SegTree<usize> = SegTree::new(51, 0, |a,b| a+b);
    st.update(50, 1);
    st.update(0, 1);
    assert_eq!(st.get(50), 1);
    assert_eq!(st.get(0), 1);
    assert_eq!(st.query(0,51), 2);
}
