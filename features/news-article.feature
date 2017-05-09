Feature: News articles
  Background:
    Given I am an GDS editor

  Scenario: Associate a news article of type worldwide news story with a worldwide organisation
    Given the worldwide organisation "Spanish Department" exists
    When I draft a valid "Worldwide news story" news article with title "Spanish News" associated to "Spanish Department"
    And I force publish the news article "Spanish News"
    Then the worldwide organisation "Spanish Department" should be associated to the news article "Spanish News"
