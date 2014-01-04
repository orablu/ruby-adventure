class String
    def proper
        return self.split(' ').collect{|w| w.capitalize}.join(' ')
    end
end

# Everything passed as an event will be created as a callable method in the class.
class Thing
    @@default_action = Proc.new{}
    attr_reader :name
    attr_reader :description
    attr_reader :value

    def initialize(name, desc = nil, value = 0, events: {})
        @name = 'A thing'
        @description = desc
        @value = value
        metaclass = (class << self; self; end)
        events.each do |symbol, action|
            next unless Thing.method_defined? symbol
            metaclass.send(:define_method, symbol, &action)
        end
    end

    def to_s
        return "#{@name}\n--------------------\n#{@description}"
    end
end

# Event: Entity.dodged(attack)
class Entity < Thing
    HP_RATE_MOD = 0.03
    attr_reader :mhp
    attr_reader :hp
    attr_reader :status
    attr_reader :dodge
    attr_reader :attacks
    attr_reader :items

    def initialize(name, level, starthp, hprate = 1.5, dodge = 0.1, description = nil, attacks: {}, items: {}, &dodged)
        dodged ||= @@default_action
        super(name, description, events: {:dodged => dodged})
        @level = level
        @mhp = @hp = starthp
        @hprate = hprate
        @status = []
        @dodge = dodge
        @attacks = attacks
        @items = items
        level.times{ levelup }
    end

    def levelup(attacks = nil)
        @level = @level + 1
        rate = @hprate + @level / HP_RATE_MOD
        hp = (rand * rate).floor
        @mhp = @hp = @mhp + hp
        attacks.each{ |attack| @attacks << attack } if attacks
    end

    def attack(entity, attack = nil)
        attack = (rand * @attacks.length).floor unless attack
        entity.hit_with @attacks[attack] if @attacks[attack].use
    end

    def hit_with(attack)
        if rand < dodge then
            @hp = @hp - attack.power
            attack.apply_effects self
            return @hp < 0
        end
        dodged attack
        return false
    end

    def cure(item)
        @status.each{|status| @status.delete(status) if status.cure == item}
    end

    def heal(amount)
        @hp = @hp + amount < @mhp ? @hp + amount : @mhp
    end

    def recover(amount, attack = nil)
        if attack
            @attacks[attack].recover amount
        else
            @attacks.each{|a| a.recover amount}
        end
    end

    def to_s
        str = "#{@name} (#{@hp}/#{@mhp} hp)\n--------------------\n#{@description}"
        @attacks.each{|k, v| str << "\n #{v.to_s}"}
    end
end

# Event: Item.used(on, [for])
class Item < Thing
    attr_reader :effects

    def initialize(name, description, value, usechance = 1.0, used_up: nil, &used)
        used ||= @@default_action
        used_up ||= @@default_action
        super(name, description, value, events: {:use => used, :use_up => used_up})
        @isused = false
        @usechance = usechance
    end

    def used?
        return @isused
    end

    def use(entity)
        if @for
            use entity @for
        else
            use entity
        end
        @isused = rand < @usechance
        use_up if @isused
        return @isused
    end
end

# Events: Effect.applied(to)
class Effect < Thing
    attr_reader :type
    attr_reader :chance
    attr_reader :damage
    attr_reader :cure

    def initialize(name, description, type, cure, chance = 1.0, damage = 0, &applied)
        applied ||= @@default_action
        super(name, description, events: {:applied => applied})
        @type = type
        @cure = cure
        @chance = chance
        @damage = damage
    end

    def apply_to(entity)
        if rand < chance then
            effect = entity.get_effect @type
            entity.status.delete if effect and @damage > effect.damage
            entity.status << self unless effect and @damage < effect.damage
            applied entity
            return true
        end
        return false
    end
end

# Event: Attack.used(by), Attack.no_pp(self)
class Attack < Thing
    attr_reader :type
    attr_reader :power
    attr_reader :effects
    attr_reader :mpp
    attr_reader :pp

    def initialize(name, description, type, power, pp = nil, canrecover = true, effects = [], no_pp: nil, &used)
        no_pp ||= @@default_action
        used ||= @@default_action
        super(name, description, events: {:used => used, :no_pp => no_pp})
        @type = type
        @power = power
        @effects = effects
        @mpp = @pp = pp
        @canrecover = canrecover
    end

    def use(entity)
        if pp then
            if pp < 1 then
                no_pp self
                return false
            end
            pp = pp - 1
        end
        used entity
        return true
    end

    def apply_effects(entity)
        affected = false
        @effects.each{ |e| affected ||= e.apply_effect entity }
        return affected
    end

    def recover(amount)
        @pp = @pp + amount < @mpp ? @pp + amount : @mpp if @canrecover
    end
end

# Events: looked(self/room)
class Room < Thing
    def initialize(name, description, doors = {}, &looked)
        looked ||= @@default_action
        super(name, description, events: {:looked => looked})
        @doors = doors
    end

    def look
        looked self
        @doors.each{ |door| looked door }
    end

    def open(direction)
        door = @door[direction]
        return door.open if door
        return false
    end
end

# Events: opened
class Door < Thing
    def initialize(name, description, to, open = true, &opened)
        opened ||= @@default_action
        super(name, description, events: {:opened => opened})
        @open = open
    end

    def open?
        return @open
    end

    def open
        if not @open then
            @open = true
            opened
            return @open
        end
        return false
    end
end
