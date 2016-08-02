class PublishingApiWithdrawalWorker < PublishingApiWorker
  def perform(content_id, explanation, locale, allow_draft = false)
    Whitehall.publishing_api_v2_client.unpublish(
      content_id,
      type: "withdrawal",
      locale: locale,
      explanation: explanation,
      allow_draft: allow_draft,
    )
  end
end
