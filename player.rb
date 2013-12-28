require './abstracts'

# Events: dodged(attack)
class Player < Entity
    attr_reader :level
    def initialize(name, level = 1, starthp = 3, hprate = 2.9, attacks: [], events: {})
        super(name, level, starthp, 0.2, attacks: attacks[1], events: events)
    end

    def attack(entity, i, &fail)
        if @attacks[i].use
            entity.hit_with @attacks[i]
        else
            @no_pp.call(@attacks[i])
        end
    end
end
