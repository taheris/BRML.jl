using MATLAB


const buffer_size = 2 * 1024 # 2kb

# connect to MATLAB engine and intialise BRML toolbox
restart_default_msession(buffer_size)
@matlab begin
    cd("C:/Users/Shaun/dropbox/code/matlab/brml")
    setup
end
