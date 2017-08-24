class ActionController::Base
  before_action proc {
    if ENV["USE_SLIMMER"]
      puts "--- NOT SKIPPING HEADER ---"
    else
      response.headers[Slimmer::Headers::SKIP_HEADER] = "true"
      puts "--- SKIPPING HEADER ---"
    end
  }
end
