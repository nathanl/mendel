class FoosballTeam
  attr_accessor :players

  def initialize(*players)
    self.players = players
  end

  def average_age
    players.reduce(0){ |total, player|
      total += player.fetch(:age)
    } / 2.0
  end

  # So that one Set of FoosballTeams will be equal to another
  # if the teams have the same players
  def eql?(other)
    other.class == self.class && other.players == players
  end

  def hash
    players.hash
  end

end
