using FactCheck
using BRML


facts("Testing General Matlab Functions") do
    scalar = 5
    array = [27, 33, 16]
    vector = [11, 33, 22]
    matrix = [12 2 44;
              41 5 26]
    threedim = reshape(5:16, 2,2,3)

    context("chi2test") do
        @fact chi2test([1:5], 0.1) => roughly([0 4.6 6.25 7.78 9.24])
    end

    context("stateCount") do
        @fact (stateCount([1 2 1 2 1 2; 2 1 1 2 2 1], [2 2])
               => ([1 2 2 1], [1 1; 2 1; 1 2; 2 2]))
    end

    context("condp") do
        @fact condp(vector) => [1/6, 1/2, 1/3]
    end
end
