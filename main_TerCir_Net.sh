### Analysis for TerCirNet

###################################################### BASELINE
#time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de p -S 1 -w -P 49 --zIni -10 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.5 --mu_r 0.01 --max_d 100&
###################################################### SPECIAL CASES
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 100 -w -P 100 --zIni -1 --type_network square_grid --mK 300 --cM 0.0 --epsilon 0. --mu_r 0.0 --max_d 100&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 100 -w -P 100 --zIni -1 --type_network square_grid --mK 300 --cM 0.2 --epsilon 0. --mu_r 0.0 --max_d 100&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 100 -w -P 100 --zIni -1 --type_network square_grid --mK 300 --cM 0.0 --epsilon 0. --mu_r 0.005 --max_d 100&

######### Analysis for PHIL TRANS PAPER

###################################################### Cost of migration change the rate of increase: Figure1
# for i in $(seq 0.0 0.025 0.25)
# do
#     time julia model_TerCir_Net.jl -G 50000 --print 1 --j_print 200 --de g -S 100 -w -P 49 --zIni -10 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.01 --max_d 100&
# done
# wait


###################################################### Effect of epsilon: Figure 2
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de p -S 1 -w -P 49 --zIni -10 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.1 --mu_r 0.01 --max_d 100&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de p -S 1 -w -P 49 --zIni -10 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.5 --mu_r 0.01 --max_d 100&


###################################################### Balance between cost of migration and epsilon: Figure 2

# for j in $(seq 0. 0.025 0.25)
# do
#     for i in $(seq 0.0 0.05 0.5)
#     do
#         time julia model_TerCir_Net.jl -G 30000 --print 29500 --j_print 1 --de g -S 100 -w -P 49 --zIni -10 --type_network square_grid --mK 300 --cM $j --epsilon $i --mu_r 0.01 --max_d 100&
#     done
#     wait
# done

###################### maxD and P
# With variations: Figure 3 (For periodic, supplementary figure 2, need to change it directly in the code)
# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0
# do
#     for j in 9 16 25 36 49 64 81 100
#     do
#          time julia model_TerCir_Net.jl -G 30000 --print 29500 --j_print 1 --de g -S 100 -w -P $j --zIni -10 --type_network square_grid --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d $i&
#     done
#     wait
# done

# NO VARIATIONS: Supplementary figure 1
# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0
# do
#     for j in 9 16 25 36 49 64 81 100
#     do
#          time julia model_TerCir_Net.jl -G $(($j * 200 +1)) --print $(($j * 10 )) --j_print $(($j * 10)) --de g -S 100 -w -P $j --zIni -10 --type_network square_grid --mK 300 --cM 0.05 --epsilon 0. --mu_r 0.01 --max_d $i&
#     done
#     wait
# done


####################################################### EXPLANATION OF EACH FACTOR: Supplementary Figure 3
####################### With variations
# # ### Effect of cm on speed
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.005 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0.25 --mu_r 0.005 --max_d 1&

# ### Effect of connectivity on spread
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1.5&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 3&

# ###Effect of n_patches on unstability
# time julia model_TerCir_Net.jl -G 1350 --print 1 --j_print 100 --de g -S 20 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1&
# time julia model_TerCir_Net.jl -G 3750 --print 1 --j_print 100 --de g -S 20 -w -P 25 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.005 --max_d 1&


#######################No variations
# # Effect of cm on speed
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.0 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0.25 --mu_r 0.0 --max_d 1&

# ### Effect of connectivity on spread
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1.5&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 3&

# ###Effect of n_patches on unstability
# time julia model_TerCir_Net.jl -G 1350 --print 1 --j_print 100 --de g -S 20 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1&
# time julia model_TerCir_Net.jl -G 3750 --print 1 --j_print 100 --de g -S 20 -w -P 25 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1&
# time julia model_TerCir_Net.jl -G 15000 --print 1 --j_print 100 --de g -S 20 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.0 --max_d 1&



####################################################### DIFFERENT SCENARIOS: Figure 4
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de g -S 500 -w -P 50 --zIni -10 --type_network complete --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 100&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de g -S 500 -w -P 50 --zIni -10 --type_network clique --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de g -S 500 -w -P 50 --zIni -10 --type_network valley --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&

