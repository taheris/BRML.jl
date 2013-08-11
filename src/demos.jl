# demoGibbsGauss: demo of Gibbs sampling of a bivariate Gaussian
function demoGibbsGauss()
    @matlab figure

    A = randn(2,2)
    S = A*A'
    m = zeros(2,1)
    plotCov(m,S,2)
    eval_string("axis equal; hold on;")

    x = zeros(2,200)
    for l = 1:99
        x[2,2l] = x[2,2l-1]
        m1, S1 = gaussCond([NaN, x[2,2l-1]], m, S)
        x[1,2l] = multivarRandN(m1, S1)[1]
        lineX = [x[1,2l-1], x[1,2l]]
        lineY = [x[2,2l-1], x[2,2l]]
        @mput lineX lineY
        @matlab line(lineX, lineY)

        x[1,2l+1] = x[1,2l]
        m2, S2 = gaussCond([x[1,2l], NaN], m, S)
        x[2,2l+1] = multivarRandN(m2, S2)[1]
        lineX = [x[1,2l], x[1,2l+1]]
        lineY = [x[2,2l], x[2,2l+1]]
        @mput lineX lineY
        @matlab line(lineX, lineY)
    end
end
