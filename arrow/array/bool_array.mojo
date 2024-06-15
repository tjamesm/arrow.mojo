from arrow.buffer.bitmap import Bitmap


struct ArrowBooleanArray:
    var length: Int
    var null_count: Int
    var _validity: Bitmap
    var _buffer: Bitmap
    var mem_used: Int

    fn __init__(inout self, values: List[Bool]):
        self.length = len(values)
        self.null_count = 0
        self._validity = Bitmap(List(True) * len(values))
        self._buffer = Bitmap(values)
        self.mem_used = self._validity.mem_used + self._buffer.mem_used

    fn __init__(inout self, length: Int):
        self.length = length
        self.null_count = 0
        self._validity = Bitmap(List(True) * length)
        self._buffer = Bitmap(length)
        self.mem_used = self._validity.mem_used + self._buffer.mem_used

    fn __init__(inout self, values: List[Optional[Bool]]):
        self.length = len(values)
        self.null_count = 0
        var validity_list = List[Bool](capacity=len(values))
        var value_list = List[Bool](capacity=len(values))

        for i in range(len(values)):
            print("__init__:", values[i].or_else(False))
            if values[i] is None:
                validity_list.append(False)
                self.null_count += 1
            else:
                validity_list.append(True)
                value_list.append(values[i])

        for i in range(len(validity_list)):
            print("__init__ final validity_list:", validity_list[i])

        for i in range(len(value_list)):
            print("__init__ final value_list:", value_list[i])

        self._validity = Bitmap(validity_list)
        self._buffer = Bitmap(value_list)
        self.mem_used = self._validity.mem_used + self._buffer.mem_used

    fn __eq__(self, other: Self) raises -> Bool:
        if self.length != other.length:
            return False
        for i in range(self.length):
            # print(
            #     "i:",
            #     i,
            #     "self[i]:",
            #     self[i].or_else(False),
            #     "other[i]:",
            #     other[i].or_else(False),
            # )
            print(
                "i:",
                i,
                "self[i]:",
                self.__getitem__(i).or_else(False),
                "other[i]:",
                other.__getitem__(i).or_else(False),
            )
            if (self[i] is None) != (other[i] is None):
                return False
            if self[i] is not None:
                if self[i].or_else(False) != other[i].or_else(False):
                    return False
        return True

    fn __len__(self) -> Int:
        return self.length

    fn __getitem__(self, index: Int) raises -> Optional[Bool]:
        if index < 0 or index >= self.length:
            raise Error("index out of range for ArrowBoolVector")
        if self._validity._unsafe_getitem(index):
            return self._buffer._unsafe_getitem(index)
        return None
