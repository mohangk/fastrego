class InstitutionsController < ApplicationController

  # GET /institutions
  # GET /institutions.json
  def index
  @search = Institution.ransack(params[:q])
  @institutions = @search.result.alphabetically.for_tournament current_tournament.identifier

  puts @institutions.map(&:country)

  @countries = @institutions.map(&:country).uniq.sort!

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @institutions }
    end
  end

  # GET /institutions/1
  # GET /institutions/1.json
  #def show
  #  @institution = Institution.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @institution }
  #  end
  #end

  # GET /institutions/new
  # GET /institutions/new.json
  def new
    @institution = Institution.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @institution }
    end
  end

  # GET /institutions/1/edit
  #def edit
  #  @institution = Institution.find(params[:id])
  #end

  # POST /institutions
  # POST /institutions.json
  
  def create
    
    @institution = institution_factory

    respond_to do |format|
      if @institution.save
        format.html { redirect_to institutions_path, notice: 'Institution was successfully registered.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  private

  def institution_factory
    klass = (!params[:institution][:type].nil? && params[:institution][:type].constantize) || OpenInstitution
    institution = klass.new params[:institution] 
    institution.tournament = current_tournament if klass == OpenInstitution
    institution
  end

  # PUT /institutions/1
  # PUT /institutions/1.json
  #def update
  #  @institution = Institution.find(params[:id])
  #
  #  respond_to do |format|
  #    if @institution.update_attributes(params[:institution])
  #      format.html { redirect_to @institution, notice: 'Institution was successfully updated.' }
  #      format.json { head :ok }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @institution.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /institutions/1
  # DELETE /institutions/1.json
  #def destroy
  #  @institution = Institution.find(params[:id])
  #  @institution.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to institutions_url }
  #    format.json { head :ok }
  #  end
  #end
end
