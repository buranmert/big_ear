module BigEar
  
  # Records an object's method calls
  # during execution of given block
  #
  # @param object [Object] object whose method calls to be recorded
  # @param block [Proc] block to be executed during recording
  # @return [Proc] Proc which returns the recording logs when called
  def self.record_proc(object)
    proc do
      recorder = BigEar::Recorder.new(object)
      recorder.start
      yield
      
      recorder.stop
    end
  end
  
  class Recorder
    def initialize(object)
      @log = []
      @object = object
    end
    
    def start
      @trace = TracePoint.trace(:return) do |tp|
        next unless tp.self.object_id == @object.object_id
        params_values = tp.self.method(tp.method_id).parameters.map(&:last).map do |param|
          {param => tp.binding.local_variable_get(param)}
        end
        @log.append("method: #{tp.callee_id}, params: #{params_values}, ret_val: #{tp.return_value}")
      end
    end
    
    def stop
      @trace&.disable
      @trace = nil
      
      log = @log
      @log = []
      
      log
    end
  end
  
end
