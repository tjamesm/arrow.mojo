from testing import assert_true, assert_false, assert_equal
from arrow.array.bool_array import ArrowBooleanArray


def test_ArrowBooleanArray():
    var bools = List[Optional[Bool]](True, None, False)
    var arr = ArrowBooleanArray(bools)
    for i in range(len(arr)):
        if arr[i] is None:
            print("None")
        else:
            print(arr[i].or_else(False))
    assert_equal(arr.length, 3)
    assert_equal(arr.null_count, 1)
    assert_equal(arr.mem_used, 128)


def test_ArrowBooleanArray_eq():
    var bools_1 = ArrowBooleanArray(List[Optional[Bool]](True, None, False))
    var bools_2 = ArrowBooleanArray(List[Optional[Bool]](True, None, False))
    var bools_3 = ArrowBooleanArray(List[Optional[Bool]](True, None, True))
    var bools_4 = ArrowBooleanArray(
        List[Optional[Bool]](True, None, False, True)
    )

    assert_true(bools_1.__eq__(bools_2))
    assert_false(bools_1.__eq__(bools_3))
    assert_false(bools_1.__eq__(bools_4))
