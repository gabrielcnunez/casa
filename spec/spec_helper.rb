require "pry"
require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

if ENV["RUN_SIMPLECOV"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/lib/tasks/auto_annotate_models.rake"
    add_group "Models", "/app/models"
    add_group "Controllers", "/app/controllers"
    add_group "Channels", "/app/channels"
    add_group "Decorators", "/app/decorators"
    add_group "Helpers", "/app/helpers"
    add_group "Jobs", "/app/jobs"
    add_group "Importers", "/app/lib/importers"
    add_group "Mailers", "/app/mailers"
    add_group "Policies", "/app/policies"
    add_group "Values", "/app/values"
    add_group "Tasks", "/lib/tasks"
    add_group "Config", "/config"
    add_group "Database", "/db"
  end
end

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, "https://api.short.io/links").
      with(
        body: { originalURL: "https://wiki.com", domain: "lel.com" }.to_json,
        headers: {
       	  'Accept'=>'application/json',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Authorization'=>'fdfdsf',
       	  'Content-Type'=>'application/json',
       	  'User-Agent'=>'Ruby'
         }).
      to_return(status: 200, body: "{\"shortURL\":\"https://lel.com/xpsmpw\"}", headers: {})
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
end
