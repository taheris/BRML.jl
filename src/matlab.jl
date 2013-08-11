# connect to MATLAB engine and intialise BRML toolbox
if MATLAB.default_msession == nothing
    get_default_msession()

    brml_path = string(pwd(), "/matlab")
    @mput brml_path
    
    @matlab begin
        cd(brml_path)
        setup
    end
end
