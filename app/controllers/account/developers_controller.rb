class Account::DevelopersController < Account::ApplicationController
  account_load_and_authorize_resource :developer, through: :team, through_association: :developers

  # GET /account/teams/:team_id/developers
  # GET /account/teams/:team_id/developers.json
  def index
    delegate_json_to_api
  end

  # GET /account/developers/:id
  # GET /account/developers/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/developers/new
  def new
  end

  # GET /account/developers/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/developers
  # POST /account/teams/:team_id/developers.json
  def create
    respond_to do |format|
      if @developer.save
        format.html { redirect_to [:account, @developer], notice: I18n.t("developers.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @developer] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/developers/:id
  # PATCH/PUT /account/developers/:id.json
  def update
    respond_to do |format|
      if @developer.update(developer_params)
        format.html { redirect_to [:account, @developer], notice: I18n.t("developers.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @developer] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @developer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/developers/:id
  # DELETE /account/developers/:id.json
  def destroy
    @developer.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :developers], notice: I18n.t("developers.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
