using FactCheck
#using BRML # remove b.


facts("Testing Potential Types") do
    context("PotArray") do
        table = zeros(2,2,2)
        table[:,:,1] = [0.1 0.2; 0.9 0.8]
        table[:,:,2] = [0.6 0.3; 0.4 0.7]
        pot = b.PotArray(["knife", "butler", "maid"], table,
                         ["butler" => ["murderer", "not murderer"],
                          "maid" => ["murderer", "not murderer"],
                          "knife" => ["used", "not used"]])

        #pot[[("knife","used"), ("butler","not murderer"), ("maid","not murderer")]] = 0.3
        #pot[[("knife","used"), ("butler","not murderer"), ("maid","murderer")]] = 0.2
        #pot[[("knife","used"), ("butler","murderer"), ("maid","not murderer")]] = 0.6
        #pot[[("knife","used"), ("butler","murderer"), ("maid","murderer")]] = 0.1
        #pot[("knife","not used")] = 1 - pot[("knife","used")]

        #@fact pot[[:maid=>:murderer]][:] => [0.1, 0.9, 0.2, 0.8]
        #@fact pot[[:maid=>:murderer,:knife=>:used]][:] => [0.1, 0.2]

        #butler = b.PotArray([:butler=>[:murderer,:notmurderer]])
        #butler[[:butler=>:murderer]] = 0.6
        #butler[[:butler=>:notmurderer]] = 0.4

        #maid = b.PotArray([:maid=>[:murderer,:notmurderer]])
        #maid[[:maid=>:murderer]] = 0.2
        #maid[[:maid=>:notmurderer]] = 0.8
    end
end
