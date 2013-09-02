using FactCheck
#using BRML # remove b.


facts("Testing Potential Types") do
    knife = b.PotArray(["knife", "butler", "maid"],
                       ["knife" => ["used", "not used"],
                        "butler" => ["murderer", "not murderer"],
                        "maid" => ["murderer", "not murderer"]])

    knife["used", "not murderer", "not murderer"] = 0.3
    knife["used", "not murderer", "murderer"] = 0.2
    knife["used", "murderer", "not murderer"] = 0.6
    knife["used", "murderer", "murderer"] = 0.1

    knife["not used", "not murderer", "not murderer"] =
        1 - knife["used", "not murderer", "not murderer"]
    knife["not used", "not murderer", "murderer"] =
        1 - knife["used", "not murderer", "murderer"]
    knife["not used", "murderer", "not murderer"] =
        1 - knife["used", "murderer", "not murderer"]
    knife["not used", "murderer", "murderer"] =
        1 - knife["used", "murderer", "murderer"]

    butler = b.PotArray(["butler"], ["butler"=>["murderer","not murderer"]])
    butler["murderer"] = 0.6
    butler["not murderer"] = 0.4

    maid = b.PotArray(["maid"], ["maid"=>["murderer", "not murderer"]])
    maid["murderer"] = 0.2
    maid["not murderer"] = 0.8

    context("PotArray") do
        table = zeros(2,2,2)
        table[:,:,1] = [0.1 0.2; 0.9 0.8]
        table[:,:,2] = [0.6 0.3; 0.4 0.7]
        @fact knife.table => table
        @fact knife["not used", "murderer", "not murderer"] => 0.4

        jointPot = knife * butler * maid
        @fact jointPot["used", "murderer", "murderer"] => 0.012

        sumKnife = b.sumpot(knife, ["butler","maid"])
        @fact sumKnife["used"] => 1.2
    end
end
