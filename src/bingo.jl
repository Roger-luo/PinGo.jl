struct Bingo
    table::Matrix{String}
end

Bingo() = Bingo([cast() for _ in 1:5, _ in 1:5])

string(rand('a':'z', 10)...)
Base.setindex!(b::Bingo, v::String, inds...) = b.table[inds...] = v
Base.getindex(b::Bingo, inds...) = b.table[inds...]
Base.lastindex(b::Bingo) = lastindex(b.table)

save(b::Bingo) = save("bingo.pdf", b)

function save(filename, b::Bingo)
    name, ext = splitext(filename)
    Luxor.Drawing(595, 708, filename)
    Luxor.origin()

    tiles = Tiler(600, 650, 5, 5)
    translate(0, 30)
    background("#6a6703")
    for (pos, n) in tiles
        sethue("white")
        box(pos, tiles.tilewidth, tiles.tileheight, :fillpreserve)
        sethue("black")
        strokepath()
        fontface("Monaco")
        
        fsize = 18
        fontsize(fsize)
        lines = textlines(b[n], 120; rightgutter=3)
        if length(lines) > 5
            fsize = 12
            fontsize(fsize)
            lines = textlines(b[n], 120; rightgutter=3)
        end
        
        if n == 13
            sethue("red")
            fontsize(22)
            fontface("Helvetica Bold")
            # settext("<b>FREE</b>", pos - (0, 40), halign="center", markup=true)
            text("FREE", pos - (0, 40), halign=:center)
            fontface("Monaco")
            fontsize(fsize)
            textbox(lines, pos - (0, 32), leading=20, alignment=:center)
            sethue("black")
        else
            textbox(lines, pos - (0, 50), leading=20, alignment=:center)
        end
    end
    sethue("black")
    fontsize(35)
    text("P", Point(-245, -360), valign = :top)
    text("I", Point(-130, -360), valign = :top)
    text("Qu", Point(-20, -360), valign = :top)
    text("I", Point(105, -360), valign = :top)
    text("L", Point(220, -360), valign = :top)
    Luxor.finish()
end

function generate(;preview=true)
    b = Bingo()
    save(b)

    if preview
        Luxor.preview()
    end
end

function Base.show(io::IO, b::Bingo)
    println("Bingo sheet:")
    print(io, b[1])
    for each in b[2:end]
        println(io)
        print(io, each)
    end
end
