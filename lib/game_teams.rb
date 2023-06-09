require_relative 'requirements'
require_relative 'game_teams_helper'

class GameTeams < StatReader
  include GameTeamsHelper

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

  def most_tackles(season)
    tackle_checker(season)[:best_team]
  end

  def fewest_tackles(season)
    tackle_checker(season)[:worst_team]
  end

  def best_season(team)
    win_loss_checker(team)[:best_szn]
  end

  def worst_season(team)
    win_loss_checker(team)[:worst_szn]
  end

  def most_goals_scored(team)
    goals_checker(team)[:most_goals]
  end

  def fewest_goals_scored(team)
    goals_checker(team)[:least_goals]
  end

  def winningest_coach(season)
    coach_checker(season)[:best_coach]
  end

  def worst_coach(season)
    coach_checker(season)[:worst_coach]
  end

  def most_accurate_team(season)
    accuchecker(season)[:best_team]
  end

  def least_accurate_team(season)
    accuchecker(season)[:worst_team]
  end

  def average_win_percentage(team)
    wins, games = 0, 0
    win_loss_counter[team].each do |_, szn|
      wins += szn[:wins]
      games += szn[:games]
    end
    wins.fdiv(games).round(2)
  end

  def favorite_opponent(team)
    rivalries(team)[:fav_opp]
  end

  def rival(team)
    rivalries(team)[:rival]
  end

  def biggest_team_blowout(team)
    matchups[team][:blowouts][:boom]
  end

  def worst_loss(team)
    matchups[team][:blowouts][:bust]
  end

  def head_to_head(team)
    h2h = matchups[team]
    h2h.delete(:blowouts)
    h2h.each do |_, record|
      record[:win_pct] = record[:wins].fdiv(record[:games]).round(3)
    end
    h2h
  end
end