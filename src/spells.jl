export pick_from_pool, cast

const ACTIONS = Any[]
const NAMES = [
    "Roger M",
    "H Roger",
    "Anna",
    "Alex",
    "Bohdan",
    "Isaac",
    "Ejaaz",
    "Wetzel",
    "Estelle",
    "Danny",
    "Lucy",
    "You",
]

"""
    @action <action function>(name)

Register an action function. An action function must take
a `name` as input and return a sentence of type `String`.
"""
macro action(ex)
    def = splitdef(ex)

    quote
        export $(esc(def[:name]))
        $(esc(ex))
        push!($(GlobalRef(PinGo, :ACTIONS)), $(esc(def[:name])))
        $(esc(def[:name]))
    end
end

"""
    does_or_not(name, action; magic_number=0.432)

`name` does `action` or not. By probability of a `magic_number`.
"""
does_or_not(name, action; magic_number=0.432) = string(name, " ", rand() < magic_number ? "not " : "", action)

@action wear_pants(name="Roger") = does_or_not(name, "wearing pants")
@action drink_beer(name="Roger") = does_or_not(name, "drinking beer")
@action squats(name="Roger") = does_or_not(name, "doing squats")
@action pushups(name="Roger") = does_or_not(name, "doing push-ups")
@action cast_spells(name="Roger") = does_or_not(name, "casting spells")
@action learned_so_much(name="Roger") = does_or_not(name * " have", "learned so much")

const BINGO_POOL = readlines(joinpath(@__DIR__, "pool.txt"))

"""
    pick_from_pool()

Randomly pick a phrase from the pool.
"""
pick_from_pool() = rand(BINGO_POOL)

function cast(p1=0.3, p2=0.4)
    dice = rand()
    if dice < p1
        return pick_from_pool()
    else dice < p1 + p2
        rand(ACTIONS)(rand(NAMES))
    end
end
