Feature: Rendering PDFs from HTML attachments
  As a writer or editor
  I want to automatically render PDF attachments from my HTML attachments
  In order to reduce the amount of work I need to do

  Scenario: Creating a new HTML attachment with a PDF
    Given I am an editor
    And I have a mock HTML attachment at "/iso-tea-brewing-standards/iso-3103"
    And I start drafting a new publication "ISO Tea Brewing Standards"
    When I start editing the attachments from the publication page
    And I create an html attachment with the title "ISO 3103" that should be rendered as a PDF
    And I save and publish the publication "ISO Tea Brewing Standards"
    And I view the overview of the publication "ISO Tea Brewing Standards"
    Then I should eventually see a PDF attachment for "ISO 3103"
