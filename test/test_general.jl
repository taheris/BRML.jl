using FactCheck
#using BRML # remove b.


facts("Testing General Functions") do
    include("test_data.jl")
    
    context("argmin / argmax") do
        @fact b.argmin([]) => :throws
        @fact b.argmin([]) => :throws
        
        @fact b.argmin(scalar) => (1, 5)
        @fact b.argmax(scalar) => (1, 5)

        @fact b.argmin(array) => (3, 16)
        @fact b.argmax(array) => (2, 33)

        @fact b.argmin(vector) => (1, 11)
        @fact b.argmax(vector) => (2, 33)

        @fact b.argmin(matrix) => ([1 1 2], [12 2 26])
        @fact b.argmax(matrix) => ([2 2 1], [41 5 44])
    end
    
    context("logsumexp") do
        @fact b.logsumexp([]) => :throws
        @fact b.logsumexp(scalar) => 5
        @fact b.logsumexp(array) => roughly(33.002)
        @fact b.logsumexp(vector) => roughly(33)
        @fact b.logsumexp(matrix) => roughly([41 5.05 44], atol=0.01)
    end

    context("avgSigmaGauss") do
        @fact b.avgSigmaGauss(0, 0) => 0.5
        @fact b.avgSigmaGauss(0.2, 0.3) => roughly(0.547, atol=0.01)
    end

    context("cap") do
        @fact b.cap(-3, 2) => -2
        @fact b.cap([-5:5], 1) => [-1,-1,-1,-1,-1,0,1,1,1,1,1]
    end

    context("condexp") do
        @fact b.condexp(vector) => [1/3 1/3 1/3]'
        @fact b.condexp(matrix) => roughly([0 0.047 1; 1 0.95 0], atol=0.01)
    end
    
    context("dirRand") do
        x = b.dirRand([1:10], 5)
        for i=1:5
            @fact sum(x[:,i]) => roughly(1)
        end
    end

    context("normP") do
        @fact b.normP(vector) => [1/6, 1/2, 1/3]
        @fact b.normP(matrix) => roughly([0.0923 0.0154 0.338; 0.315 0.0385 0.2],
                                         atol=0.01)
    end

    context("sigma") do
        @fact b.sigma(vector) => roughly([0.999, 1, 1], atol=0.01)
        @fact b.sigma(matrix) => roughly([0.999 0.88 1; 1 0.993 1], atol=0.01)
    end
end
