require './abstracts'

class Player < Entity
    attr_reader :level
    def initialize(name, level = 1, starthp = 3, hprate = 2.9, attacks: [], events: {})
        super(name, level, starthp, 0.2, attacks: attacks[1], events: events)
    end
end
