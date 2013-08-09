using MATLAB


const buffer_size = 2 * 1024 # 2kb

# connect to MATLAB engine and intialise BRML toolbox
restart_default_msession(buffer_size)

brml_path = string(pwd(), "/matlab")
@mput brml_path

@matlab begin
    cd(brml_path)
    setup
end
