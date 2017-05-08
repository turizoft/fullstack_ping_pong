module ApplicationHelper
  def field_errors(builder, field, aditional_clases = '')
    unless builder.object.errors[field].blank?
      content_tag :div, class: "ui label #{aditional_clases}" do
        content_tag :span, builder.object.errors[field].first.html_safe
      end
    end
  end

  def ranking_text(ranking)
    ranking < 1 ? "N/A" : ranking.ordinalize
  end

  def active_if_current_user(user, current_user)
    user == current_user ? 'active' : ''
  end
end
