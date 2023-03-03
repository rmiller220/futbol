require_relative 'stat_tracker'
require 'csv'
require_relative 'stat_holder'
require_relative 'games'
require_relative 'game_teams'
require_relative 'league'

class StatTracker
# require 'pry'; binding.pry
  attr_reader :locations
  def self.from_csv(locations)
    new(locations)
  end
  def initialize(locations)
    @games = Games.new(locations)
    @teams = League.new(locations)
    @game_teams = GameTeam.new(locations)
  end
  
  def highest_total_score
    @games.highest_total_score
  end
  
  def lowest_total_score
    @games.lowest_total_score
  end

  def average_goals_by_season
    @games.average_goals_by_season
  end

  def percent_home_wins
   @games.percent_home_wins
  end

  def percent_away_wins
   @games.percent_away_wins
  end

  def percent_ties
    @games.percent_ties
  end

  def count_of_games_by_season
    @games.count_of_games_by_season
  end

  def average_goals_per_game
    @games.average_goals_per_game
  end

  def count_of_teams
    @teams.count_of_teams
  end

  def best_offense
    index = @teams.team_id.find_index(@game_teams.best_offense)
    @teams.team_name[index]
  end

  def worst_offense
    index = @teams.team_id.find_index(@game_teams.worst_offense)
    @teams.team_name[index]
  end

  def highest_scoring_visitor 
    index = @teams.team_id.find_index(@game_teams.highest_scoring_visitor)
    @teams.team_name[index]
  end

  def lowest_scoring_visitor
    index = @teams.team_id.find_index(@game_teams.lowest_scoring_visitor)
    @teams.team_name[index]
  end

  def highest_scoring_home_team 
    index = @teams.team_id.find_index(@game_teams.highest_scoring_home_team)
    @teams.team_name[index]
  end

  def lowest_scoring_home_team
    index = @teams.team_id.find_index(@game_teams.lowest_scoring_home_team)
    @teams.team_name[index]
  end

  def winningest_coach(season_id)
    @game_teams.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_teams.worst_coach(season_id)
  end

  def least_accurate_team(season)
    index = @teams.team_id.find_index(@game_teams.least_accurate_team(season))
    @teams.team_name[index]
  end

  def most_accurate_team(season)
    index = @teams.team_id.find_index(@game_teams.most_accurate_team(season))
    @teams.team_name[index]
  end

  def most_tackles(season)
    index = @teams.team_id.find_index(@game_teams.most_tackles(season))
    @teams.team_name[index]
  end

  def least_tackles(season)
    index = @teams.team_id.find_index(@game_teams.least_tackles(season))
    @teams.team_name[index]
  end
end