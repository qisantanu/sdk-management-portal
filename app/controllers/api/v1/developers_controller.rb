# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::DevelopersController < Api::V1::ApplicationController
    account_load_and_authorize_resource :developer, through: :team, through_association: :developers

    # GET /api/v1/teams/:team_id/developers
    def index
    end

    # GET /api/v1/developers/:id
    def show
    end

    # POST /api/v1/teams/:team_id/developers
    def create
      if @developer.save
        render :show, status: :created, location: [:api, :v1, @developer]
      else
        render json: @developer.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/developers/:id
    def update
      if @developer.update(developer_params)
        render :show
      else
        render json: @developer.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/developers/:id
    def destroy
      @developer.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def developer_params
        strong_params = params.require(:developer).permit(
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
  class Api::V1::DevelopersController
  end
end
