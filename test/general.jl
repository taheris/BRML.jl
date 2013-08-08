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
end
