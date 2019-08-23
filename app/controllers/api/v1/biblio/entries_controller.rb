module Api::V1::Biblio
  class EntriesController < Api::V1::BaseController
    load_and_authorize_resource except: :index, class: 'Biblio::Entry'
    skip_authorization_check
    before_action :set_type, except: :index
    before_action :set_type_variable, except: [:index, :new, :create]
    DEFAULT_PER_PAGE = 50

    def index
      @all_entries = ::Biblio::Entry.all
      @entries = @all_entries
        .where.not(type: ['Biblio::Serie', 'Biblio::Journal'])
      @serials = @all_entries
        .where(type: ['Biblio::Serie', 'Biblio::Journal'])
        .order(citation_raw: :asc)
      
      query = params[:q].presence || '*'
      sorted_by = params[:sorted_by] ||= (params[:q].present? ? 'score_desc' : 'year_asc')
      sort_order = Biblio::Entry.sorted_by(sorted_by) if @all_entries.any?

      per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE

      @results = Biblio::Entry.search(query, 
        fields: [{citation: :exact}, :entry_type, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tag^10", 
          :volume, :number, :note, :isbn, :url, :doi, :abstract],
        where: { id: {not: @serials.ids} },
        misspellings: {below: 1},
        order: sort_order, 
        page: params[:page], 
        per_page: per_page)
      
        render json: @results, meta: pagination_dict(@results), each_serializer: EntrySerializer, adapter: :json
    
    end

    def show
      render json: @entry, serializer: EntrySerializer, adapter: :json
    end



    private
    def set_type_variable
      instance_variable_set("@#{@type.demodulize.underscore}", @entry)
    end

    def set_type
      @type = type
    end
    
    def type
      Biblio::Entry.types.include?(params[:type]) ? params[:type] : "Biblio::Entry"
    end
    
    def type_class
      type.constantize
    end


  end
end