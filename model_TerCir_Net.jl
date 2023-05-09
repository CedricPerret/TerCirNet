using Distributions
using DataFrames
using CSV
using Random
using ArgParse
using Distributed
using BenchmarkTools


include(homedir()*"/OneDrive/Research/B1-Codes/Utility.jl")
include(homedir()*"/OneDrive/Research/B1-Codes/Toolbox_network.jl")

##Function to parse arguments
function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--write", "-w"
            action = :store_true
            help = "Will the ouput written on a csv file?"
            dest_name = "write_file"
        "-d"
            action = :store_true
            dest_name = "distributed"
        "--split"
            action = :store_true
            dest_name = "split_simul"
            help = "write the output on a different file for each simul"
        "--nSimul", "-S"
            arg_type = Int64
            dest_name = "n_simul"
        "--nGen", "-G"
            arg_type = Int64
            help = "Total number of generation"
            dest_name = "n_gen"
        "--print"
            arg_type = Int64
            help = "Generation from which output is saved"
            dest_name = "n_print"
        "--j_print"
            arg_type = Int64
            dest_name = "j_print"
        "--de"
            help = "Level of detail g = gen, p = patch, i = individual"
        "-P"
            help = "Number of polities"
            arg_type = Int64
            default = 50
            dest_name = "n_patch"
        "--type_network"
            help = "Set degree and type of network (complete, square_grid, stepping_stone)"
            arg_type = String
        "--mK"
            help = "Mean productivity of patches"
            arg_type = Float64
            default = 500.0
            dest_name = "mean_K"
        "--sigK"
            help = "Variance of productivity of patches"
            arg_type = Float64
            default = 0.0
            dest_name = "sigma_K"
        "--fileK"
            help = "File if productivity is imported"
            arg_type = String
            dest_name = "file_K"
            default = "Empty"
        "--cM"
            help = "Cost of migration" 
            arg_type = Float64
            default = 0.0
            dest_name = "c_m"
        "--zIni"
            help = "Initial level of inequality. z_ini<-10 -> random between 0.05 and 0.1, -10<z_ini<0 random between 0.25 and 0.75. 0<z_ini<1. All patches have z_ini. 1<z_ini, all = 0.75 except patch in center at 0.25 "
            arg_type = Float64
            default = -12.
            dest_name = "z_ini"
        "--epsilon"
            arg_type = Float64
            help = "errors are drawn on a uniform distribution [-epsilon, +epsilon]"
        "--mu_r"
            arg_type = Float64
            help = "Probability of random events"
        "--max_d"
            arg_type = Float64
            help = "maximum distance at which migration is possible"
        "--periodic"
            arg_type = Bool
            help = "Is the square grid periodic"
            default = false
    end
    return parse_args(s, as_symbols=true)
end

#For debugging. Otherwise, the values of the parameters are given in the bash file.
# n_patch = 25
# n_pop_ini = 500
# mean_K = 500 
# sigma_K = 0 
# z_ini = 2.0 
# c_m = 0.01 
# delta = 0.25 
# type_network = "square_grid" 
# growth = "scramble"
# n_pop_ini = 10.
# r = 3.
# beta = 10
# n_sites = 100.
# l_max = 0.1
# l_inc = 0.01
# l_mid = 50.
# beta_k_m = 0.25
# beta_k_c = 0.25
# gamma = 0.0025
# n_pop0 = 300.
# b_h_m = 10.
# b_h_c = 10.
# k = 3.

#To print out network
#using Plots, GraphRecipes
#Complete
# n_patch = 50
# network = build_homogeneous_network("complete",n_patch, true) 
# savegraph(homedir()*"/OneDrive/Research/A1-Projects/2022_TerCir/Code/Network_complete.txt", network, "graph", LGFormat())


#Islands
# network,clique_size = build_heterogeneous_clique_network(50,8) 
# print(vcat([fill(i,clique_size[i]) for i in 1:length(clique_size)]...))
# savegraph(homedir()*"/OneDrive/Research/A1-Projects/2022_TerCir/Code/Network_islands.txt", network, "graph", LGFormat())

