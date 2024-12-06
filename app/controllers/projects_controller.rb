class ProjectsController < ApplicationController
  def index
    if @current_user
      @project = Project.find(params[:project_id])
      @task_percentages = @project.tasks.pluck(:percentage) # 配列で位置データを取得
      @task_names = @project.tasks.pluck(:name)
    end
  end

  def suggest
    begin
      # project_idが存在する場合にのみ処理を行う
      if params[:project_id].present?
        @project = Project.find(params[:project_id])
        user_skills = @project.users.pluck(:skills).join(", ")
        Rails.logger.info("GPT Request: Team skills - #{user_skills}")

        client = OpenAI::Client.new
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
              { role: "system", content: "You are a software project planner in japanese." },
              { role: "user", content: "Here are the team skills: #{user_skills}. Please suggest a project name, description, and estimated time distribution for each feature in percentages. Please respond in Japanese, and format your response as follows:" },
              { role: "user", content: "Project Name: \"<name of the project>\"\nDescription: <project description>\nFeatures:\n1. <feature name> (<percentage>%)\n2. <feature name> (<percentage>%)" }
            ],
            temperature: 0.7
          }
        )

        if response.nil? || response["choices"].nil? || response["choices"].empty?
          Rails.logger.error("Invalid response from GPT API: #{response.inspect}")
          render json: { error: "Failed to receive a valid response from GPT API." }, status: :unprocessable_entity
          return
        end

        gpt_content = response.dig("choices", 0, "message", "content")
        if gpt_content.nil?
          Rails.logger.error("No content returned from GPT.")
          render json: { error: "No content returned from GPT." }, status: :unprocessable_entity
          return
        end
        Rails.logger.info("Parsed GPT content: #{gpt_content}")

        # プロジェクト名の抽出
        project_name_match = gpt_content.match(/プロジェクト名: ?"([^"]+)"/i)
        if project_name_match
          @project.name = project_name_match[1]
        else
          Rails.logger.error("Project name not found in GPT content.")
          render json: { error: "Project name not found in GPT response." }, status: :unprocessable_entity
          return
        end

        # 説明の抽出
        description_match = gpt_content.match(/説明:\s*(.*?)\n/)
        @project.description = description_match ? description_match[1].strip : "No description provided"

        # 特徴の抽出
        features_raw = gpt_content.scan(/(\d+\.\s.*? \(\d+%\))/)
        Rails.logger.debug("Extracted features_raw: #{features_raw.inspect}")

        features = features_raw.map do |feature|
          feature_name_match = feature.first.match(/^(.*)\s\((\d+)%\)$/)
          if feature_name_match
            { "name" => feature_name_match[1].strip, "percentage" => feature_name_match[2].to_i }
          else
            Rails.logger.error("Failed to parse feature: #{feature}")
            nil
          end
        end.compact

        # DB保存処理 (project_idが存在する場合)
        if @project.save
          Rails.logger.info("Project updated successfully: #{@project.id}")
          @project.tasks.destroy_all
          features.each do |feature|
            task = Task.new(project: @project, name: feature["name"], percentage: feature["percentage"])
            if task.save
              Rails.logger.info("Task created successfully: #{task.id}")
            else
              Rails.logger.error("Failed to create task: #{task.errors.full_messages.join(", ")}")
            end
          end
          render json: { message: "Project and tasks successfully saved.", project_id: @project.id }
        else
          Rails.logger.error("Failed to update project: #{@project.errors.full_messages.join(", ")}")
          render json: { error: "Failed to update project." }, status: :unprocessable_entity
        end

      else
        # project_idが存在しない場合（ログインしていない時）
        client = OpenAI::Client.new
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
              { role: "system", content: "You are a software project planner in japanese." },
              { role: "user", content: "Here are the team skills: #{user_skills}. Please suggest a project name, description, and estimated time distribution for each feature in percentages. Please respond in Japanese, and format your response as follows:" },
              { role: "user", content: "Project Name: \"<name of the project>\"\nDescription: <project description>\nFeatures:\n1. <feature name> (<percentage>%)\n2. <feature name> (<percentage>%)" }
            ],
            temperature: 0.7
          }
        )

        if response.nil? || response["choices"].nil? || response["choices"].empty?
          Rails.logger.error("Invalid response from GPT API: #{response.inspect}")
          render json: { error: "Failed to receive a valid response from GPT API." }, status: :unprocessable_entity
          return
        end

        gpt_content = response.dig("choices", 0, "message", "content")
        if gpt_content.nil?
          Rails.logger.error("No content returned from GPT.")
          render json: { error: "No content returned from GPT." }, status: :unprocessable_entity
          return
        end
        Rails.logger.info("Parsed GPT content: #{gpt_content}")

        # プロジェクト名と説明を抽出して画面に表示
        project_name_match = gpt_content.match(/プロジェクト名: ?"([^"]+)"/i)
        @project_name = project_name_match ? project_name_match[1] : "No project name provided"

        description_match = gpt_content.match(/説明:\s*(.*?)\n/)
        @description = description_match ? description_match[1].strip : "No description provided"

        # 特徴の抽出
        features_raw = gpt_content.scan(/(\d+\.\s.*? \(\d+%\))/)
        Rails.logger.debug("Extracted features_raw: #{features_raw.inspect}")

        @features = features_raw.map do |feature|
          feature_name_match = feature.first.match(/^(.*)\s\((\d+)%\)$/)
          if feature_name_match
            { "name" => feature_name_match[1].strip, "percentage" => feature_name_match[2].to_i }
          else
            Rails.logger.error("Failed to parse feature: #{feature}")
            nil
          end
        end.compact

        # 画面に表示
        render json: { project_name: @project_name, description: @description, features: @features }
      end

    rescue StandardError => e
      Rails.logger.error("[Suggest Action] An error occurred: #{e.message}")
      Rails.logger.error("[Suggest Action] Backtrace: #{e.backtrace.join("\n")}")
      render json: { error: "An unexpected error occurred." }, status: :internal_server_error
    end
  end




  def create
    if @current_user
      @project = Project.new(name: "New Project") # 必要に応じて属性を追加
      if @project.save
        @project.project_members.create(user_id: @current_user.id, role: "owner")
        session[:project_id] = @project.id  # プロジェクトIDをセッションに保存
        flash[:notice] = "プロジェクトが作成されました。"
        redirect_to("/")
      else
        flash[:alert] = "プロジェクトの作成に失敗しました: #{@project.errors.full_messages.join(', ')}"
        redirect_to("/signup")  # 失敗時も / にリダイレクト
      end
    else
      redirect_to("/")
    end
  end

  def search_members
    query = params[:query]
    project_id = params[:project_id]

    # ログイン済みユーザーのプロジェクトにすでに追加されていないユーザーを検索
    project = Project.find(project_id)
    members = User.where("name LIKE ?", "%#{query}%")
                  .where.not(id: project.user_ids) # すでに追加済みのユーザーは除外

    render json: members
  end

  def show
    @project = Project.find(params[:id])
    @members = @project.users # プロジェクトメンバーを取得（`has_many :users`の関係があることを前提）
  end

  def update
    @project = Project.find(params[:project_id])
    if product.update(projects_params)
      render json: { status: "success", product: product }
    else
      render json: { status: "error", errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def projects_params
    params.require(:product).permit(:name, :description, schedule: {})
  end
end
