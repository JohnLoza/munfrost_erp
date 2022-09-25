# frozen_string_literal: true

class ApplicationService
  def self.call(*args)
    self.new(*args).call
  end
end
