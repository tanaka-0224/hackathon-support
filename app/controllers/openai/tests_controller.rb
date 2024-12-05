class Openai::TestsController < ApplicationController
  protect_from_forgery

  def show
  end

  def generate_text
    @user_input = params[:user_input]

    if @user_input.present?
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "関西弁で返答してください" },
            { role: "user", content: @user_input }
          ],
          temperature: 0.7
        }
      )
      @generated_text = response.dig("choices", 0, "message", "content")
      render json: { text: @generated_text }
    end
  end
end
