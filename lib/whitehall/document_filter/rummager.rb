require 'whitehall/document_filter/filterer'

module Whitehall::DocumentFilter
  class Rummager < Filterer
    def announcements_search
      filter_args = standard_filter_args.merge(filter_by_announcement_type)
      @results = Whitehall.search_client.search(filter_args)
    end

    def publications_search
      filter_args = standard_filter_args.merge(filter_by_publication_type)
                                        .merge(filter_by_official_document_status)
      @results = Whitehall.search_client.search(filter_args)
    end

    def default_filter_args
      @default = {
        start: ((@page - 1) * @per_page).to_s,
        count: @per_page.to_s
      }
    end

    def standard_filter_args
      default_filter_args
        .merge(filter_by_keywords)
        .merge(filter_by_people)
        .merge(filter_by_topics)
        .merge(filter_by_organisations)
        .merge(filter_by_locations)
        .merge(filter_by_date)
        .merge(include_fields)
        .merge(sort)
    end

    def filter_by_keywords
      if @keywords.present?
        {q: @keywords.to_s}
      else
        {}
      end
    end

    def filter_by_people
      if @people_ids.present? && @people_ids != ["all"]
        {filter_people: @people.map(&:slug)}
      else
        {}
      end
    end

    # Note that "Topics" are called "Policy Areas" in Rummager. That's why we
    # use `policy_areas` as the filter key here.
    def filter_by_topics
      if selected_topics.any?
        { filter_policy_areas: selected_topics.map(&:slug) }
      else
        {}
      end
    end

    def filter_by_organisations
      if selected_organisations.any?
        {filter_organisations: selected_organisations.map(&:slug)}
      else
        {}
      end
    end

    def filter_by_locations
      if selected_locations.any?
        {filter_world_locations: selected_locations.map(&:slug)}
      else
        {}
      end
    end

    # FIXME: Update this one to match others
    def filter_by_official_document_status
      case selected_official_document_status
      when "command_and_act_papers"
        {has_official_document: "1"}
      when "command_papers_only"
        {has_command_paper: "1"}
      when "act_papers_only"
        {has_act_paper: "1"}
      else
        {}
      end
    end

    def filter_by_date
      dates_hash = {}
      dates_hash.merge!(from: @from_date.to_s) if @from_date.present?
      dates_hash.merge!(to: @to_date.to_s) if @to_date.present?

      if dates_hash.empty?
        {}
      else
      { filter_public_timestamp: dates_hash}
      end
    end

    def sort
      if @keywords.blank?
        { order: "-public_timestamp" }
      else
        {}
      end
    end

    def filter_by_announcement_type
      announcement_types =
        if selected_announcement_filter_option
          selected_announcement_filter_option.search_format_types
        elsif include_world_location_news
          [Announcement.search_format_type]
        else
          non_world_announcement_types
        end
      { filter_search_format_types: announcement_types }
    end

    def filter_by_publication_type
      publication_types =
        if selected_publication_filter_option
          selected_publication_filter_option.search_format_types
        else
          Publicationesque.concrete_descendant_search_format_types
        end
      { filter_search_format_types: publication_types }
    end

    def documents
      @documents ||= ResultSet.new(@results, @page, @per_page).paginated
    end

  private

    def all_announcement_types
      all_descendants = Announcement.concrete_descendant_search_format_types
      descendants_without_news = all_descendants - [NewsArticle.search_format_type]
      news_article_subtypes = NewsArticleType.search_format_types
      descendants_without_news + news_article_subtypes
    end

    def non_world_announcement_types
      types = all_announcement_types
      types = types - NewsArticleType::WorldNewsStory.search_format_types
      types - [WorldLocationNewsArticle.search_format_type]
    end

    def include_fields
      {
        fields: [
          "display_type",
          "id",
          "format",
          "government_name",
          "is_historic",
          "organisations",
          "public_timestamp",
          "title",
        ]
      }
    end
  end
end
