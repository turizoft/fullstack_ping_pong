module GamesHelper
  def match_result_color(result)
    case result
    when 'L'
     'red'
    when 'D'
     'grey'
    when 'W'
      'green'
    end
  end
end
