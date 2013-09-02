using FactCheck
using BRML


facts("Testing General Matlab Functions") do
    include("test_data.jl")

    context("chi2test") do
        @fact chi2test([1:5], 0.1) => roughly([0 4.6 6.25 7.78 9.24])
    end

    context("condexp") do
        @fact condexp(vector) => [1/3 1/3 1/3]'
        @fact condexp(matrix) => roughly([0 0.047 1; 1 0.95 0], atol=0.01)
    end

    context("condp") do
        @fact condp(vector) => [1/6, 1/2, 1/3]
    end

    context("gaussCond") do
        obs = [NaN, 0]
        meanAll = [0.5 1]'
        sAll = [0.9625 -0.0726; -0.0726 0.1809]
        mean, covariance = gaussCond(obs, meanAll, sAll)

        @fact mean => roughly(0.9013, atol=0.01)
        @fact covariance => roughly(0.933, atol=0.01)
    end

    context("stateCount") do
        data = [1 2 1 2 1 2; 2 1 1 2 2 1]
        states = [2 2]

        @fact stateCount(data,states) => ([1.0 2 2 1], [1.0 1; 2 1; 1 2; 2 2])
    end
end
