class User
  class Filtered < ApplicationFinder
    def initialize(params = {})
      @params = params
      @speaker =  @params.delete(:speaker)
    end

    def call
      User.where(conditions)
    end

    private

    attr_reader :params, :speaker

    def conditions
      params.keep_if { |_, value| value == '1' }
        .merge(speaker_condition || {})
    end

    def speaker_condition
      {id: User::Speakers.call} if speaker == '1'
    end
  end
end
