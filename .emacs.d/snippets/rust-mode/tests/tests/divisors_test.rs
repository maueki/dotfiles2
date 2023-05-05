#![allow(unused_imports)]
include!("../../divisors");

#[test]
fn divisors_test() {
    {
        let mut v = divisors(12).into_iter().collect::<Vec<_>>();
        v.sort();
        assert_eq!(v, vec![1,2,3,4,6,12]);
    }

    {
        let mut v = divisors(1).into_iter().collect::<Vec<_>>();
        assert_eq!(v, vec![1]);
    }

    {
        let mut v = divisors(16).into_iter().collect::<Vec<_>>();
        v.sort();
        assert_eq!(v, vec![1,2,4,8,16]);
    }

}
