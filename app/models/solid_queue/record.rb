# frozen_string_literal: true

module SolidQueue
  class Record < ActiveRecord::Base
    self.abstract_class = true

    connects_to **SolidQueue.connects_to if SolidQueue.connects_to

    def self.non_blocking_lock
      if SolidQueue.use_skip_locked
        if self.connection.adapter_name == 'SQLServer'
          lock(Arel.sql("WITH(READPAST)"))
        else
          lock(Arel.sql("FOR UPDATE SKIP LOCKED"))
        end
      else
        lock
      end
    end
  end
end

ActiveSupport.run_load_hooks :solid_queue_record, SolidQueue::Record
