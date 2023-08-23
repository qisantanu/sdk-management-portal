# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ApplicationsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :application, through: :team, through_association: :applications

    # GET /api/v1/teams/:team_id/applications
    def index
    end

    # GET /api/v1/applications/:id
    def show
    end

    # POST /api/v1/teams/:team_id/applications
    def create
      if @application.save
        render :show, status: :created, location: [:api, :v1, @application]
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/applications/:id
    def update
      if @application.update(application_params)
        render :show
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/applications/:id
    def destroy
      @application.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def application_params
        strong_params = params.require(:application).permit(
          *permitted_fields,
          :name,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::ApplicationsController
  end
end
