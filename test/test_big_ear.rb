require 'minitest/autorun'
require 'big_ear'

module TestUtilities
  
  class Foo
    
    def fun1(param1)
      block_val = yield
      fun2("fun2") + param1 + block_val
    end
    
    protected
    
    def fun2(param2)
      fun3("fun3") + param2
    end
    
    private
    
    def fun3(param3)
      "local_fun3" + param3
    end
    
  end
  
end

class BigEarTest < Minitest::Test
  
  def test_big_ear
    foo = TestUtilities::Foo.new
    
    n = "local var"
    logs = BigEar::record_proc(foo) { foo.fun1("this is a param") { "this is " + n } }.call
    
    expected = [
      "method: fun3, params: [{:param3=>\"fun3\"}], ret_val: local_fun3fun3",
      "method: fun2, params: [{:param2=>\"fun2\"}], ret_val: local_fun3fun3fun2",
      "method: fun1, params: [{:param1=>\"this is a param\"}], ret_val: local_fun3fun3fun2this is a paramthis is local var"
    ]
    
    assert_equal expected, logs
  end
  
  def test_example_use_case_1
    recorder_did_run = false
    begin
      assert false, BigEar::record_proc("") { recorder_did_run = true }
    rescue Minitest::Assertion # expected exception
    end
    assert recorder_did_run
  end
  
  def test_example_use_case_2
    recorder_did_run = false
    assert true, BigEar::record_proc("") { recorder_did_run = true }
    assert !recorder_did_run
  end
  
end
