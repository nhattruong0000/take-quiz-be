class TestSessionExecutionTimeJob
  include Sidekiq::Job

  def perform(*args)
    test_session_id = args[0]
    return unless test_session_id
    test_session = TestSession.find_by_id(test_session_id)
    test_session.status = 'timeout' if test_session.status == 'active'
    test_session.save!
  end
end
