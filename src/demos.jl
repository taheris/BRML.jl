# demoClouseau: inspector clouseau example
function demoClouseau()
end

# demoGibbsGauss: demo of Gibbs sampling of a bivariate Gaussian
function demoGibbsGauss()
    A = randn(2,2)
    S = A*A'
    m = zeros(2,1)
    plotCov(m,S,2)

    x = zeros(2,200)
    for l = 1:99
        x[2,2l] = x[2,2l-1]
        m1, S1 = gaussCond([NaN, x[2,2l-1]], m, S)
        x[1,2l] = multiVarRandN(m1, S1)[1]

        x[1,2l+1] = x[1,2l]
        m2, S2 = gaussCond([x[1,2l], NaN], m, S)
        x[2,2l+1] = multiVarRandN(m2, S2)[1]
    end

    # send variables to MATLAB session then plot lines
    @mput x
    eval_string("""
    axis equal; hold on
    for l=1:99
        line([x(1,2*l-1) x(1,2*l)], [x(2,2*l-1) x(2,2*l)])
        line([x(1,2*l) x(1,2*l+1)], [x(2,2*l) x(2,2*l+1)])
    end
    """)
end
