# Hash builders that preserve the AMS :json payload shape for Babili API resources.
module JsonSerializationHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  def default_url_options
    Rails.application.routes.default_url_options.presence || { host: "www.example.com" }
  end

  def absolute_host_prefix
    opts = Rails.application.routes.default_url_options
    host = opts[:host].to_s
    port = opts[:port] ? ":#{opts[:port]}" : ""
    "#{host}#{port}"
  end

  # --- User ---
  def user_json(user, current_user: nil)
    return nil if user.nil?

    hash = {
      username: user.person&.namespace&.name,
      id: user.id,
      display_name: user.name,
      image_thumb_50: user_image_thumb_50(user)
    }
    hash[:email] = user.email if current_user && user.id == current_user.id
    hash
  end

  def user_image_thumb_50(user)
    return nil unless user.person

    "#{absolute_host_prefix}#{user.person.image_url(:small_thumb)}".squish.gsub(/\s+/, "")
  end

  # --- Person ---
  def person_json(person)
    return nil if person.nil?

    {
      name: person.name,
      id: person.id,
      namespace: person.namespace.name,
      avatar_url: "#{absolute_host_prefix}#{person.image_url(:small_thumb)}".squish.gsub(/\s+/, ""),
      url: v1_person_url(person),
      html_url: namespace_url(person.namespace),
      organizations_url: organizations_v1_person_url(person),
      repositories_url: v1_namespace_repositories_url(person.namespace),
      vocabularies_url: v1_namespace_vocab_schemes_url(person.namespace),
      applications_url: nil,
      type: "Person",
      site_admin: person.is_admin?
    }
  end

  # --- Organization ---
  def organization_json(organization)
    return nil if organization.nil?

    {
      name: organization.name,
      id: organization.id,
      namespace: organization.namespace.name,
      url: v1_organization_url(organization),
      html_url: namespace_url(organization.namespace),
      members_url: v1_organization_members_url(organization),
      repositories_url: v1_namespace_repositories_url(organization.namespace),
      vocabularies_url: v1_namespace_vocab_schemes_url(organization.namespace),
      avatar_url: "#{absolute_host_prefix}#{organization.image_url(:small_thumb)}".squish.gsub(/\s+/, ""),
      description: organization.description,
      member_ids: organization.members.any? ? organization.members.order(id: :asc).map { |m| m.user.id } : nil,
      oauth_application_uids: organization.accessible_oauth_apps.any? ? organization.accessible_oauth_apps.map(&:uid) : nil
    }
  end

  # --- Collection / Oread::Application ---
  def collection_json(collection, current_user: nil)
    return nil if collection.nil?

    {
      id: collection.id,
      name: collection.name,
      uid: collection.uid,
      host: collection.host,
      port: collection.port,
      url: collection.url,
      user_access_token: collection.access_tokens.where(resource_owner: current_user).last.try(:token),
      provider_presentation_human: url_for([collection, { only_path: Rails.env.test? }]),
      collection_classes: Array(collection.collection_classes).map { |c| c.as_json },
      owner: user_json(collection.owner)
    }
  end

  def oread_application_json(application, current_user: nil)
    return nil if application.nil?

    {
      id: application.id,
      name: application.name,
      host: application.host,
      port: application.port,
      url: application.url,
      user_access_token: application.access_tokens.where(resource_owner: current_user).last.try(:token),
      provider_presentation_human: url_for([application, { only_path: Rails.env.test? }]),
      collection_classes: Array(application.collection_classes).map { |c| c.as_json },
      owner: {
        name: application.owner.try(:name),
        human: url_for([application.owner, { only_path: Rails.env.test? }])
      }
    }
  end

  # --- Application authorization ---
  def application_authorization_permissions(application, current_user)
    permissions = application.grants(current_user.person)
    {
      create: permissions.can_create,
      read: permissions.can_read,
      update: permissions.can_update,
      destroy: permissions.can_destroy,
      extra: {
        manage: permissions.can_manage,
        comment: permissions.can_comment,
        publish: permissions.can_publish
      }
    }
  end

  def application_authorization_json(application, current_user: nil)
    return nil if application.nil?

    {
      id: application.id,
      url: v1_authorization_url(application),
      scopes: application.scopes,
      token: application.access_tokens.where(resource_owner_id: current_user).last.try(:token),
      user_permissions: application_authorization_permissions(application, current_user),
      app: {
        url: v1_application_url(application.uid),
        name: application.name,
        client_id: application.uid
      },
      updated_at: application.updated_at,
      created_at: application.created_at
    }
  end

  def application_authorization_client_json(application, current_user: nil)
    return nil if application.nil?

    application_authorization_json(application, current_user: current_user).merge(
      organization_accessors: Array(application.organization_accessors).map { |o| organization_json(o) },
      person_accessors: Array(application.person_accessors).map { |p| person_json(p) }
    )
  end

  def application_json(application)
    return nil if application.nil?

    {
      id: application.id,
      owner: user_json(application.owner),
      name: application.name,
      description: application.description,
      url: v1_application_url(application.uid),
      html_url: oauth_application_url(application),
      client_id: application.uid,
      created_at: application.created_at,
      updated_at: application.updated_at,
      scopes: application.scopes
    }
  end

  def applications_grant_json(grant)
    return nil if grant.nil?

    {
      id: grant.id,
      url: v1_grant_url(grant),
      app: {
        url: v1_application_url(grant.application.uid),
        name: grant.application.name,
        client_id: grant.application.uid
      },
      created_at: grant.created_at,
      scopes: grant.scopes
    }
  end

  def membership_json(membership)
    return nil if membership.nil?

    {
      url: v1_organization_membership_url(membership.organization, membership.person_id),
      state: membership.verified? ? "active" : "pending",
      role: membership.role,
      organization_url: v1_organization_url(membership.organization),
      organization: organization_json(membership.organization),
      person: person_json(membership.person)
    }
  end

  def oauth_accessibility_json(accessibility)
    return nil if accessibility.nil?

    {
      id: accessibility.oauth_application_id,
      oauth_application: accessibility.oauth_application.as_json,
      can_manage: accessibility.can_manage,
      can_create: accessibility.can_create,
      can_read: accessibility.can_read,
      can_update: accessibility.can_update,
      can_destroy: accessibility.can_destroy,
      can_comment: accessibility.can_comment,
      can_publish: accessibility.can_publish
    }
  end

  # --- Repository ---
  def repository_json(repository)
    return nil if repository.nil?

    {
      name: repository.name,
      full_name: repository.name_tree.join("/"),
      id: repository.id,
      url: v1_namespace_repository_url(repository.owner, repository),
      html_url: namespace_repository_url(repository.owner, repository),
      data: {
        events_url: v1_namespace_repository_aggregation_events_url(repository.owner, repository),
        items_url: v1_namespace_repository_aggregation_items_url(repository.owner, repository)
      },
      bibliography_url: v1_namespace_repository_biblio_references_url(repository.owner, repository),
      owner: repository.owner.as_json,
      creator: repository.creator.as_json,
      description: repository.description,
      topics: repository.topic_list,
      created_at: repository.created_at,
      updated_at: repository.updated_at
    }
  end

  # --- Biblio entry (ADGB root: citation_data_item) ---
  def biblio_entry_type(entry)
    type = entry.type.demodulize
    case type
    when "Book", "Booklet", "Collection", "Proceeding", "Manual" then "book"
    when "Article" then "article-journal"
    when "InBook", "InCollection" then "chapter"
    when "InProceeding" then "paper-conference"
    when "Phdthesis", "Masterthesis" then "thesis"
    when "Unpublished" then "manuscript"
    when "Techreport" then "report"
    when "Misc" then "article"
    else type.downcase
    end
  end

  def biblio_person_variable(person)
    {
      family: Namae.parse(person.name).try(:first).try(:family),
      given: Namae.parse(person.name).try(:first).try(:given),
      literal: person.name
    }
  end

  def biblio_lang(sample)
    WhatLanguage.new(:english, :german, :french).language_iso(sample)
  end

  def citation_data_item_json(entry)
    return nil if entry.nil?

    hash = {
      schema: "https://github.com/babylon-online/schema/raw/master/citation_data_item.json",
      type: biblio_entry_type(entry),
      id: entry.slug,
      language: biblio_lang(entry.title),
      shortTitle: entry.citation,
      issued: {
        "date-parts": [entry.try(:year), entry.try(:month), entry.try(:day)].reject { |e| e.to_s.empty? },
        literal: entry.year
      },
      title: entry.title,
      links: {
        self: url_for([:v1, entry]),
        html: url_for(entry)
      },
      cite: (entry.bibliographic unless entry.type.in?(["Biblio::Serie", "Biblio::Journal"]))
    }

    hash[:categories] = entry.tag_list if entry.tags.any?
    hash[:journalAbbreviation] = entry.try(:journal).try(:abbr) if entry.type == "Article"

    if entry.class.method_defined?(:authors)
      hash[:author] = entry.authors.map { |a| biblio_person_variable(a) }
    end
    if entry.class.method_defined?(:editors)
      hash[:editor] = entry.editors.map { |a| biblio_person_variable(a) }
    end
    if entry.type == "Biblio::InBook"
      hash[:"container-author"] = entry.book.authors.map { |a| biblio_person_variable(a) }
    end
    if entry.try(:parent).try(:year)
      hash[:container] = {
        "date-parts": [entry.try(:parent).try(:year), entry.try(:parent).try(:month), entry.try(:parent).try(:day)].reject { |e| e.to_s.empty? },
        literal: entry.try(:parent).try(:year)
      }
    end
    if entry.class.method_defined?(:abstract) && entry.abstract.present?
      hash[:abstract] = entry.abstract
    end
    if entry.try(:parent)
      hash[:"container-title"] = entry.parent.type.in?(["Biblio::Serie", "Biblio::Journal"]) ? entry.try(:parent).try(:name) : entry.try(:parent).try(:title)
    end
    if entry.try(:parent).try(:abbr)
      hash[:"container-title-short"] = entry.try(:parent).try(:abbr)
    end
    hash[:DOI] = entry.doi if entry.class.method_defined?(:doi) && entry.doi.present?
    hash[:ISBN] = entry.isbn if entry.class.method_defined?(:isbn) && entry.isbn.present?
    hash[:ISSN] = entry.issn if entry.class.method_defined?(:issn) && entry.issn.present?
    hash[:number] = entry.number if entry.class.method_defined?(:number) && entry.number.present?
    if entry.class.method_defined?(:pages) && entry.pages.present?
      hash[:"number-of-pages"] = (entry.pages.split("-").last.to_i - entry.pages.split("-").first.to_i).try(:to_s)
      hash[:"page-first"] = entry.pages.split("-").first
      hash[:page] = entry.pages
    end
    hash[:publisher] = entry.try(:publisher).try(:name) if entry.class.method_defined?(:publisher)
    if entry.class.method_defined?(:places)
      hash[:"publisher-place"] = entry.places.map { |p| p.try(:given) }.join(", ") if entry.places.present?
    end
    hash[:URL] = entry.url if entry.class.method_defined?(:url) && entry.url.present?
    hash[:volume] = entry.volume if entry.class.method_defined?(:volume) && entry.volume.present?
    hash
  end

  def biblio_journal_json(journal)
    citation_data_item_json(journal).merge(
      name_abbr: journal.name_abbr,
      name: journal.name,
      abbr: journal.abbr
    )
  end

  def biblio_serie_json(serie)
    citation_data_item_json(serie).merge(
      title: serie.title,
      abbr: serie.abbr
    )
  end

  # Compact entry serializer (search / references) — root: entry
  def entry_json(entry)
    return nil if entry.nil?

    {
      id: entry.id,
      citation: entry.citation,
      url: url_for([:v1, entry]),
      html_url: url_for(entry),
      type: entry.type.demodulize,
      cite: (entry.bibliographic unless entry.type.in?(["Biblio::Serie", "Biblio::Journal"]))
    }
  end

  # --- Raw file upload — root: file (from type :file) ---
  def raw_file_upload_json(file_upload, absolute_file_url: true)
    return nil if file_upload.nil?

    embed = case file_upload.type
            when "Raw::Image" then view_raw_file_upload_path(file_upload, version: "large")
            when "Raw::Document" then view_raw_file_upload_path(file_upload, version: "preview")
            when "Raw::Video" then view_raw_file_upload_path(file_upload, version: "preview")
            when "Raw::Audio" then view_raw_file_upload_path(file_upload, version: "original")
            else view_raw_file_upload_path(file_upload, version: "original")
            end

    file_url = absolute_file_url ? "#{absolute_host_prefix}#{embed}" : embed

    {
      id: file_upload.slug,
      gid: file_upload.to_global_id.uri,
      file_url: file_url,
      html_url: raw_file_upload_url(file_upload)
    }
  end

  # --- Vocab concept (full Api::V1::Vocab) ---
  def vocab_label_map(labels)
    labels.map { |label|
      { LanguageList::LanguageInfo.find(label.language.split(" ").last).iso_639_1.to_sym => label.body }
    }.reduce(&:merge!)
  end

  def vocab_note_map(notes)
    notes.map { |note|
      { LanguageList::LanguageInfo.find(note.language.split(" ").last).iso_639_1.to_sym => note.body }
    }.reduce(&:merge!)
  end

  def vocab_concept_id(concept)
    [concept.scheme.namespace.name, "vocabulary", "schemes", concept.scheme.slug, "concepts", concept.slug].join("/")
  end

  def vocab_scheme_id(scheme)
    [scheme.namespace.name, "vocabulary", "schemes", scheme.slug].join("/")
  end

  def vocab_pref_label_summary(concept)
    {
      id: vocab_concept_id(concept),
      prefLabel: vocab_label_map(concept.labels.where(type: "Preferred", is_abbrevation: false))
    }
  end

  def vocab_person_variable(person)
    {
      name: person.name,
      personData: {
        id: person.namespace.name,
        name: {
          family: person.try(:family_name),
          given: person.try(:given_name)
        },
        about: {
          de: person.try(:about_me)
        }
      }
    }
  end

  def vocab_scheme_summary(scheme)
    {
      id: vocab_scheme_id(scheme),
      title: { de: scheme.title },
      hasTopConcepts: scheme.concepts.roots.map { |concept| vocab_pref_label_summary(concept) }
    }
  end

  def concept_json(concept)
    return nil if concept.nil?

    hash = {
      "@context": "https://github.com/babylon-online/schema/raw/master/contexts/concept.jsonld",
      schema: "https://github.com/babylon-online/schema/raw/master/concept.json",
      id: vocab_concept_id(concept),
      created: concept.created_at,
      issued: concept.created_at,
      modified: concept.updated_at,
      status: concept.status,
      creator: vocab_person_variable(concept.creator),
      contributors: concept.contributors.map { |c| vocab_person_variable(c) },
      publisher: vocab_person_variable(concept.creator),
      inScheme: vocab_scheme_summary(concept.scheme),
      prefLabel: vocab_label_map(concept.labels.where(type: "Preferred", is_abbrevation: false)),
      altLabel: vocab_label_map(concept.labels.where(type: "Alternative", is_abbrevation: false)),
      hiddenLabel: vocab_label_map(concept.labels.where(type: "Hidden", is_abbrevation: false)),
      broader: concept.broader_concepts.map { |c|
        {
          id: vocab_concept_id(c),
          prefLabel: vocab_label_map(c.labels.where(type: "Preferred", is_abbrevation: false)),
          facet: vocab_concept_id(c),
          inScheme: vocab_scheme_id(c.scheme)
        }
      },
      narrower: concept.narrower_concepts.map { |c|
        {
          id: vocab_concept_id(c),
          prefLabel: vocab_label_map(c.labels.where(type: "Preferred", is_abbrevation: false)),
          facet: vocab_concept_id(c),
          inScheme: vocab_scheme_id(c.scheme)
        }
      },
      related: {},
      broaderTransitive: {},
      narrowerTransitive: {},
      scopeNote: vocab_note_map(concept.notes.where(type: "Scope")),
      definition: vocab_note_map(concept.notes.where(type: "Definition")),
      example: vocab_note_map(concept.notes.where(type: "Example")),
      historyNote: vocab_note_map(concept.notes.where(type: "History")),
      editoialNote: vocab_note_map(concept.notes.where(type: "Editorial")),
      changeNote: vocab_note_map(concept.notes.where(type: "Change")),
      closeMatch: concept.matches.where(property: "close").map { |m| { name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable },
      exactMatch: concept.matches.where(property: "exact").map { |m| { name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable },
      relatedMatch: concept.matches.where(property: "related").map { |m| { name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable },
      broadMatch: concept.matches.where(property: "broader").map { |m| { name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable },
      narrowMatch: concept.matches.where(property: "narrower").map { |m| { name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable },
      links: {
        self: v1_namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept),
        html: namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept)
      }
    }

    if concept.root?
      hash[:topConceptOf] = vocab_scheme_summary(concept.scheme)
    else
      hash[:facet] = concept.ancestors.roots.map { |c|
        {
          id: vocab_concept_id(c),
          prefLabel: vocab_label_map(c.labels.where(type: "Preferred", is_abbrevation: false)),
          inScheme: vocab_scheme_id(c.scheme)
        }
      }
    end

    hash
  end

  # Compact concept serializer (HTML vocab controller)
  def concept_summary_json(concept)
    return nil if concept.nil?

    {
      id: concept.slug,
      status: concept.status,
      default_label: concept.name,
      url: v1_namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept),
      html_url: namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept),
      created_at: concept.created_at,
      updated_at: concept.updated_at,
      creator: {
        name: concept.creator.name,
        url: v1_person_url(concept.creator),
        html_url: namespace_url(concept.creator.namespace)
      },
      contributors: concept.contributors.map { |contrib|
        {
          name: contrib.name,
          url: v1_person_url(contrib),
          html_url: namespace_url(contrib.namespace)
        }
      },
      broader: concept.broader_concepts.map { |c|
        {
          default_label: c.name,
          url: v1_namespace_vocab_scheme_concept_url(c.scheme.namespace, c.scheme, c),
          html_url: namespace_vocab_scheme_concept_url(c.scheme.namespace, c.scheme, c)
        }
      },
      narrower: concept.narrower_concepts.map { |c|
        {
          default_label: c.name,
          url: v1_namespace_vocab_scheme_concept_url(c.scheme.namespace, c.scheme, c),
          html_url: namespace_vocab_scheme_concept_url(c.scheme.namespace, c.scheme, c)
        }
      },
      notes: Array(concept.notes).map { |n| n.as_json },
      labels: Array(concept.labels).map { |l| l.as_json },
      relations: concept.ext_matches + concept.loc_matches,
      matches: concept.matches.map { |match| { property: match.property, url: concept.api_uri } }
    }
  end

  def concept_scheme_json(scheme)
    return nil if scheme.nil?

    {
      "@context": "https://github.com/babylon-online/schema/raw/master/contexts/concept_scheme.jsonld",
      schema: "https://github.com/babylon-online/schema/raw/master/concept_scheme.json",
      id: vocab_scheme_id(scheme),
      created: scheme.created_at,
      creator: vocab_person_variable(scheme.creator),
      contributors: scheme.contributors.map { |c| vocab_person_variable(c) },
      title: { de: scheme.title },
      note: { de: scheme.definition },
      hasTopConcepts: scheme.concepts.roots.map { |concept|
        {
          id: vocab_concept_id(concept),
          prefLabel: vocab_label_map(concept.labels.where(type: "Preferred", is_abbrevation: false)),
          facet: vocab_concept_id(concept),
          inScheme: vocab_scheme_id(concept.scheme)
        }
      },
      links: {
        self: v1_namespace_vocab_scheme_url(scheme.namespace, scheme),
        html: namespace_vocab_scheme_url(scheme.namespace, scheme)
      }
    }
  end

  def vocab_label_json(label)
    return nil if label.nil?

    {
      type: label.type,
      body: label.body,
      language: label.language,
      abbreviation: label.is_abbrevation?,
      vernacular: label.vernacular,
      historical: label.historical
    }
  end

  def vocab_note_json(note)
    return nil if note.nil?

    {
      type: note.type,
      body: note.body,
      language: note.language
    }
  end

  # --- Locate ---
  def place_json(place)
    return nil if place.nil?

    {
      type: place.type,
      id: place.id,
      default_name: place.default_name
    }
  end

  # --- Zensus ---
  def zensus_activity_json(activity)
    return nil if activity.nil?

    {
      html_url: zensus_event_activity_url(activity.event, activity),
      actor: activity.actable.default_name,
      actor_url: v1_zensus_agent_url(activity.actable),
      property: activity.actable_to_event,
      event: activity.event.title,
      event_url: v1_zensus_event_url(activity.event)
    }
  end

  def zensus_appellation_json(appellation)
    return nil if appellation.nil?

    {
      id: appellation.id,
      name: appellation.name,
      full_name: appellation.name(prefix: true, suffix: true, preferred: false),
      url: v1_zensus_name_url(appellation),
      html_url: zensus_name_url(appellation),
      name_elements: appellation.appellation_parts.map { |p| { p.type.downcase.to_sym => p.body } },
      language: appellation.language,
      period: appellation.period,
      trans: appellation.trans,
      agent: (appellation.agent ? { url: v1_zensus_agent_url(appellation.agent), default_name: appellation.agent.default_name } : nil),
      created_at: appellation.created_at,
      updated_at: appellation.updated_at
    }
  end

  def zensus_agent_json(agent)
    return nil if agent.nil?

    {
      id: agent.slug,
      name: agent.default_name,
      type: (agent.type == "Zensus::Person" ? "Person" : "Group"),
      url: v1_zensus_agent_url(agent.id),
      html_url: zensus_agent_url(agent),
      created_at: agent.created_at,
      updated_at: agent.updated_at,
      address: agent.address,
      activities: Array(agent.activities).map { |a| zensus_activity_json(a) },
      appellations: Array(agent.appellations).map { |a| zensus_appellation_json(a) }
    }
  end

  def zensus_event_json(event)
    return nil if event.nil?

    {
      id: event.id,
      title: event.title,
      begins_at: event.begins_at,
      ends_at: event.ends_at(full: true),
      url: v1_zensus_event_url(event.id),
      html_url: zensus_event_url(event),
      created_at: event.created_at,
      updated_at: event.updated_at,
      activities: Array(event.activities).map { |a| zensus_activity_json(a) }
    }
  end

  # --- Aggregation ---
  def aggregation_item_json(item)
    return nil if item.nil?

    {
      name: item.name,
      id: item.id,
      url: v1_namespace_repository_aggregation_item_url(item.repository.owner, item.repository, item),
      html_url: namespace_repository_aggregation_item_url(item.repository.owner, item.repository, item),
      boi_url: v1_identifier_url(item.identifiers.first),
      commits_url: v1_namespace_repository_aggregation_item_commits_url(item.repository.owner, item.repository, item),
      revisions: item.commits.count,
      first_commit: item.commits.first.try(:created_at),
      last_commit: item.commits.last.try(:created_at),
      last_commit_url: item.commits.any? ? v1_namespace_repository_aggregation_item_commit_url(item.repository.owner, item.repository, item, item.commits.last) : nil,
      repository_url: v1_namespace_repository_url(item.repository.owner, item.repository)
    }
  end

  def aggregation_event_json(event)
    return nil if event.nil?

    {
      name: event.slug,
      id: event.id,
      url: v1_namespace_repository_aggregation_event_url(event.repository.owner, event.repository, event),
      html_url: namespace_repository_aggregation_event_url(event.repository.owner, event.repository, event),
      commits_url: v1_namespace_repository_aggregation_event_commits_url(event.repository.owner, event.repository, event),
      commits_count: event.commits.count,
      repository_url: v1_namespace_repository_url(event.repository.owner, event.repository),
      creator_url: v1_person_url(event.creator),
      message: event.note,
      commited_at: event.commited_at,
      created_at: event.created_at,
      updated_at: event.updated_at
    }
  end

  def aggregation_commit_json(commit)
    return nil if commit.nil?

    {
      id: commit.id,
      url: v1_namespace_repository_aggregation_item_commit_url(commit.item.repository.owner, commit.item.repository, commit.item, commit),
      html_url: namespace_repository_aggregation_item_commit_url(commit.item.repository.owner, commit.item.repository, commit.item, commit),
      item_url: v1_namespace_repository_aggregation_item_url(commit.item.repository.owner, commit.item.repository, commit.item),
      event_url: v1_namespace_repository_aggregation_event_url(commit.event.repository.owner, commit.event.repository, commit.event),
      data_format: commit.type.demodulize,
      data: commit.data,
      author_url: v1_person_url(commit.creator)
    }
  end

  # --- Mentions / references ---
  def mentionee_json(mentionee)
    return nil if mentionee.nil?

    {
      gid: mentionee.to_global_id.uri,
      name: mentionee.subclass.try(:name).presence || mentionee.name,
      namespace: mentionee.name,
      avatar_url: (mentionee.subclass ? "#{absolute_host_prefix}#{mentionee.subclass.image_url(:small_thumb)}".squish.gsub(/\s+/, "") : nil)
    }
  end

  def referenceable_json(referenceable)
    return nil if referenceable.nil?
    return nil if referenceable.try(:name).blank?

    {
      gid: referenceable.to_global_id.uri,
      name: referenceable.name,
      parents: case referenceable.class.name
               when /^Vocab::/
                 Array(referenceable.try(:broader_concepts)).map(&:name).compact.join(", ")
               when /^Biblio::/
                 parent_name = referenceable.try(:parent).try(:name)
                 parent_name.present? ? "in: #{parent_name}" : ""
               when /^Writer::/
                 referenceable.try(:repository).try(:name_tree)&.join(" / ")
               when /^Discussion::/
                 referenceable.try(:discussable).try(:name_tree)&.join(" / ")
               end,
      note: case referenceable.class.name
            when /^Vocab::/
              referenceable.try(:notes).try(:first).try(:body)
            when /^Biblio::/
              referenceable.try(:title).to_s.presence
            when /^Writer::/
              truncate(strip_tags(referenceable.try(:content).to_s), length: 100)
            when /^Discussion::/
              pluralize(referenceable.try(:comments_count).to_i, "comment")
            end,
      labels: (Array(referenceable.try(:labels)).map(&:body).compact.join(", ") if referenceable.class.name == "Vocab::Concept")
    }
  end
end
