using FactCheck
using BRML


facts("Testing General Functions") do
    scalar = 5
    array = [27, 33, 16]
    vector = [11, 33, 22]
    matrix = [12 2 44;
              41 5 26]
    threedim = reshape(5:16, 2,2,3)

    context("argmin / argmax") do
        @fact argmin([]) => :throws
        @fact argmin([]) => :throws
        
        @fact argmin(scalar) => (1, 5)
        @fact argmax(scalar) => (1, 5)

        @fact argmin(array) => (3, 16)
        @fact argmax(array) => (2, 33)

        @fact argmin(vector) => (1, 11)
        @fact argmax(vector) => (2, 33)

        @fact argmin(matrix) => ([1 1 2], [12 2 26])
        @fact argmax(matrix) => ([2 2 1], [41 5 44])
    end
    
    context("logsumexp") do
        @fact logsumexp([]) => :throws
        @fact logsumexp(scalar) => 5
        @fact logsumexp(array) => roughly(33.002)
        @fact logsumexp(vector) => roughly(33)
        @fact logsumexp(matrix) => roughly([41 5.04859 44])
    end

    context("avgSigmaGauss") do
        @fact avgSigmaGauss(0, 0) => 0.5
        @fact avgSigmaGauss(0.2, 0.3) => roughly(0.54718)
    end

    context("cap") do
        @fact cap(-3, 2) => -2
        @fact cap([-5:5], 1) => [-1,-1,-1,-1,-1,0,1,1,1,1,1]
    end
    
    context("dirRand") do
        x = dirRand([1:10], 5)
        for i=1:5
            @fact sum(x[:,i]) => roughly(1)
        end
    end
    
end
