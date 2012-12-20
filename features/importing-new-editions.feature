Feature: Importing new editions
  We want to be able to import editions into our database which don't have all the data filled in. The idea is to enable editors to 'speed tag' them with all the associations they need, and send them directly to draft state.

  - Can specify the Organisation that is being imported on the import page
  - When importing:
    - The state of the new editions is set to imported
    - Depending on the main document type, the publication sub type and the speech type default to UNKNOWN if the data field is unfilled
    - The organisation is defaulted to the selected organisation if not filled in. If filled in and valid, we use that organisation in preference. If the field is filled in and unrecognised then the import will fail. If the column is missing we default all rows to the selected organisation.
    - The speech "delivered by" field is left unfilled if not filled in
    - Unrecognised non-blank "tag" fields will cause an import failure
  - The following validation differences from draft editions apply to imported editions:
    - The publication sub type can be UNKNOWN for publications
    - "Delivered by" is allowed to be blank for speeches
    - Speech type can be UNKNOWN for speeches
  - The normal validation rules apply when converting this into draft - UNKNOWN is not a valid type for non-imported editions
  - The "convert to draft" button will give a descriptive error if the above validation exceptions for imported editions haven't been corrected

  More detail on how we deal with individual fields:
  ---

  Terms:
  - column required: should fail csv upload without the column
  - required: should fail row import without it, implies column required
  - unique: should fail csv upload if any duplicates of this field in the file, implies required
  - optional: import if avaialable, leave blank if not
  - default: import if available, set to a default if not

  All types:
  - old_url: column required + data unique
  - title: required
  - summary: optional
  - body: required
  - organisation: required, ideally default blank to SELECTED, reject anything that is non-blank that can't be found

  Publications:
  - publication_date: required
  - publication_type: required, ideally default blank to UNKNOWN, reject anything non-blank that can't be found
  - policy_1..4: 1 column required, data optional
  - document_series: column required, data optional
  - attachment_1..n_*: 1 column required, data required (should stay as is)
  - json_attachments: optional, leave as is
  - country_1..4: 1 column required, data optional

  Consultations:
  - opening_on: required
  - closing_on: required
  - response_date: optional
  - response_summary: optional
  - response_attachments_1..n_*: 1 column required, optional (should stay as is)

  News:
  - first_published_at: required
  - policy_1..4: 1 column required, data optional
  - minister_1..2: optional
  - country_1..4: 1 column required, data optional

  Speeches:
  - speech_type: required, ideally default blank to UNKNOWN, reject anything non-blank that can't be found
  - delivered_by: required, ideally default blank, reject anything non-black that can't be found
  - event_and_location: optional
  - country_1..4: 1 column required, data optional

  StatisticalDataSets:
  - document_series: column required, data optional

  FatalityNotices:
  - field_of_operation: required

  Background:
    Given I am logged in as a user which can import data

  Scenario: Importing publications with unrecognised types will be rejected
    When I import the following data as CSV as "Publication" for "Department for Transport":
      |old_url|title|summary|body|organisation|policy_1|publication_type|document_series|publication_date|order_url|price|isbn|urn|command_paper_number|ignore_1|attachment_1_url|attachment_1_title|country_1|
      |http://example.com/1|title|summary|body|weird organisation||weird type||14-Dec-2011||||||||||
    Then the import should fail with errors "unknown organisation" and "unknown type" and no editions are created

  Scenario: Importing publication with organisation already set in the data
    When I import the following data as CSV as "Publication" for "Department for Transport":
      |old_url|title|summary|body|organisation|policy_1|publication_type|document_series|publication_date|order_url|price|isbn|urn|command_paper_number|ignore_1|attachment_1_url|attachment_1_title|country_1|
      |http://example.com/1|title|summary|body|foreign-commonwealth-office||||14-Dec-2011||||||||||
    Then the import succeeds, creating 1 imported publication for "Foreign and Commonwealth Office" with "UNKNOWN" publication type

  Scenario: Importing publications sets imported state, UNKNOWN type and default organisation, to be filled in later
    When I import the following data as CSV as "Publication" for "Department for Transport":
      |old_url|title|summary|body|organisation|policy_1|publication_type|document_series|publication_date|order_url|price|isbn|urn|command_paper_number|ignore_1|attachment_1_url|attachment_1_title|country_1|
      |http://example.com/1|title|summary|body|||||14-Dec-2011||||||||||
    Then the import succeeds, creating 1 imported publication for "Department for Transport" with "UNKNOWN" publication type
    When I set the imported publication's type to "Policy paper"
    Then I can make the imported publication into a draft edition

  Scenario: Importing speeches sets UNKNOWN speech type and blank "delivered by", to be filled in later
    When I import the following data as CSV as "Speech" for "Department for Transport":
      |old_url|title|summary|body|organisation|policy_1|type|delivered_by|delivered_on|event_and_location|country_1|
      |http://example.com/1|title|summary|body|||||14-Dec-2011|location||
    Then the import succeeds, creating 1 imported speech for "Department for Transport" with "UNKNOWN" speech type and with no deliverer set
    When I set the imported speech's type to "Transcript"
    And I set the deliverer of the speech to "Joe Bloggs"
    Then I can make the imported speech into a draft edition
