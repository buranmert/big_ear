# BigEar

#### Record all the method calls of your object!

### Usage

```
  # your unit test case
  def test_example_use_case_1
    my_obj = MyObject.new
    result = my_obj.calculate(2, +, 2)

    assert_equal 4, result, BigEar::record_proc(my_obj) { my_obj.calculate(2, +, 2) }
  end
```

1. If `assert` doesn't fail, `BigEar` isn't executed.
2. Otherwise, `BigEar` records all the method calls done to your object during `my_obj.calculate(2, +, 2)` and dumps it as `message` of `assert`
