class Account::ApplicationsController < Account::ApplicationController
  account_load_and_authorize_resource :application, through: :team, through_association: :applications

  # GET /account/teams/:team_id/applications
  # GET /account/teams/:team_id/applications.json
  def index
    delegate_json_to_api
  end

  # GET /account/applications/:id
  # GET /account/applications/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/applications/new
  def new
  end

  # GET /account/applications/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/applications
  # POST /account/teams/:team_id/applications.json
  def create
    respond_to do |format|
      if @application.save
        format.html { redirect_to [:account, @application], notice: I18n.t("applications.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @application] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/applications/:id
  # PATCH/PUT /account/applications/:id.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to [:account, @application], notice: I18n.t("applications.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @application] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/applications/:id
  # DELETE /account/applications/:id.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :applications], notice: I18n.t("applications.notifications.destroyed") }
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
