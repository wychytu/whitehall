Feature:
  As a writer or editor
  I want a PDF to be automatically generated when I add an HTML attachment
  So I don't have to manually generate one and attach it.

  @with-fake-sidekiq
  Scenario: Automatically generate a PDF for an HTML attachment
    Given I am an editor
    And there is a user called "Beardy"
    And I start drafting a new publication "Budget 2025"
    When I start editing the attachments from the publication page
    And I add an html attachment with the title "Budget 2025" and mark it for PDF generation
    Then the publication "Budget 2025" should have 1 attachments
    When I save the publication "Budget 2025"
    And "Beardy" submits the publication "Budget 2025"
    And I publish the publication "Budget 2025"
    Then we enqueued a job to automatically generate the PDF attachment
    When the automatic generation of PDF job runs
    And the attachment has been virus-checked
    Then the publication "Budget 2025" should have 2 attachments
    And the latest attachment is the PDF version of the HTML attachment
