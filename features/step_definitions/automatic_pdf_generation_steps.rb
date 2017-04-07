When(/^I save the publication "(.*?)"$/) do |publication_title|
  publication = Publication.find_by(title: publication_title)

  ensure_path edit_admin_publication_path(publication)
  fill_in_change_note_if_required
  click_button "Save"
end

When(/^I add an html attachment with the title "(.*?)" and mark it for PDF generation$/) do |title|
  click_on 'Add new HTML attachment'
  fill_in 'Title', with: title
  fill_in 'Body', with: '**Hello world**'
  check 'Manually numbered headings'
  check 'Should we render a PDF for this HTML attachment?'
  click_on 'Save'

  attachment = HtmlAttachment.find_by(title: title)
  content_store_has_item(attachment.url, { title: title })

  # TODO: hard-coded at the moment, this needs to go away
  stub_request(
    :get,
    "https://www.test.alphagov.co.uk/government/publications/budget-2025/budget-2025"
  ).to_return(status: 200, body: "<h1>Hello</h1>", headers: {})
end

Then(/^we enqueued a job to automatically generate the PDF attachment$/) do
  assert(
    PublishingApiHtmlAttachmentsWorker.jobs.count > 0,
    "Expected PublishingApiHtmlAttachmentsWorkers job to be enqueued"
  )

  PublishingApiHtmlAttachmentsWorker.drain

  assert_equal(
    1,
    GeneratePdfFromHtmlPublicationWorker.jobs.count,
    "Expected one GeneratePdfFromHtmlPublicationWorker job to be enqueued"
  )
end

When(/^the automatic generation of PDF job runs$/) do
  GeneratePdfFromHtmlPublicationWorker.drain
end

Then(/^the latest attachment is the PDF version of the HTML attachment$/) do
  publication = Publication.last
  html, pdf = *publication.attachments

  assert(
    html.html?,
    "Expected the first attachment to be an HTML attachment"
  )

  assert(
    pdf.pdf?,
    "Expected the second attachment to be a PDF attachment"
  )

  assert_equal(
    html.pdf_rendered_from_html_attachment,
    pdf,
    "Expected the HTML attachment to link to the PDF attachment"
  )

  assert_equal(
    pdf.source_html_attachment,
    html,
    "Expected the PDF attachment to link to the HTML attachment"
  )
end