###############Effect of clique size: Supplementary figure 4
# time julia model_TerCir_Net.jl -G 30000 --print 29500 --j_print 1 --de p -S 500 -w -P 50 --zIni -10 --type_network clique --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 29500 --j_print 1 --de p -S 500 -w -P 50 --zIni -10 --type_network valley --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&



###################### Others analysis
####################################################### Effect of connectivity
#I am not sure which algo gives the next shortest path, so i just took it from julia
# count=0
# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0 4.123105625617661 4.242640687119285 4.47213595499958 5.0 5.0990195135927845 5.385164807134504 5.656854249492381 5.830951894845301 6.0 6.082762530298219 6.324555320336759 6.4031242374328485 6.708203932499369 7.0 7.0710678118654755 7.211102550927978 7.280109889280518 7.615773105863909 7.810249675906654 8.0 8.06225774829855 8.246211251235321 8.48528137423857 8.54400374531753 8.602325267042627 8.94427190999916 9.0 9.055385138137417 9.219544457292887 9.433981132056603 9.486832980505138 9.848857801796104 9.899494936611665 10.0 10.295630140987 10.63014581273465 10.816653826391969 11.313708498984761 11.40175425099138 12.041594578792296 12.727922061357855
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P 100 --zIni -1 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0. --mu_r 0.005 --max_d $i&
#     ((count ++));
#     echo $count
#     if (( count%7 == 0))
#     then
#         wait
#     fi
# done

###################################################### Interactions





# for i in $(seq 0.05 0.1 0.25)
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.01 --max_d 1&
# done
# wait

# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0 4.123105625617661
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d $i&
# done
# wait

# for i in 9 25 49 100
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P $i --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d 1&
# done

# for i in $(seq 0.05 0.1 0.25)
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.01 --max_d 1.0&
# done
# wait

# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0 4.123105625617661
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d $i&
# done
# wait

# for i in 9 25 49 100
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P $i --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d 3.0&
# done



# for i in $(seq 0.05 0.1 0.25)
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.01 --max_d 3.0&
# done
# wait

# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0 3.1622776601683795 3.605551275463989 4.0 4.123105625617661
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d $i&
# done
# wait

# for i in 9 25 49 100
# do
#     time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de p -S 100 -w -P $i --zIni 0.05 --type_network square_grid --mK 300 --cM 0.25 --epsilon 0. --mu_r 0.01 --max_d 3.0&
# done

#maxD and P
# for i in 1.0 1.4142135623730951 2.0 2.23606797749979 2.8284271247461903 3.0
# do
#     for j in 9 16 25 36 49
#     do
#         time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P $j --zIni 0.05 --type_network square_grid --mK 300 --cM 0.1 --epsilon 0. --mu_r 0.005 --max_d $i&
#     done
#     wait
# done

### How much max_d depends of the rest
# for i in $(seq 0.05 0.05 0.25)
# do
#     for j in 9 25 100
#     do
#         time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P $j --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.005 --max_d 1.&
#         time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P $j --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.005 --max_d 1000.&
#     done
#     wait

# done

### How much npatch depends of the rest
# for i in $(seq 0.05 0.05 0.25)
# do
#     for j in 1. 3. 100.
#     do
#         time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P 9 --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.005 --max_d $j&
#         time julia model_TerCir_Net.jl -G 30000 --print 29000 --j_print 100 --de g -S 100 -w -P 100 --zIni 0.05 --type_network square_grid --mK 300 --cM $i --epsilon 0. --mu_r 0.005 --max_d $j&
#     done
#     wait

# done




#BARABASI

# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.05 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.1 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.2 --epsilon 0.25 --mu_r 0.01 --max_d 1.01&

# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.05 --epsilon 0.5 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.1 --epsilon 0.5 --mu_r 0.01 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.2 --epsilon 0.5 --mu_r 0.01 --max_d 1.01&


# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.05 --epsilon 1 --mu_r 0.05 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.1 --epsilon 1 --mu_r 0.05 --max_d 1.01&
# time julia model_TerCir_Net.jl -G 30000 --print 1 --j_print 500 --de p -S 100 -w -P 100 --zIni -10 --type_network BA --mK 300 --cM 0.2 --epsilon 1 --mu_r 0.05 --max_d 1.01&