#Valleys
# network,clique_size = build_heterogeneous_clique_stepping_network(50,3) 
# print(vcat([fill(i,clique_size[i]) for i in 1:length(clique_size)]...))
# graphplot(network,method=:tree)
# savegraph(homedir()*"/OneDrive/Research/A1-Projects/2022_TerCir/Code/Network_valleys.txt", network, "graph", LGFormat())

# n_patch = 100
# network = Graphs.barabasi_albert(Integer(n_patch), 1)
# graphplot(network)
# savegraph(homedir()*"/OneDrive/Research/A1-Projects/2022_TerCir/Code/Network_BA.txt", network, "graph", LGFormat())

# n_patch = 100
# network = Graphs.watts_strogatz(Integer(n_patch), 4,0.5)
# graphplot(network)



"""
    Calculate_cost_of_migrating(c_m,distance,max_d)
Calculate the cost of migrating depending of distance -> cost function
"""
function calculate_proba_survival_migration(c_m,distance,max_d)
    if distance == 0
        return(1)
    elseif distance <= max_d
        return(1 - c_m)
    else
        return(0)
    end
end



function model(parameters::Dict, i_simul::Int64)
    #Because we redifine it later
    n_patch = parameters[:n_patch]
    #Set parameters from dictionaries to local variable (only to improve readability)
    for key in keys(parameters) eval(:($(Symbol(key)) = $(parameters[key]))) end
    #Set seed
    Random.seed!(i_simul)

    #Initially, all in the same clique. Replace it by clique number if relevant
    clique_size = [n_patch]
    
    #Either we load the graph from an edge list or we build it.
    if any(occursin.([".csv",".txt"],type_network))
        network = loadgraph(type_network, "graph", LGFormat())
    elseif type_network == "barbell"
        network = Graphs.barbell_graph(Int(round(clique_ratio * n_patch)), n_patch - Int(round(clique_ratio * n_patch)))
    elseif type_network == "clique"
        #Controling clique size
        # network, clique_size=build_heterogeneous_clique_network(5,10,20) 
        #Controling N patches
        network, clique_size=build_heterogeneous_clique_network(n_patch,8) 
    elseif type_network == "valley"
        #Controling clique size
        # network,clique_size = build_heterogeneous_clique_stepping_network(5,10,20) 
        #Controling N patches
        network, clique_size=build_heterogeneous_clique_stepping_network(n_patch,3) 
    elseif type_network == "BA"
        network =  Graphs.barabasi_albert(Integer(n_patch), 1)
    elseif type_network == "WS"
        network = Graphs.watts_strogatz(n_patch, 2, 0.5)

    else
        network = build_homogeneous_network(type_network,n_patch, periodic)
    end
    #Boolean rather than int
    am_network = Matrix(Graphs.adjacency_matrix(network,Bool))

    #For cliques and valley network, the number of patches can vary. 
    #We either keep the total number of patches the same or the number of cliques
    n_patch = nv(network)



    if type_network == "square_grid"
        x_coord = repeat(1:Int(sqrt(n_patch)),outer=Int(sqrt(n_patch)))
        y_coord = repeat(1:Int(sqrt(n_patch)),inner=Int(sqrt(n_patch)))
        if periodic == false
            distance_matrix = reduce(hcat,[sqrt.((x_coord[i] .- x_coord).^2 .+ (y_coord[i] .- y_coord).^2) for i in 1:n_patch])
        else
            distance_matrix = reduce(vcat,[sqrt.((min.(abs.(x_coord[i] .- x_coord), Int(sqrt(n_patch)) .- abs.(x_coord[i] .- x_coord)) .^2) .+ (min.(abs.(y_coord[i] .- y_coord), Int(sqrt(n_patch)) .- abs.(y_coord[i] .- y_coord)) .^2)) for i in 1:n_patch]')
        end
        #For square_grid, the connection depends of the distance
        am_network = (distance_matrix .< max_d) - diagm(trues(n_patch)) 

    else
        #The code still need to print the xcoord and ycoord (but it does not matter here) 
        x_coord = collect(1:n_patch)
        y_coord = collect(1:n_patch)
        #The distance is 1 if connected, 2 if not
        distance_matrix = am_network .* 1 + (.!am_network * 2.) - diagm(fill(2,n_patch))
        
    end

    #Plot step distance for square grid of 100
    # x_coord = repeat(1:Int(sqrt(100)),outer=Int(sqrt(100)))
    # y_coord = repeat(1:Int(sqrt(100)),inner=Int(sqrt(100)))
    # distance_matrix = reduce(hcat,[sqrt.((x_coord[i] .- x_coord).^2 .+ (y_coord[i] .- y_coord).^2) for i in 1:100])
    # print(sort(unique(distance_matrix)))
    # plot(sort(unique(distance_matrix)))


    clique_size_by_patch = vcat([fill(i,i) for i in clique_size]...)


    #Calculate proba to survive migration
    #We remove the diagonal because comparison with the payoff in their own patches is already implemented in the update function
    #In other words, we here calculate the payoff they would get in neighbouring groups only
    proba_surviving_migration_to = max.(calculate_proba_survival_migration.(c_m,distance_matrix,max_d),0.) - diagm(ones(n_patch))



    #distribution productivity of patches(sigma = 0 for uniform)
    if file_K != "Empty"
        df = CSV.read(file_K,DataFrame, header = 1)
        #In case, productivity is only integer numbers
        K_patches = convert.(Float64,df.productivity)

    else
        if sigma_K == 0
            K_patches = fill(mean_K,n_patch)
        else
            K_patches = rand(Truncated(Normal(mean_K,sigma_K),0,Inf),n_patch)
            #K_patches = vcat(fill(100,40),fill(200,20),fill(100,40))
        end
    end




    #Initialise population
    #Random inequality between 0.05 and 0.1
    if z_ini <= -10
        population= 0.05 .+ 0.05 .* rand(n_patch)
    #Random inequality between 0.25 and 0.75
    elseif z_ini < 0 
        population= 0.25 .+ 0.5 .* rand(n_patch)
    #Same given inequality for all
    elseif z_ini < 1
        population=repeat([z_ini],n_patch)
    #All patches except 1 have high inequality 0.75. A single patch in the center has low inequality 0.25
    elseif z_ini > 1
        population = fill(0.75, n_patch)
        population[Integer(round(n_patch/2)+1)] = 0.25
    end
    

    #Prepare output (see Utility.jl)
    #Constant output by patch
    cst_output_patch = ["degree" => dropdims(sum(am_network,dims=2),dims=2),
    "max_degree_neigh" => dropdims(maximum(dropdims(sum(am_network,dims=2),dims=2)' .* am_network,dims=2),dims=2),
    "K" => K_patches, "K_neigh" => dropdims(maximum(K_patches' .* am_network,dims=2),dims=2),
    "phi_2" => dropdims(sum(am_network+am_network^2,dims=2),dims=2),"degree_2" => dropdims(sum(am_network^2,dims=2),dims=2),
    "x_coord" => x_coord,"y_coord" => y_coord,
    "clique_size" => clique_size_by_patch]
    #Constant output by gen
    cst_output_gen = ["mean_degree" => mean(dropdims(sum(am_network,dims=2),dims=2))]
    #Create dataframe + saver function (see Utility.jl)
    df_res, saver = init_data_output(only(de),["error"],["z"],
    [], n_gen, n_print, j_print, i_simul, n_patch, 1,
    cst_output_gen = cst_output_gen,cst_output_patch = cst_output_patch)


    error = false

    for i_gen in 1:(n_gen)
        ##### UPDATE INEQUALITY =================================================================================================================
        #### UPDATE INEQUALITY WITH LEADER AVOIDING ANY MIGRATION ---------------------------------------------
        #Choose a random leader
        learner = rand(1:n_patch)
        #Update function
        population[learner] = 1 - maximum(proba_surviving_migration_to[learner,:] .* (1 .- population))
        #Random variations
        if rand() < mu_r 
            error = true
            population[learner] = clamp(population[learner] + ((rand() - 0.5) * (2*epsilon)),0,1)
        else
            error = false
        end
        saver(df_res,i_gen,[error],[population],[])
    end


    return(df_res)
end

#The output files have parameters in the name (see Utility.jl)
#Parameters to remove from the name of the output file
to_remove = ["j_print","n_print","sigma_K"]

#Run with replicate
replicator(pwd()*"/TerCir_Net",to_remove)

