# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule UneebeeWeb.Components.Content.LessonStep do
  @moduledoc false
  use UneebeeWeb, :html

  alias Uneebee.Content.LessonStep

  attr :step, LessonStep, required: true
  attr :selected, :integer, default: nil

  def lesson_step(%{step: %{kind: :text}} = assigns) do
    ~H"""
    <section>
      <p class="text-gray-dark rounded-2xl bg-white p-4 shadow"><%= @step.content %></p>
      <.option_list :if={@selected && @step.options != []} options={@step.options} selected={@selected} />
    </section>
    """
  end

  def lesson_step(%{step: %{kind: :image}} = assigns) do
    ~H"""
    <section>
      <div class="text-gray-dark flex justify-center rounded-2xl bg-white p-4 shadow">
        <img src={@step.content} class="w-1/3" />
      </div>

      <.option_list :if={@selected && @step.options != []} options={@step.options} selected={@selected} />
    </section>
    """
  end

  defp option_list(assigns) do
    ~H"""
    <div class="mt-2">
      <% selected = selected_option(@options, @selected) %>
      <% color = if selected.correct?, do: :success_light, else: :alert_light %>
      <% icon = if selected.correct?, do: "tabler-checks", else: "tabler-alert-square-rounded" %>
      <% default_feedback =
        if selected.correct?, do: dgettext("courses", "Well done!"), else: dgettext("courses", "That's incorrect.") %>
      <% feedback = if selected.feedback, do: selected.feedback, else: default_feedback %>

      <.badge color={color} icon={icon} class="mt-2">
        <%= dgettext("courses", "You selected: %{title}. %{feedback}", title: selected.title, feedback: feedback) %>
      </.badge>

      <.badge :if={not selected.correct?} color={:success_light} icon="tabler-checks">
        <%= dgettext("courses", "Correct answer: %{title}.", title: correct_option(@options).title) %>
      </.badge>
    </div>
    """
  end

  defp selected_option(options, selected_id) do
    Enum.find(options, fn option -> option.id == selected_id end)
  end

  defp correct_option(options), do: Enum.find(options, fn option -> option.correct? end)
end