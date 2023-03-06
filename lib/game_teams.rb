require_relative 'stat_book'

class GameTeams < StatBook
  def initialize(locations)
    super(locations[:game_teams])
  end

  def best_offense
    goals_counter.max_by{|_, v| v[:goals].fdiv(v[:games])}[0]
  end
  
  def worst_offense
    goals_counter.min_by{|_, v| v[:goals].fdiv(v[:games])}[0]
  end

  def highest_scoring_visitor
    goals_counter.max_by{|_, v| v[:away].fdiv(v[:games])}[0]
  end

  def lowest_scoring_visitor
    goals_counter.min_by{|_, v| v[:away].fdiv(v[:games])}[0]
  end

  def highest_scoring_home_team
    goals_counter.max_by{|_, v| v[:home].fdiv(v[:games])}[0]
  end

  def lowest_scoring_home_team
    goals_counter.min_by{|_, v| v[:home].fdiv(v[:games])}[0]
  end

  def winningest_coach(season)
    coaches = Hash.new { |h, k| h[k] = Hash.new{ |h, k|h[k] = Hash.new(0) }}
    (0..@team_id.count).each do |i|
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:wins] += 1 if @result[i] == 'WIN'
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:games] += 1
    end
    winningest_record = 0
    winningest_coach = nil
    coaches.each do |coach, szns|
      record = szns[season.slice(0..3)][:wins]&.fdiv(szns[season.slice(0..3)][:games])
      if record > winningest_record
        winningest_record = record
        winningest_coach = coach
      end
    end
    winningest_coach
  end

  def worst_coach(season)
    coaches = Hash.new { |h, k| h[k] = Hash.new{ |h, k|h[k] = Hash.new(0) }}
    (0..@team_id.count).each do |i|
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:wins] += 1 if @result[i] == 'WIN'
      coaches[@head_coach[i]][@game_id[i]&.slice(0..3)][:games] += 1
    end
    worst_record = 1
    worst_coach = nil
    coaches.each do |coach, szns|
      record = szns[season.slice(0..3)][:wins]&.fdiv(szns[season.slice(0..3)][:games])
      if record < worst_record
        worst_record = record
        worst_coach = coach
      end
    end
    worst_coach
  end

  def least_accurate_team(season)
    teams = Hash.new { |h, k| h[k] = Hash.new{ |h, k|h[k] = Hash.new(0) }}
    (0..@team_id.count).each do |i|
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:shots] += @shots[i].to_i
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:goals] += @goals[i].to_i
    end
    worst_ratio = 0
    worst_team = nil
    teams.each do |team, szns|
      ratio = szns[season.slice(0..3)][:shots]&.fdiv(szns[season.slice(0..3)][:goals])
      if ratio > worst_ratio
        worst_ratio = ratio
        worst_team = team
      end
    end
    worst_team
  end

  def most_accurate_team(season)
    teams = Hash.new { |h, k| h[k] = Hash.new{ |h, k|h[k] = Hash.new(0) }}
    (0..@team_id.count).each do |i|
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:shots] += @shots[i].to_i
      teams[@team_id[i]][@game_id[i]&.slice(0..3)][:goals] += @goals[i].to_i
    end
    best_ratio = 9
    best_team = nil
    teams.each do |team, szns|
      ratio = szns[season.slice(0..3)][:shots]&.fdiv(szns[season.slice(0..3)][:goals])
      if ratio < best_ratio
        best_ratio = ratio
        best_team = team
      end
    end
    best_team
  end

  def most_tackles(season)
    teams = Hash.new { |h, k| h[k] = Hash.new(0)}
    (0..@team_id.count).each do |i|
      teams[@team_id[i]][@game_id[i]&.slice(0..3)] += @tackles[i].to_i
    end
    best_team = nil
    most_tackles = 0
    teams.each do |team, szns|
      tackles = szns[season.slice(0..3)]
      if most_tackles < tackles
        most_tackles = tackles
        best_team = team
      end
    end
    best_team
  end

  def least_tackles(season)
    teams = Hash.new { |h, k| h[k] = Hash.new(0)}
    (0..@team_id.count).each do |i|
      teams[@team_id[i]][@game_id[i]&.slice(0..3)] += @tackles[i].to_i
    end
    worst_team = nil
    least_tackles = 5000
    teams.each do |team, szns|
      tackles = szns[season.slice(0..3)]
      if least_tackles > tackles && tackles > 0
        least_tackles = tackles
        worst_team = team
      end
    end
    worst_team
  end

  ## Helper Method ##

  def goals_counter
    goals = Hash.new { |h, k| h[k] = Hash.new(0) }
    (0..@team_id.count).each do |i|
      goals[@team_id[i]][:goals] += @goals[i].to_i
      goals[@team_id[i]][:away] += @goals[i].to_i if @hoa[i] == 'away'
      goals[@team_id[i]][:home] += @goals[i].to_i if @hoa[i] == 'home'
      goals[@team_id[i]][:games] += 1
    end
    goals.delete(nil)
    goals
  end
end