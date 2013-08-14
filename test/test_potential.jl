using FactCheck
#using BRML # remove b.


facts("Testing Potential Types") do
    context("PotArray") do
        pot = b.PotArray([:knife=>[:used,:notused],:maid=>[:murderer,:notmurderer],
                          :butler=>[:murderer,:notmurderer]])
        pot[[:knife=>:used,:butler=>:notmurderer,:maid=>:notmurderer]] = 0.3
        pot[[:knife=>:used,:butler=>:notmurderer,:maid=>:murderer]] = 0.2
        pot[[:knife=>:used,:butler=>:murderer,:maid=>:notmurderer]] = 0.6
        pot[[:knife=>:used,:butler=>:murderer,:maid=>:murderer]] = 0.1
        pot[[:knife=>:notused]] = 1 - pot[[:knife=>:used]]

        @fact pot[[:maid=>:murderer]] => [0.1 0.9; 0.2 0.8]
        @fact pot[[:maid=>:murderer,:knife=>:used]] => [0.1, 0.2]
    end
end
