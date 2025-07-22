; use the NetLogo extension profiler to assess which model procedures
extensions [profiler]

globals [
  mean_net_phot  ; average net assimilation of all leaves
  ambient_T  ; air temperature
  temp_variation  ; temperature variation
  irr_variation
  irr_min_threshold
  irr_min_threshold_var
  mean_oviposition_per_leaf  ; average number of ovipositions per leaf
  mean_mature_mines_per_leaf  ; average number of mature mines per leaf
  mean_n_empty_mines_per_leaf  ; average number of mines from which adult miners were hatched --> empty mines
  mean_net_phot_damage  ; average net assimilation of all leaves after mining damage
  mean_mined_area_per_leaf  ; average total leaf mine area per leaf
  mean_unmined_area_per_leaf  ; average total unmined area per leaf
  mean_plant_vigor
  mean_leaf_wat_pot
  hy  ; half year  --> number of tick for each year that separates year by half
  y  ; year --> number of tick that ends each year
  week_year  ; week counter per year
  month_year  ; month counter per year
  n_year  ; year counter per year
  min_PARI  ; minimum possible photosynthetically active radiation
  max_PARI  ; maximum possible photosynthetically active radiation
  new_PARI  ; updated photosynthetically active radiation over year
  crown_status  ; crown status determines if a patch is part of the crown or not
  CO2_conc  ; CO2 concentration
  min_CO2  ; minimum CO2 concentration 400 ppm
  max_CO2  ; maximum CO2 concentration 415 ppm
  start_growing_season  ; this threshold determines at which timepoint leaves are hatched in spring each year
  end_growing_season  ; this threshold determines at which tempoint leaves die each year in winter
  fruit_age_start  ; set beginning of productive age
  fruit_age_end  ; set end of productive age
  max_productive_age  ; set age with maximum productivity
  inv_leaf_count  ; inverse leaf count to plant vigor
  fruit_limit  ; this threshold determines if fruits are hatched from leaves or not
  leaf_productive_age  ; only if leaf reaches certain age its energy can be used to produce other leaves --> if younger energy is used for own growth
  initial_egg_number  ; start the egg counter for each leaf miner
  larval_mortality  ; a certain percentage of larvae dies per timestep
  leaf_temp_factor_T  ; µ for normal distribution of temperature variation
  leaf_temp_factor_dist  ; sigma for normal distribution of temerperature variation
  C_assim_factor  ; factor for calculating carbon assimilation from net assimilation rates
  leaf_gen_factor_25  ; threshold which needs to be overcome to grown new leaves --> different for different ages
  branch_gen_factor_25  ; threshold which needs to be overcome to grown other tree parts --> different for different ages
  leaf_gen_factor_30
  branch_gen_factor_30
  leaf_gen_factor_35
  branch_gen_factor_35
  leaf_gen_factor_40
  branch_gen_factor_40
  leaf_position_25  ; leaf position factor determines positions of newly grown leaves
  leaf_position_30
  leaf_position_35
  leaf_position_40
  leaf_position_y
  min_dist_sector_1  ; distance towards central crown patch which divide tree crown into different sector
  max_dist_sector_1
  min_dist_sector_2
  max_dist_sector_2
  min_dist_sector_3
  max_dist_sector_3
  min_dist_sector_4
  max_dist_sector_4
  min_dist_sector_5
  max_dist_sector_5
  min_dist_sector_6
  max_dist_sector_6
  min_dist_sector_7
  max_dist_sector_7
  min_dist_sector_8
  max_dist_sector_8
  min_dist_sector_9
  max_dist_sector_9
  min_dist_sector_10
  max_dist_sector_10
  min_dist_sector_11
  max_dist_sector_11
  min_dist_sector_12
  max_dist_sector_12
  min_dist_sector_13
  max_dist_sector_13
  emigration_quotient  ; quotient determining emigration rates of insects
  best_leaf_quotient  ; quotient determining the size of the agentset suitable for oviposition
  mortality_defense  ; factor determining larval mortality
  defense_factor  ; factor determining increasing larval mortality due to local defense reactions
  larval_temp1  ; parameter determining larval development time in relation to leaf temperature
  larval_temp2
  larval_vigor1  ; parameter determining larval development time in relation to plant vigor
  larval_nut1  ; parameter determining larval development time in relation to nutritional value
  larval_vigor2
  larval_vigor3
  min_nutritional_value  ; parameter determining nutritional threshold where nutritional value has an effect
  max_mines_defense  ; maximum number of leaf mines before oviposition occurs
  nut_value_mean  ; mean value of nutritional value distribution
  nut_value_variation  ; variation of nutritional value distribution
  wat_pot_correcting_factor  ; normalization factor for nutritional value in dependence of leaf water potential
  max_distance  ; maximum distance to crown
  immigration_fraction  ; accounts for rescue effect
  leaf_miner_history
  leaf_miner_history1
]

; leaf miners, leaves, fruits, and brachnes are all breeds of agents
; larvae of insects are not implemented as individual agents, see procedures oviposition and larval-development
breed [ leaves leaf ]  ; leaves plural, so we use leaf as the singular
breed [ fruits fruit ]
breed [ branches branch ]
breed [ leaf_miners leaf_miner ]

leaves-own [
  age  ; age of leaves in years
  max_carboxylation  ; leaves have a maximum carboxylation rate of the enzyme Rubisco
  phot_limit_rad  ; photosynthesis limited by incoming radiation
  phot_limit_CO2  ; photosynthesis limited by atmospheric CO2
  phot_limit_wat_pot  ; photosynthesis limited by soil water
  phot_limit_wat_pot_damage  ; photosynthesis of leaves limited by soil water which has been damaged before
  stomatal_con  ; stomatal conductance
  stomatal_con_damage  ; stomatal conductance of leaves which has been damaged before
  wat_use_efficiency  ; water use efficiency determined by net assimilation and stomatal conductance
  wat_use_efficiency_damage  ; water use efficiency of leaves which has been damaged before
  net_assimilation  ; net assimilation as measure of photosynthesis
  net_assimilation_with_damage  ; net assimilation which has been damaged before
  leaf_water_potential_soil  ; leaf water potential limited by soil moisture
  leaf_water_potential_soil_damage  ; leaf water potential of leaves which has been damaged before limited by soil moisture
  leaf_water_potential_temp  ; leaf water potential limited by temperature
  leaf_water_potential_temp_damage  ; leaf water potential of leaves which has been damaged before limited by temperature
  leaf_water_potential_damage  ; updeated leaf water potential of leaves which has been damaged before
  leaf_water_potential  ; updated leaf water potential
  leaf_area  ; area per leaf
  leaf_temperature  ; temperature on leaf surface
  C_assim_per_leaf  ; carbon assimilation per leaf
  new_biomass_per_leaf  ; new biomass formed by each leaf
  closest_miner  ; closest leaf miner to each leaf
  p_density  ; leaf miner density per leaf
  p_density_neighbors  ; leaf miner density per group of leaves
  n_oviposition  ; number of eggs (or oviposition events) per leaf
  visitation_status  ; determines if leaf has been visited by leaf miners or not
  oviposition_status  ; boolean value which determines if eggs were laid on a leaf or not
  oviposition_counter  ; determines the number of ovipostion events independently of n_oviposition
  larval_development_time  ; determines time which larvae need to complete their development from egg to adult miner
  n_unmature_mines  ; number of developing mines per leaf
  n_developing_mines  ; alternative couner for number of developing mines per leaf
  n_mature_mines  ; number of mature mines per leaf from which adult leaf miners will be hatched
  n_empty_mines  ; number of empty mines per leaf --> mines from which adult miners were hatched
  mine_area  ; average area of one leaf mine
  mined_area_per_leaf  ; total area of leaf mines per leaf
  unmined_area_per_leaf  ; total area of unmined area per leaf
  mining_damage  ; not implemented
  photosynthesis_decrease  ; not implemented
  plant_vigor  ; plant vigor of different crown sectors
  plant_vigor_oviposition_threshold  ; threshold for plant vigor which must be overcome for oviposition to occur
  defense_oviposition_threshold  ; threshold for defense status of the plant which must be overcome for oviposition to occur
  nutritional_value_oviposition_threshold  ; threshold for nutritional value of the plant which must be overcome for oviposition to occur
  oviposition_probability  ; set oviposition probability depending on leaf attributes
  mortality_threshold  ; this threshod determines if leaf miners die or not
  sector  ; determines crown sector
  defense_status  ; boolean value which determines if leaf has undergone defense reaction or not
  nutritional_value  ; nutritional value of each leaf
]

fruits-own [
  age
  plant_vigor  ; plant vigor of different crown sectors
  plant_vigor_oviposition_threshold  ; threshold for plant vigor which must be overcome for oviposition to occur
  defense_oviposition_threshold  ; threshold for defense status of the plant which must be overcome for oviposition to occur
  nutritional_value_oviposition_threshold  ; threshold for nutritional value of the plant which must be overcome for oviposition to occur
  oviposition_probability  ; set oviposition probability depending on leaf attributes
  mortality_threshold  ; this threshod determines if leaf miners die or not
  sector  ; determines crown sector
  defense_status  ; boolean value which determines if leaf has undergone defense reaction or not
  nutritional_value  ; nutritional value of each leaf
]

branches-own[
  age
  plant_vigor  ; plant vigor of different crown sectors
  plant_vigor_oviposition_threshold  ; threshold for plant vigor which must be overcome for oviposition to occur
  defense_oviposition_threshold  ; threshold for defense status of the plant which must be overcome for oviposition to occur
  nutritional_value_oviposition_threshold  ; threshold for nutritional value of the plant which must be overcome for oviposition to occur
  oviposition_probability  ; set oviposition probability depending on leaf attributes
  mortality_threshold  ; this threshod determines if leaf miners die or not
  sector  ; determines crown sector
  defense_status  ; boolean value which determines if leaf has undergone defense reaction or not
  nutritional_value  ; nutritional value of each leaf
]

leaf_miners-own [
  age
  closest_leaf  ; closest leaf to each leaf miner
  best_leaf  ; leaf with highest plant vigor
  n_of_best_leaves
  density  ; leaf miner density per leaf
  visitation_status ; determines if a leaf has been visited by leaf miners or not
  p_density  ; leaf miner density per leaf
  n_oviposition  ; number of oviposition events per leaf
  previous_position  ; position of leaf miners is recorded per time step
  best_position  ; position of leaf with highest plant vigor
  n_eggs  ; initial egg number per leaf miner
  life_expectancy  ; life expectancy of leaf miners in years
  mortality  ; fraction of leaf miners dying per tick
  memory_plant_vigor  ; list of plant vigor values memorised by each leaf miner
  memory_nutritional_value  ; list of nutritional values memorised by each leaf miner
  plant_vigor  ; plant vigor of different crown sectors
  plant_vigor_oviposition_threshold  ; threshold for plant vigor which must be overcome for oviposition to occur
  defense_oviposition_threshold  ; threshold for defense status of the plant which must be overcome for oviposition to occur
  nutritional_value_oviposition_threshold  ; threshold for nutritional value of the plant which must be overcome for oviposition to occur
  oviposition_probability  ; set oviposition probability depending on leaf attributes
  mortality_threshold  ; this threshod determines if leaf miners die or not
  sector  ; determines crown sector
  defense_status  ; boolean value which determines if leaf has undergone defense reaction or not
  nutritional_value  ; nutritional value of each leaf
  n_unmature_mines  ; number of developing mines per leaf
  n_developing_mines  ; alternative couner for number of developing mines per leaf
  n_mature_mines  ; number of mature mines per leaf from which adult leaf miners will be hatched
  n_empty_mines  ; number of empty mines per leaf --> mines from which adult miners were hatched
  mine_area  ; average area of one leaf mine
  mined_area_per_leaf  ; total area of leaf mines per leaf
  unmined_area_per_leaf  ; total area of unmined area per leaf
  leaf_area  ; area of each leaf
]

patches-own [
  received_PARI  ; recieved photosynthetically active radiation
  soil_water_content
  soil_water_potential
  closest_turtle  ; closest turtle for each patch
  exposure  ; exposure of patches increases with distance to central patch from which leaves grow
  plant_vigor_patches  ; plant vigor is a leaf variable but it can be assessed from patches as well
  nutritional_value_patches  ; nutritional value is leaf variable but it can be assessed from patches as well
  closest_leaf_virtual
  virtual_ecologist
  virtual_count
]

; initialize the model
to setup
  clear-all
  setup-patches
  setup-leaf_miners
  setup-leaves
  reset-ticks
end

to go
  update-environment
  leaf-temperature
  shading-effects
  CO2
  leaf-water-potential
  net-assimilation
  stomatal-conductance
  growth-increment
  plant-vigor
  aging
  plotting
  random-flight
  directed-flight
  assess-density
  move-through-crown
  miners-learning
  update-learning
  oviposition
  larval-development
  adult-emergence
  defense-reaction
  nutritional-value
  miners-die
  over-winter
  mining-damage
  exporting
  virtual-ecologist
  ifelse n_year < 31  ; built in option to insert a stop condition
    [tick]
    [stop]
end

; certain patches are set up to be the main stem
to setup-patches
  ask patches[if pxcor < 1 and pxcor > -1 and pycor < -7 [ set pcolor brown ]]
  set leaf_miner_history []                                                     ; this rectangle determines the main stem
  set leaf_miner_history1 []
end

; create initial leaf miners, population size of around 200 individuals
to setup-leaf_miners
  create-leaf_miners Initial_leaf_miners
  [
    setxy random-xcor -16
    set color brown
    set size 0.3
    set age 0
  ]
end

; leaves are designed as superindividuals appearing in a sphere in the upper two thirds of the 3D world
to setup-leaves
  create-leaves Initial_leaves
  [
    setxy random-normal 0 2 random-normal -7 2
    set color green
    set size 2
    set shape "apple leaf"  ; nice shape
    set age 0
    set leaf_area random-normal L_area Variation_L_area  ; leaf area is set around a mean with standard variation
    set new_biomass_per_leaf 0
    set max_carboxylation Max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
    set mining_damage 1  ; mining damage is initially set to 1 which accounts for no mining damage
    facexy 0 -7  ; determines orientation of leaves
    rt 180  ; determines orientation of leaves
  ]

  ask leaves [if distance (patch 0 -7) < 6 [ set crown_status 1 ]]  ; in this shpere the crown_status is 1 --> part of the crown
  ask leaves [if xcor < 1 and xcor > -1 and ycor < -7 [ set crown_status 2 ]]  ; in this rectangle the crown status is 2 --> part of
                                                                                                          ; the main stem
end

; set temperature, radiation as global variables
to update-environment
; temperature as linear increase across seasons, procedure taken from the hedgehog model of the module "ecosystem simulation modelling" (M. FES Uni Göttingen)
; in addition a certain variation is introduced per tick
  set y 104  ; year(y): number of weeks in a year
  set hy 52  ; half year(hy): number of weeks in half a year

  set week_year (ticks mod y) / 2  ; getting the week of the year, by considering the remainder of the division for 52

  set n_year (ticks / y) ; in a year there are 52 weeks --> 104 half-weeks

  set temp_variation 1

  if ticks mod y < hy
  [  ; first part of the year temperature is increasing
     ; this is a linear equation, between the min-temp and the max-temp, with the increase proportial
     ; to the moment of the year
    set ambient_T min_temp + (ticks mod y  / hy) * max_temp + random-normal 0 temp_variation  ; temperature as linear
                                                                                              ; increase with standard
                                                                                              ; variation
  ]
  if ticks mod y > hy
  [  ; second part of the year temperature is decreasing
    set ambient_T max_temp - ( (ticks mod y - hy)  / hy ) * (max_temp - min_temp) + random-normal 0 temp_variation
  ]

; also irradiance [µmol m^-2 s^-1] as linear increase across seasons including variation, approximate range taken from module ecosystem atmosphere processes (M. FES, Uni Göttingen)
  set y 104  ; year(y): number of weeks in a year
  set hy 52  ; half year(hy): number of weeks in half a year

  set week_year (ticks mod y) / 2 ; getting the week of the year, by considering the remainder of the division for 52

  set n_year ticks / y ; in a year there are 52 weeks

  set min_PARI minPARi

  set max_PARI maxPARi

  set irr_variation 0.2

  set irr_min_threshold 300

  set irr_min_threshold_var 30

  if ticks mod y < hy
  [  ; first part of the year temperature is increasing
     ; this is a linear equation, between the min-temp and the max-temp, with the increase proportial to the moment of the year
    set new_PARI min_PARI + (ticks mod y  / hy) * (max_PARi - min_PARi) * random-normal 1 irr_variation
  ]
  if ticks mod y > hy
  [  ; second part of the year temperature is decreasing
    set new_PARI (max_PARI * random-normal 1 0.1 - ( (ticks mod y - hy)  / hy ) * (max_PARi - min_PARi))
  ]
  if (ticks mod y > hy) and (new_PARI < 400) [set new_PARI random-normal irr_min_threshold irr_min_threshold_var]
end

;###############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
; LEAF PROCEDURES
  ; leaf temperature gradually increases with distance from tree center --> personal communication with Dr. Sylvain Pincebourde (Universite de Tours)
  ; a calibration resulted in parameters 2 and 4 for realistic values of gradually decreasing leaf temperature
to leaf-temperature
  set leaf_temp_factor_T 2
  set leaf_temp_factor_dist 4

  ask leaves [set leaf_temperature ambient_T * leaf_temp_factor_T - (distance (patch 0 -7) * leaf_temp_factor_dist)]
end

; less radiation is received inside tree canopy depending on distance to tree center
to shading-effects
  ask patches [if distance patch 0 -7 != 0
    [set received_PARI new_PARI - new_PARI * (1 / (distance (patch 0 -7)))]  ; central line of code because this is an effect which cannot just be
                                                                               ; calculated with regression
  ]
end

; seasonal CO2 concentration [µmol mol^-1] shifts in between 400-415 --> estimate from IPCC report 2019
to CO2
  set min_CO2 minCO2
  set max_CO2 maxCO2
  ifelse week_year < hy
  [  ; first part of the year temperature is increasing
     ; this is a linear equation, between the min-temp and the max-temp, with the increase proportial to the moment of the year
    set CO2_conc min_CO2 + (week_year  / hy) * (max_CO2 - min_CO2)
  ]
  [  ; second part of the year temperature is decreasing
    set CO2_conc max_CO2 - ( (week_year - hy)  / hy ) * (max_CO2 - min_CO2)
  ]
end

; calculate leaf water potential from seasonal soil water content and leaf temperature
; Parameter estimation for net assimilation restricted by received PARi (Pincebourde et al. (2006))
; Parameter estimation for net assimilation restricted by CO2 concentration, and leaf water potential by Bonan (2019)
to leaf-water-potential
  ; soil water potential in hectopascal calculated from examplary water retention curve --> soil moisture development from soil moisture monitor of Helmholtz
  ; Centre (https://www.ufz.de/index.php?en=37937), water retention curve for a sandy silt soil
  ; set soil water content under non-extreme soil water conditions
  set month_year (week_year / 4)
  ask patches [set soil_water_content (0.0010000613 * month_year ^ 3 - 0.0122641332 * month_year ^ 2 + 0.0008892295 * month_year + 0.4150609283)]
  ; the extreme-drought? switch makes it possible to include an extremely dry year every three years with soil water content close to 0 in the summer months
  ask patches [set soil_water_potential ((-48.067083 * soil_water_content ^ 3 + 29.957886 * soil_water_content ^ 2 - 6.925378 * soil_water_content + 1.149912))]

  ; leaf water potential is determined by soil water potential and leaf temperature --> maximum value of both limitations --> leaf water potential is given here as a positive value
  ask leaves [set leaf_water_potential_soil (2.62394 * soil_water_potential - 0.16299)]  ; leaf water potential limited by soil water potential by Ennajeh et al.
                                                                                         ; (2008) --> corrected for water use efficiency
  ; two different types of leaf water potentials determined from soil water potential are considered --> with mining damage and without mining damage
  ask leaves [if
    (wat_use_efficiency_damage != 0)
      [set leaf_water_potential_soil_damage (2.62394 * soil_water_potential - 0.16299) * (wat_use_efficiency / wat_use_efficiency_damage)]  ; leaf water potential limited by soil water potential by Ennajeh et al.
    ]                                                                                                                                ; (2008) --> corrected for water use efficiency of damaged
                                                                                                                                     ; leaves
  ask leaves [set leaf_water_potential_temp ((-0.018 * leaf_temperature - 0.217) * -1)]  ; leaf water potential limited by temperature by Williams and Baeza

  ; two different types of leaf water potentials determined from leaf temperature are considered --> with mining damage and without mining damage
  ask leaves [if
    (wat_use_efficiency_damage != 0)
      [set leaf_water_potential_temp_damage ((-0.018 * leaf_temperature - 0.217) * -1) * (wat_use_efficiency / wat_use_efficiency_damage)]  ; leaf water potential limited by temperature by Williams and Baeza
    ]                                                                                                                                ; (2007) --> corrected for water use efficiency

  ask leaves [set leaf_water_potential max (list leaf_water_potential_soil leaf_water_potential_temp)]  ; leaf water potential of undamaged leaves as maximum of the two limitations
  ask leaves [set leaf_water_potential_damage max (list leaf_water_potential_soil_damage leaf_water_potential_temp_damage)]  ; leaf water potential of damaged leaves as maximum of the two limitations
  ; leaf water potential around -0.5 to -1.5 MPascal --> realistic values but for even more accurate leaf water potential a real water retention curve is needed
end

; net assimilation [µmol m^-2 s^-1] is either limited by photosynthetically active radiation, CO2 concentration --> minimum value of these 3
to net-assimilation
  ask leaves [set phot_limit_rad ((10.923923437 * (1 - exp(-0.002786338 * received_PARI)) ^ 0.708200928 ) - 1.751814937)]  ; limited by photosynthetically active radiation
  ask leaves [set phot_limit_wat_pot ((-1.1090866 * leaf_water_potential ^ 2 + 0.9083979 * leaf_water_potential + 4.1937435) * 2.3)]  ; limited by leaf water potential of undamaged leaves
  ask leaves [set phot_limit_wat_pot_damage ((-1.1090866 * leaf_water_potential_damage ^ 2 + 0.9083979 * leaf_water_potential_damage + 4.1937435) * 2.3)]  ; limited by leaf water potential of damaged leaves
  ask leaves [set phot_limit_CO2 ((-0.00001017093 * CO2_conc ^ 2 + 0.01953602 * CO2_conc - 1.081342) * 1.3)]  ; limited by CO2 concentration
  ask leaves [set net_assimilation min (list phot_limit_rad phot_limit_wat_pot)]  ; phot_limit_CO2 taken out of equation but originally included

  ask leaves [set net_assimilation net_assimilation / 2]  ; account for missing net assimilation at night by dividing net assimilation by 2 --> would be more realistic to account for seasonal
                                                          ; daylength

  ; determine seasonality for leaves
  set start_growing_season start_growth
  set end_growing_season end_growth
  ask leaves [if week_year > end_growing_season  ; make leaves photosynthetically inactive during winter
    [set net_assimilation 0
     set net_assimilation_with_damage 0]
  ]
  ask leaves [if week_year < start_growing_season  ; make leaves photosynthetically inactive during winter
    [set net_assimilation 0
     set net_assimilation_with_damage 0]
  ]
end

; stomatal conductance in linear dependence of net assimilation, paramter estimation Bonan (2019)
; this procedure is separated for leaves with and without mining damage
to stomatal-conductance
  ; stomatal conductance and water use efficiency for undamaged leaves
  ask leaves [set stomatal_con (3.338833e-11 * received_PARI ^ 3 - 2.205490e-07 * received_PARI ^ 2 + 4.517725e-04 * received_PARI + 5.305339e-02)]  ; stomatal conductance calculated from
                                                                                                                                                     ; photosynthetically active radiation
                                                                                                                                                     ; of undamaged leaves
  ask leaves [set wat_use_efficiency (net_assimilation / (stomatal_con * 10))]  ; water use efficiency calculated from net assimilation and stomatal conductance (both corrected for µmol/m^-2/sec^-1

  ; stomatal conductance and water use efficiency for damaged leaves
  ask leaves [if
    (mined_area_per_leaf != 0)
      [set stomatal_con_damage (1.096866e-10 * received_PARI ^ 3 - 3.653341e-07 * received_PARI ^ 2 + 3.139274e-04 * received_PARI + 5.501573e-02) ]  ; stomatal conductance of damaged leaves
    ]
  ask leaves [if
    (stomatal_con_damage != 0)
      [set wat_use_efficiency_damage (net_assimilation_with_damage / (stomatal_con_damage * 10))]  ; water use efficiency of damaged leaves
    ]
end

; net assimilation of leaves is used for growing new leaves --> also for branch elongation, stem thickening, and belowground biomass but this is not implemented in this model
to growth-increment
  ; determine biomass increment from total carbon assimilation in mg per tick --> per half-week, reference Li et al. (2016)

  set C_assim_factor (3.333 / 1000)

  ask leaves [set C_assim_per_leaf (net_assimilation * C_assim_factor) * 3.5]  ; model version without infestation --> control treatment
  ask leaves [if                                                                 ; model versions with infestations
    (Damage?)
      [set C_assim_per_leaf (net_assimilation_with_damage * C_assim_factor) * 3.5]
  ]
  ask leaves [set new_biomass_per_leaf new_biomass_per_leaf + C_assim_per_leaf]  ; update biomass increment

  ; leaves produce new leaves --> but only with a 10% probability, rest of the energy is used to grow branches and root system, reference Lo Blanco and Farina (2022)
  ; this ratio is age-dependent --> energy used to grow new leaves decreases with age

  set leaf_gen_factor_25 83  ; leaf_gen_factors and branch_gen_factors (age dependent) determine a stochastic threshold for either growing leaves or other
  set branch_gen_factor_25 13  ; parts of the tree (see below)
  set leaf_gen_factor_30 88
  set branch_gen_factor_30 8
  set leaf_gen_factor_35 90
  set branch_gen_factor_35 6
  set leaf_gen_factor_40 91
  set branch_gen_factor_40 6
  set leaf_position_25 20  ; leaf positioning factor (age dependent) determines position of newly grown leaves
  set leaf_position_30 20
  set leaf_position_35 85
  set leaf_position_40 85
  set leaf_position_y 3  ; y coordinate position factor

  ask leaves
    [if (n_year < 25) and (new_biomass_per_leaf > 1) and (random 100  > leaf_gen_factor_25)  ; biomass per leaf is assessed for new leaves to grow, each leaf produces a new leaf once it has
                                                      ; produced its own biomass
                                                      ; only 10-15% of the leaves energy is used to grow new leaves --> the rest is used to produce other parts of the tree
                                                      ; --> stem, branches, roots (from Loblanco and Farina (2014))
                                                      ; in this growth phase leaves number is supposed to increase exponentially
       [hatch 1
          [
          setxy (xcor + (n_year * random-normal 0 1) / leaf_position_25)  (ycor + (n_year * random leaf_position_y) / leaf_position_25)
                                                                                                                                        ; newly formed leaves
                                                                                                                                        ; obtain a different
                                                                                                                                        ; position than first
                                                                                                                                        ; leaves depending on
                                                                                                                                        ; tree age --> year number
          set color green
          set size 2
          set age 0
          set leaf_area random-normal L_area Variation_L_area
          set new_biomass_per_leaf 0
          set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
          set mining_damage 1  ; mining damage is initially set to 1 which accounts for no minng damage
          set crown_status 1
          set n_oviposition 0
          set n_mature_mines 0
          set n_developing_mines 0
          set n_empty_mines 0
          set n_developing_mines 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]  ; energy necessary for one leaf
    ]

  ; the rest of the energy produced by net assimilation is used for growth of all other plant organs --> represented here as branches
  ask leaves
    [if (n_year < 25) and (new_biomass_per_leaf > 1) and (random 100 > branch_gen_factor_25)
       [hatch-branches 1
          [
          set color green
          set size 0
          set age 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]
      ]

  ; repeat procedure for age dependency, leaves for age 25-30 years
  ask leaves
    [if (n_year > 25) and (n_year < 30) and (new_biomass_per_leaf > 1) and (random 100  > leaf_gen_factor_30)  ; from now on leaf number goes towards saturation --> higher energy demand for new
                                                                        ; leaves to grow
       [hatch 1
          [
          setxy (xcor + (n_year * random-normal 0 1) / leaf_position_30)  (ycor + (n_year * random leaf_position_y) / leaf_position_30)  ; newly formed leaves
                                                                                                                                        ; obtain a different
                                                                                                                                        ; position than first
                                                                                                                                        ; leaves depending on
                                                                                                                                        ; tree age --> year number
          set color green
          set size 2
          set age 0
          set leaf_area random-normal L_area Variation_L_area
          set new_biomass_per_leaf 0
          set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
          set mining_damage 1  ; mining damage is initially set to 1 which accounts for no minng damage
          set crown_status 1
          set n_oviposition 0
          set n_mature_mines 0
          set n_developing_mines 0
          set n_empty_mines 0
          set n_developing_mines 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]  ; energy necessary for one leaf, new branches, and fruits?
    ]

  ; repeat procedure for age dependency, branches for age 25-30 years
  ask leaves
    [if (n_year > 25) and (n_year < 30) and (new_biomass_per_leaf > 1) and (random 100 > branch_gen_factor_30)
       [hatch-branches 1
          [
          set color green
          set size 0
          set age 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]
      ]

  ; repeat procedure for age dependency, leaves for age 30-35 years
  ask leaves
    [if (n_year > 30) and (n_year < 35) and (new_biomass_per_leaf > 1) and (random 100 > leaf_gen_factor_35)  ; from now on leaf number goes towards saturation, higher energy demand for new leaves
                                                                        ; to grow
       [hatch 1
          [
          setxy (xcor + (n_year * random-normal 0 1) / leaf_position_35)  (ycor + (n_year * random leaf_position_y) / leaf_position_35)  ; newly formed leaves
                                                                                                                                        ; obtain a different
                                                                                                                                        ; position than first
                                                                                                                                        ; leaves depending on
                                                                                                                                        ; tree age --> year number
          set color green
          set size 2
          set age 0
          set leaf_area random-normal L_area Variation_L_area
          set new_biomass_per_leaf 0
          set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
          set mining_damage 1  ; mining damage is initially set to 1 which accounts for no minng damage
          set crown_status 1
          set n_oviposition 0
          set n_mature_mines 0
          set n_developing_mines 0
          set n_empty_mines 0
          set n_developing_mines 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]  ; energy necessary for one leaf, new branches, and fruits?
    ]

  ; repeat procedure for age dependency, branches for age 30-35 years
  ask leaves
    [if (n_year > 30) and (n_year < 35) and (new_biomass_per_leaf > 1) and (random 100 > branch_gen_factor_35)
       [hatch-branches 1
          [
          set color green
          set size 0
          set age 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]
      ]

   ; repeat procedure for age dependency, leaves for age 35-40 years
   ask leaves
    [if (n_year > 35) and (n_year < 40) and (new_biomass_per_leaf > 1) and (random 100 > leaf_gen_factor_40)  ; from now on leaf number goes towards saturation, higher energy demand for new leaves
                                                                        ; to grow
       [hatch 1
          [
          setxy (xcor + (n_year * random-normal 0 1) / leaf_position_40)  (ycor + (n_year * random leaf_position_y) / leaf_position_40)  ; newly formed leaves
                                                                                                                                        ; obtain a different
                                                                                                                                        ; position than first
                                                                                                                                        ; leaves depending on
                                                                                                                                        ; tree age --> year number
          set color green
          set size 2
          set age 0
          set leaf_area random-normal L_area Variation_L_area
          set new_biomass_per_leaf 0
          set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
          set mining_damage 1  ; mining damage is initially set to 1 which accounts for no minng damage
          set crown_status 1
          set n_oviposition 0
          set n_mature_mines 0
          set n_developing_mines 0
          set n_empty_mines 0
          set n_developing_mines 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]  ; energy necessary for one leaf, new branches, and fruits?
    ]

  ; repeat procedure for age dependency, branches for age 35-40 years
  ask leaves
    [if (n_year > 35) and (n_year < 40) and (new_biomass_per_leaf > 1) and (random 100 > branch_gen_factor_40)
       [hatch-branches 1
          [
          set color green
          set size 0
          set age 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]
      ]

  ; repeat procedure for age dependency, leaves for age above 40 years
  ask leaves
    [if (n_year > 40) and (new_biomass_per_leaf > 1) and (random 100 > 92)  ; currently the leaf number approaches a saturation curve after about 50 years --> should not be
                                                       ; extrapolated beyond this point --> leaf number increases again
       [hatch 1
          [
          setxy (xcor + (n_year * random-normal 0 1) / leaf_position_40)  (ycor + (n_year * random leaf_position_y) / leaf_position_40)  ; newly formed leaves
                                                                                                                                        ; obtain a different
                                                                                                                                        ; position than first
                                                                                                                                        ; leaves depending on
                                                                                                                                        ; tree age --> year number
          set color green
          set size 2
          set age 0
          set leaf_area random-normal L_area Variation_L_area
          set new_biomass_per_leaf 0
          set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
          set mining_damage 1  ; mining damage is initially set to 1 which accounts for no minng damage
          set crown_status 1
          set n_oviposition 0
          set n_mature_mines 0
          set n_developing_mines 0
          set n_empty_mines 0
          set n_developing_mines 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]  ; energy necessary for one leaf, new branches, and fruits?
    ]

  ; repeat procedure for age dependency, branches for age above 40 years
   ask leaves
    [if (n_year > 40) and (new_biomass_per_leaf > 1) and (random 100 > 5)
       [hatch-branches 1
          [
          set color green
          set size 0
          set age 0
          ]
        set new_biomass_per_leaf new_biomass_per_leaf - 1]
      ]

  ; fruits are produced from leaves once a year with a prbability threshold which makes two superindividual leaves produce one fruit --> 40 individual leaves produce one fruit
  ; reference University of Illinois apple facts (https://web.extension.illinois.edu/apples/facts.cfm)
  set fruit_age_start fruit_start
  set fruit_age_end fruit_end  ; time period in early summer where apples can be produced
  ; fruit production is switched on automatically if tree is younger than 30 years

  ; fruits are produced only once during productive period
  set fruit_limit week_year mod 6
  ask leaves
    [if (week_year > fruit_age_start) and (week_year < fruit_age_end) and (week_year mod 6 = 0) and (random-float 1 > 0.5)  ; set a productive age, correct again if necessary, make it dependent of year
       [hatch-fruits 1  ; for each superindividual leaf one fruit is generated
          [
          set shape "circle"
          set color red
          set size 0.75
          ]
        ]
  ]
  ask leaves [set max_productive_age "off"]
end

; processes which include aging for all turtle breeds
to aging
  ; age of leaves and leaf miners is determined in years
  ask leaves [set age age + (1 / y)]
  ask leaf_miners [if
    (week_year > first_generation_emergence)
      [set age age + (1 / y)]
    ]

  ; implement seasonality by hiding leaves at the end of the year and show again at spring next year
  ask leaves [ifelse
    (week_year > end_growing_season) [hide-turtle]
    [show-turtle]
  ]
  ask leaves [ifelse
    (week_year < start_growing_season) [hide-turtle]
      [show-turtle]
  ]

  ; in the beginning of the growing season leaves from last year die and hatch a new leaf
  ask leaves [if
    (week_year = start_growing_season)
      [ hatch 1 [
        set color green
        set size 2
        set age 0
        set leaf_area random-normal L_area Variation_L_area
        set new_biomass_per_leaf 0
        set max_carboxylation max_carboxy  ; maximum Rubisco carboxylation rate [µmol m^-2 s^-1] is intially set to 12
        set mining_damage 1
        set crown_status 1
        set n_oviposition 0
        set n_mature_mines 0
        set n_developing_mines 0
        set n_empty_mines 0
        set n_developing_mines 0
        set nutritional_value random-normal 1 0.2
        set oviposition_probability plant_vigor
        set defense_oviposition_threshold "off"
        set n_oviposition 0
          ] ]
      ]
  ask leaves [if
    (week_year = start_growing_season) and (age > start_growing_season / y)
      [die]
    ]

  ; fruits are harvested in autumn
  ask fruits [if (week_year = end_growing_season) [die]]
end

; plant vigor is implemented as number of leaves per sector divided by total leaves
to plant-vigor
  if count leaves != 0 [set inv_leaf_count (1 / count leaves)]  ; set local count leaves variable to speed up simulations

  set min_dist_sector_1 3
  set max_dist_sector_1 3
  set min_dist_sector_2 3
  set max_dist_sector_2 4
  set min_dist_sector_3 4
  set max_dist_sector_3 5
  set min_dist_sector_4 5
  set max_dist_sector_4 6
  set min_dist_sector_5 6
  set max_dist_sector_5 7
  set min_dist_sector_6 7
  set max_dist_sector_6 8
  set min_dist_sector_7 8
  set max_dist_sector_7 9
  set min_dist_sector_8 9
  set max_dist_sector_8 10
  set min_dist_sector_9 10
  set max_dist_sector_9 11
  set min_dist_sector_10 11
  set max_dist_sector_10 12
  set min_dist_sector_11 12
  set max_dist_sector_11 13
  set min_dist_sector_12 13

  ; crown is separated in different sectors determined by distance to central patch --> leaf count per sector / total leaf count determines plant vigor
  ask leaves with [distance (patch 0 -7) < min_dist_sector_1] [set plant_vigor (count leaves with [distance (patch 0 -7) < min_dist_sector_1] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_2 and distance (patch 0 -7) < max_dist_sector_2] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_2 and distance (patch 0 -7) < max_dist_sector_2] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_3 and distance (patch 0 -7) < max_dist_sector_3] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_3 and distance (patch 0 -7) < max_dist_sector_3] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_4 and distance (patch 0 -7) < max_dist_sector_4] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_4 and distance (patch 0 -7) < max_dist_sector_4] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_5 and distance (patch 0 -7) < max_dist_sector_5] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_5 and distance (patch 0 -7) < max_dist_sector_5] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_6 and distance (patch 0 -7) < max_dist_sector_6] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_6 and distance (patch 0 -7) < max_dist_sector_6] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_7 and distance (patch 0 -7) < max_dist_sector_7] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_7 and distance (patch 0 -7) < max_dist_sector_7] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_8 and distance (patch 0 -7) < max_dist_sector_8] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_8 and distance (patch 0 -7) < max_dist_sector_8] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_9 and distance (patch 0 -7) < max_dist_sector_9] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_9 and distance (patch 0 -7) < max_dist_sector_9] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_10 and distance (patch 0 -7) < max_dist_sector_10] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_10 and distance (patch 0 -7) < max_dist_sector_10] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_11 and distance (patch 0 -7) < max_dist_sector_11] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_11 and distance (patch 0 -7) < max_dist_sector_11] * inv_leaf_count)]
  ask leaves with [distance (patch 0 -7) > min_dist_sector_12] [set plant_vigor (count leaves with [distance (patch 0 -7) > min_dist_sector_12] * inv_leaf_count)]
end

;###############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
; INSECT PROCEDURES
; in the beginning of the growing season leaf miners emerge from leaves on the ground and start flying up
to random-flight
  ask leaf_miners
    [if (week_year > start_growing_season) and (week_year < leaf_miner_start)  ; first generation of adult leaf miners emerge in the middle of april
      [facexy random xcor 33   ; random movement in upper direction
         fd 10  ; leaf miner needs minimum amount of time to fly to crown --> half a week
      ]
    ]

  ; certain number of insects is created constantly as immigration rate over the growing season
    if (week_year > start_growing_season) and (week_year < leaf_miner_start)
    [create-leaf_miners Initial_leaf_miners / 10
      [
        setxy random-xcor random-ycor
        set color brown
        set size 0.3
        set age 0
        set best_leaf min-n-of (count leaves / 2) leaves [plant_vigor]
        set best_leaf one-of best_leaf
        set n_eggs initial_eggs
        ]
    ]
end

; if leaf miners get close to any leaf they directly fly towards it
to directed-flight
  ask leaf_miners
    [set closest_leaf min-one-of leaves [distance myself]]  ; identify the closest leaf to every leaf miner
  ask leaf_miners [if
    (distance closest_leaf < 3) and (week_year > leaf_miner_start) and (week_year < end_growing_season)  ; leaf miners with small distance towards any leaf move towards this leaf
      [move-to closest_leaf]
  ]
end

; if too many leaf miners are at one leaf they continue moving
to assess-density
  ask leaf_miners [if
    (week_year > start_growing_season) and (week_year < end_growing_season)
      [set density count leaf_miners-here]  ;leaf miners evaluate if there are other leaf miners nearby and how many
    ]
  ask leaf_miners [if
    density > max_miner_density [move-to one-of leaves]
  ]

  ; certain fraction of insects dies as emigration rate over the growing season
  set emigration_quotient 10
  ask n-of (count leaf_miners / emigration_quotient) leaf_miners [if
    density > max_miner_density [die]
  ]
end

; leaf miners move from leaf to leaf to assess them
to move-through-crown
  ;ask leaf_miners [pen-down]

  ask leaf_miners
    [set closest_leaf min-one-of leaves [distance myself]]  ; identify the closest leaf to every leaf miner
  ask leaves
    [set closest_miner min-one-of leaf_miners [distance myself]]

  set best_leaf_quotient 2
  ask leaf_miners  ; identify an agentset with higher plant vigor --> one of those leaves is then chosen by leaf miners
    [set best_leaf max-n-of (count leaves / best_leaf_quotient) leaves [plant_vigor]
     set best_leaf one-of best_leaf]
;  ask leaf_miners [set best_leaf one-of leaves]
  ask leaf_miners [if
    (distance best_leaf > 0) and (week_year > leaf_miner_start) and (week_year < end_growing_season)  ; if best leaf is not at current position of leaf miners they move to it
      [move-to best_leaf
      set best_position xcor + ycor]
    ]
  ask leaf_miners [if
    ((xcor + ycor) - best_position = 0) and (week_year > leaf_miner_start) and (week_year < end_growing_season) and (distance closest_leaf = 0)  ; repeat command --> if leaf miners go back to a leaf
                                                                                                         ; which they have visited before they keep moving
      [rt random 360 fd 1]
    ]
  ask leaves [if
    (distance closest_miner = 0)
      [set visitation_status "visited"]  ; if leaf miners have been at a specific leaf already they keep this leaf in memory as "visited"
  ]
end

; leaf miners generate a memory with leaf attributes they have already visited --> plant vigor and nutritional value
; when leaf miners are born they start to generate a list of leaf attributes from the closest leaves which is updated in the following procedure
to miners-learning
  ; leaf attributes are accessed by patches so they become accessible by leaf miners
  ask patches [set closest_turtle min-one-of leaves [distance myself]]
  ask patches [set plant_vigor_patches [plant_vigor] of closest_turtle]
  ask patches [set exposure distance patch 0 -7]
;  ask patches [set defense_status [defense_status] of closest_turtle]
  ask patches [set nutritional_value_patches [nutritional_value] of closest_turtle]
  ; memory is generated only during flying period
  ask leaf_miners [if
    (age < too_old / y)
      [set memory_plant_vigor (list ([plant_vigor] of closest_turtle))]
    ]
  ask leaf_miners [if
    (age < too_old / y)
      [set memory_nutritional_value (list ([nutritional_value] of closest_turtle))]
    ]
end

to update-learning  ; memory list is updated and the threshold is adjusted as the mean of all values from the list
  ; firstly the leaf miners determine a threshold for oviposition in relation to leaf quality
  ask leaf_miners [set oviposition_probability [plant_vigor] of closest_turtle]  ; leaf miners investigate plant vigor
  ask leaf_miners [set nutritional_value [nutritional_value] of closest_turtle]  ; leaf miners investigate nutritional value
  ask leaf_miners [set plant_vigor_oviposition_threshold vigor_oviposition_threshold]
  ask leaf_miners [set memory_plant_vigor insert-item 1 memory_plant_vigor plant_vigor_patches
                   set plant_vigor_oviposition_threshold mean memory_plant_vigor]  ; leaf miners determine a threshold for plant vigor dependent on already visisted leaves
  ask leaf_miners [set memory_nutritional_value insert-item 1 memory_nutritional_value nutritional_value_patches
                   set nutritional_value_oviposition_threshold mean memory_nutritional_value]  ; leaf miners determine a threshold for nutritional value dependent on already visisted leaves
  ask leaf_miners [set defense_oviposition_threshold "off"]

  ask leaf_miners [if
   (No-learning?)
     [set plant_vigor_oviposition_threshold plant_vigor_threshold       ; controlled by switch No-learning?
      set nutritional_value_oviposition_threshold nutrition_threshold]  ; this line makes it possible to switch off host selection
    ]                                                                   ; --> miners pick any leaf they encounter
end

; oviposition is implemented by leaves --> if a list of conditions is met the number of eggs is determined by the presence of leaf miners at each leaf
to oviposition
  set initial_egg_number initial_eggs  ; provide leaf miners with a certain number of eggs per leaf miner
  ask leaf_miners [if
    (week_year = leaf_miner_start - 1)
      [set n_eggs 0.0008321892 * ambient_T ^ 4 - 0.0514873577 * ambient_T ^ 3 + 0.7244537352 * ambient_T ^ 2 + 2.8647527846 * ambient_T - 7.5311892638]
    ]
; two options for oviposition --> either only one egg is laid per tick --> p_density option
;                                                                      --> several eggs per tick --> p_density_neighbors option add number of eggs from nearest neighbors
; both options are not optimal --> p_density option allows for only one visit in half a week --> one tick, p_density_neighbors overestimates oviposition in current state of the model
; to determine the number of eggs the number of leaf miners at leaves which fulfill oviposition conditions are recorded --> p_density/neighbors
  ask leaves [set p_density count leaf_miners with [(distance myself = 0) and (oviposition_probability >= plant_vigor_oviposition_threshold) and (nutritional_value >= nutritional_value_oviposition_threshold)]]
  ask leaves [set p_density_neighbors p_density + sum [p_density] of leaves with [(distance myself = 0) and (oviposition_probability >= plant_vigor_oviposition_threshold)
    and (nutritional_value >= nutritional_value_oviposition_threshold)]]
  ; oviposition is only successful if there is no defense reaction, and if the number of eggs and mines is not too high
  ask leaves [if
   (n_mature_mines < max_mature_mines) and (defense_status = "off") and (n_oviposition < max_oviposition) and (n_empty_mines < max_empty_mines) and (mined_area_per_leaf < leaf_area)
      [set n_oviposition (n_oviposition + p_density)  ; + sum [p_density] of n-of 1 leaves)  ; use conditions that leaves need to fulfill for increase in oviposition to occur, alternatively use
       set oviposition_status "on"]                                                          ; random 3 for more variation to occur
    ]


  ask leaf_miners [if  ; decrease egg counter in case of successful oviposition, if there are no eggs left the leaf miner dies
    (distance closest_leaf = 0) and (oviposition_probability >= plant_vigor_oviposition_threshold) and (nutritional_value >= nutritional_value_oviposition_threshold)
    and (defense_status = "off") and ([n_mature_mines] of closest_leaf < max_oviposition) and ([n_empty_mines] of closest_leaf < max_empty_mines)
      [set n_eggs n_eggs - 1]
    ]
  ask leaf_miners [if
    (n_eggs = 0)
      [die]
    ]
  ask leaves [set mean_oviposition_per_leaf (sum [n_oviposition] of leaves / (count leaves * 20))]  ; for simplifications sake number of ovipositions is recorded per leaf
end

; larval development implemented mathematically per leaf --> larvae develop in mines and then emerge as adult insects but the larvae themselves are no separate
; agents
to larval-development
  ask leaves [if
    (n_oviposition > 0)
      [set oviposition_counter oviposition_counter + 1]  ; start an oviposition counter which records the ticks since oviposition
    ]

  set mortality_defense (3 / 100)
  set defense_factor 2

  ask leaves [if
    (defense_status = "off")
    [set larval_mortality (distance patch 0 mean [ycor] of leaves * mortality_defense)]  ; mortality of leaf miners is dependent of central patch --> the more exposed the leaf
    ]
  ask leaves [if
    (defense_status = "on")
      [set larval_mortality (distance patch 0 mean [ycor] of leaves * mortality_defense) * defense_factor]  ; mortality of leaf miners is dependent of central patch --> the more exposed the leaf, alternatively add dependence
    ]

  set larval_temp1 -0.2
  set larval_temp2 10
  set larval_nut1 1
  set larval_vigor1 0.7
  set larval_vigor2 4
  set larval_vigor3 8

  ask leaves [if nutritional_value != 0
    [set larval_development_time ((leaf_temperature * larval_temp1 + larval_temp2) * (larval_vigor1 / plant_vigor) / larval_vigor2) + larval_vigor3
                                                                                                                                ; set larval development time, make it dependent of leaf
                                                                                                                                ; temperature, nutritional value and plant vigor
                                                                                                                                ; from Geng and Jung (2018)
     set n_unmature_mines n_unmature_mines + (n_oviposition * (larval_nut1 - larval_mortality))  ; eggs develop into mines
     set n_oviposition 0]
    ]

  ; nutritional value has an impact on larval development time if it is below a certain threshold

  set min_nutritional_value 0.5

  ask leaves [if
    (nutritional_value < min_nutritional_value) and (nutritional_value != 0)
      [set larval_development_time ((leaf_temperature * larval_temp1 + larval_temp2) * (1 / nutritional_value) / larval_vigor2) + larval_vigor3]
    ]
  ask leaves [if
    (oviposition_counter > larval_development_time)
      [set n_mature_mines n_mature_mines + (n_unmature_mines * (1 - larval_mortality))  ; mines finish their development
       set n_developing_mines n_unmature_mines
       set n_unmature_mines 0]
    ]
  ask leaves [if
    (week_year = start_growing_season - 1)
      [set n_unmature_mines 0]
    ]
  ; if number of mature mines is higher than a certain threshold it does not increase any more
  ask leaves [if
    (n_mature_mines > max_mature_mines)
      [set n_mature_mines max_mature_mines]
    ]
  ; once the larvae have completed their development the oviposition counter starts again
  ask leaves [if
    (oviposition_counter > larval_development_time)
      [set oviposition_counter 0]
    ]
end

; adult leaf miners emerge from mature mines
to adult-emergence
  ask leaves [set mean_mature_mines_per_leaf (sum [n_mature_mines] of leaves / (count leaves * 20))]  ; determined per individual leaf (thus division by 20)
                                                                                                    ; not per superindividual
  ask leaves [if
    (week_year > start_growing_season) and (week_year < end_growing_season)
      [hatch-leaf_miners n_mature_mines  ; adult leaf miners emerge from mature mines per leaf
        [
        set color brown
        set size 0.3
        set age 0
        set best_leaf min-n-of (count leaves / 2) leaves [plant_vigor]
        set best_leaf one-of best_leaf
        set n_eggs 0.0008321892 * ambient_T ^ 4 - 0.0514873577 * ambient_T ^ 3 + 0.7244537352 * ambient_T ^ 2 + 2.8647527846 * ambient_T - 7.5311892638
        ]
      set n_empty_mines n_empty_mines + n_mature_mines  ; mature mines from which leaf miners were hatched are classified as empty mines
      set n_mature_mines 0
      ]
    ]
end

; infested leaves carry out a defense reaction --> in this state it is only a local reaction, alternative --> systemic reaction for whole plant
to defense-reaction
  set max_mines_defense 50  ; maximum number of mines before defense reaction
  ask leaves [ifelse
    (n_mature_mines > max_mines_defense)
      [set defense_status "on"]
      [set defense_status "off"]
    ]
end

to nutritional-value
  set nut_value_mean 1
  set nut_value_variation 0.2
  set wat_pot_correcting_factor 1.45
  ask leaves [set nutritional_value (random-normal nut_value_mean nut_value_variation  * (leaf_water_potential / wat_pot_correcting_factor))]  ; nutritional value dependent on water potential
end

; all processes resulting in leaf miner death
to miners-die
  ; if leaf miners have not found suitable leaf after half a week they die --> emigration due to wind
  set max_distance 20
  ask leaf_miners [if
    (week_year > first_generation_emergence) and (week_year < end_growing_season) and (distance patch 0 -7 > max_distance)
      [die]
  ]
  ; leaf miners die at the end of growing season
  ask leaf_miners [if
    (week_year = end_growing_season)
      [die]
  ]

  ; life expectancy of leaf miners is set to 7 days --> leaf miners die after they have reached it
  ask leaf_miners [set life_expectancy 2 / y]
  ask leaf_miners [if
    (age > life_expectancy) and (week_year > mature_age) and (week_year < end_growing_season)
    [die]
  ]

  ; mortality of leaf miners is dependent of central patch --> the more exposed the leaf
  ; the higher the mortality due to predation of parasitoids, check the mortality threshold again
  ask leaf_miners [set mortality (distance patch 0 -7 * 3 / 100)]
  ask leaf_miners [set mortality_threshold mort_threshold]
  ask leaf_miners [if
    (random-float mortality_threshold < mortality) and (week_year > first_generation_emergence) and (week_year < end_growing_season)
      [die]
  ]
end

; pupae in leaves from last generation overwinter and emerge during spring of next year
to over-winter
  if (week_year = start_growing_season - 2)
    [create-leaf_miners (sum [n_unmature_mines] of leaves)
      [
      set color brown
      set size 0.3
      set age 0
      setxy random-xcor -16
      set n_eggs initial_egg_number
      ]
    ]
  ; if no leaf miners were able to survive a fraction of them flies in from other trees --> rescue effect
  set immigration_fraction 10
  if (count leaf_miners < 10)
    [create-leaf_miners (Initial_leaf_miners / immigration_fraction)
      [
      set color brown
      set size 0.3
      set age 0
      setxy random-xcor -16
      set n_eggs 0.0008321892 * ambient_T ^ 4 - 0.0514873577 * ambient_T ^ 3 + 0.7244537352 * ambient_T ^ 2 + 2.8647527846 * ambient_T - 7.5311892638
      ]
    ]
  ask leaves [if
    (week_year = start_growing_season - 2)
      [set n_developing_mines 0]
    ]
end

; mining damage as photosynthesis decrease is calculated from mined leaf area  and non-linear models from Pincebourde et al. (2006)
to mining-damage
  ask leaves [set mine_area random-normal L_mine_area variation_L_mine_area]  ; specify mine area --> typical mine is 10-12 mm long and 4-5 mm wide (ministry of agriculture Ontario
                                                     ; government)
  ask leaves [set mined_area_per_leaf ((n_mature_mines + n_empty_mines) * mine_area)]  ; calculate mined area per leaf from mature and empty mines
  ask leaves [set unmined_area_per_leaf (leaf_area - mined_area_per_leaf)]
  ask leaves [set net_assimilation_with_damage min (list phot_limit_rad phot_limit_wat_pot_damage) / 2]  ; define net assimilation with damage from earlier procedures including
                                                                                                         ; altered water potential
  ; determine net assimilation of damaged leaf parts
  ask leaves [
    ifelse (week_year > start_growing_season) and (week_year < end_growing_season)
      [set net_assimilation_with_damage (((((9.936993186 * (1 - exp(-0.003143711 * received_PARI)) ^ 0.516244599) - 3.219618852) / 2) * (mined_area_per_leaf / leaf_area)) + (net_assimilation * (unmined_area_per_leaf / leaf_area)))]
      [set net_assimilation_with_damage 0]
    ]
; remark: in this setup net assimilation is limited by leaf miners but it would be possible to assess potential photosynthesis only limited by leaf water potential from decreased stomatatal
; conductance from line above
end

to plotting
  if count leaves != 0 [set mean_net_phot (sum [net_assimilation] of leaves / count leaves)]  ; record mean net assimilation without leaf miner damage
  if count leaves != 0 [set mean_net_phot_damage (sum [net_assimilation_with_damage] of leaves / count leaves)]  ; record mean net assimilation without leaf miner damage
  if count leaves != 0 [set mean_n_empty_mines_per_leaf (sum [n_developing_mines] of leaves / count leaves)]  ; record variables about leaf mine morphology
  if count leaves != 0 [set mean_unmined_area_per_leaf (sum [mined_area_per_leaf] of leaves / count leaves)]  ; record variables about leaf mine morphology
  if count leaves != 0 [set mean_plant_vigor (sum [plant_vigor] of leaves / count leaves) * (-2.666666e-11 * ticks ^ 3 + 2.190476e-07 * ticks ^ 2 - 1.819047e-04 * ticks + 1.952380e-02)]
  if count leaves != 0 [set mean_leaf_wat_pot (sum [leaf_water_potential] of leaves / count leaves)]
  print n_year
  ; Update the history list
  if length leaf_miner_history >= 100 [
    set leaf_miner_history but-first leaf_miner_history
  ]
  set leaf_miner_history lput (count leaf_miners) leaf_miner_history

  ; Plot manually
  set-current-plot "Leaf miner population"
  set-current-plot-pen "pen-0"

  ; Plotting logic
  ifelse ticks <= 100 [
    plot count leaf_miners
  ] [
    clear-plot
    let i 0
    foreach leaf_miner_history [
      [val] ->
        plotxy i val
        set i i + 1
    ]
  ]
end

to exporting
;  export-plot "Leaf number" "output files/Leaf number"  ; exporting plots to csv files
;  export-world (word "results " random-float 1.0 ".csv")  ; exports all turtle variables in a separate output file
;  export-world "output files/model_draft3Dv0306_miner_selection_running.csv"
;  if (n_year > 26) [export-view "output files/physical world apple leaf"]
end

; simulated sampling processes to compare model outputs with empirical data
to virtual-ecologist
  ask patches [set closest_leaf_virtual min-one-of leaves [distance myself]]
  ; virtual ecologist is initiated during year 20
  ask patches [
    if (distance closest_leaf_virtual < 0.5) and (n_year > 20) and (n_year < 21) and (week_year = start_growing_season)
      [set virtual_ecologist "on"]
    ]
  ; sticky traps for insects are represented by white patches
  if (n_year > 20) and (n_year < 21) and (week_year = start_growing_season)
    [ask n-of 5 patches with [(virtual_ecologist = "on")] [set pcolor white]]
  ask patches [
    if (pcolor = white)
      [set virtual_count count leaf_miners-here]
    ]

  ; Update the history list
  if length leaf_miner_history1 >= 100 [
    set leaf_miner_history1 but-first leaf_miner_history1
  ]
  set leaf_miner_history1 lput (sum [count leaf_miners-here] of patches with [pcolor = white]) leaf_miner_history1

  set-current-plot "Virtual leaf miner number"
  set-current-plot-pen "pen-1"

  ; Plotting logic
  ifelse ticks <= 100 [
  ;   plot count leaves
    plot sum [count leaf_miners-here] of patches with [pcolor = white]
  ] [
    clear-plot
    let i 0
    foreach leaf_miner_history1 [
      [val] ->
        plotxy i val
        set i i + 1
    ]
  ]
end

; main references
; Bonan, Gordon. (2019). Climate Change and Terrestrial Ecosystem Modeling. Cambridge University Press.
; Ennajeh, M., T. Tounekti, A. M. Vadel, H. Khemira, und H. Cochard. Water Relations and Drought-Induced Embolism in Olive (Olea Europaea) Varieties ‚Meski‘ and ‚Chemlali‘ during Severe Drought. Tree Physiology 28, Nr. 6 (1. Juni 2008): 971–76. https://doi.org/10.1093/treephys/28.6.971.
; Geng, S., Hou, H., & Jung, C. (2019). Effect of Diets and Low Temperature Storage on Adult Performance and Immature Development of Phyllonorycter ringoniella in Laboratory. Insects, 10(11), 387. https://doi.org/10.3390/insects10110387
; Geng, S., & Jung, C. (2017a). Effect of temperature on the demographic parameters of Asiatic apple leafminer, Phyllonorycter ringoniella Matsumura (Lepidoptera: Gracillariidae). 51 Journal of Asia-Pacific Entomology, 20(3), 886–892. https://doi.org/10.1016/j.aspen.2017.06. 009
; Geng, S., & Jung, C. (2017b). Effect of temperature on longevity and fecundity of Phyllonorycter ringoniella (Lepidoptera: Gracillariidae) and its oviposition model. Journal of Asia- Pacific Entomology, 20(4), 1294–1300. https://doi.org/10.1016/j.aspen.2017.09.012
; Geng, S., & Jung, C. (2018). Temperature-dependent development of overwintering pupae of Phyllonorycter ringoniella and its spring emergence model. Journal of Asia-Pacific Entomology, 21(3), 829–835. https://doi.org/10.1016/j.aspen.2018.06.006
; Inbar, M., Doostdar, H., & Mayer, R. T. (2001). Suitability of Stressed and Vigorous Plants to Various Insect Herbivores. Oikos, 94(2), 228–235.
; Li, X., Schmid, B., Wang, F., & Paine, C. E. T. (2016). Net Assimilation Rate determines the Growth Rates of 14 Species of Subtropical Forest Trees. PLOS ONE, 11(3), e0150644. https://doi.org/10.1371/journal.pone.0150644
; Pincebourde, S., Frak, E., Sinoquet, H., Regnard, J. L., & Casas, J. (2007). Herbivory mitigation through increased water-use efficiency in a leaf-mining moth?apple tree relationship. Plant, Cell & Environment, 29, 2238–2247. https://doi.org/10.1111/j.1365-3040.2006.01598.x
@#$#@#$#@
GRAPHICS-WINDOW
0
0
437
438
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

SLIDER
10
59
182
92
Initial_leaf_miners
Initial_leaf_miners
0
5000
200.0
10
1
NIL
HORIZONTAL

BUTTON
13
15
76
48
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
90
15
153
48
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
260
78
460
228
ambient T
Time [half-weeks]
ambient temperature [° C]
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ambient_T"

PLOT
489
80
689
230
Leaf number
Time [half-weeks]
Leaf number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"leaves" 1.0 0 -16777216 true "" "plot count leaves"

PLOT
490
412
690
562
Fruit number
Time [half-weeks]
Fruit number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count fruits"

PLOT
490
246
690
396
Mean net assimilation
Time [half-weeks]
Photosynthesis [µmol m^-2 sec^-1]
0.0
10.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_net_phot_damage"
"pen-1" 1.0 0 -7500403 true "" "plot mean_net_phot"

PLOT
715
81
915
231
Leaf miner population
Time [half-weeks]
Total number of miners 
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-0" 1.0 0 -7500403 true "" ""

PLOT
716
247
916
397
Mean oviposition per leaf
Time [half-weeks]
Oviposition rate [total egg number / total leaf number]
0.0
10.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_oviposition_per_leaf"

BUTTON
173
16
236
49
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
935
81
1135
231
Mean mature mines per leaf
Time [half-weeks]
Mature mines per leaf [total number of mature mines / total leaf number]
0.0
10.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_mature_mines_per_leaf"

PLOT
716
412
916
562
Mean developing mines per leaf
Time [half-weeks]
Rate of developing mines per leaf [total number of developing mines / total leaf number] 
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_n_empty_mines_per_leaf"

PLOT
937
247
1137
397
Mean mined area per leaf
Time [half-weeks]
Mined area [total mined area / total leaf number]
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_unmined_area_per_leaf"

TEXTBOX
305
32
455
53
1. Environment
17
0.0
1

TEXTBOX
526
31
676
53
2. Plant Physiology
17
0.0
1

TEXTBOX
827
32
1016
59
3. Leaf miner phenology
17
0.0
1

SLIDER
11
107
183
140
Initial_leaves
Initial_leaves
5
20
10.0
1
1
NIL
HORIZONTAL

INPUTBOX
190
70
249
130
L_area
140.0
1
0
Number

INPUTBOX
155
150
247
210
Variation_L_area
40.0
1
0
Number

INPUTBOX
12
150
142
210
Max_carboxy
12.0
1
0
Number

SLIDER
10
222
182
255
min_temp
min_temp
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
10
269
182
302
max_temp
max_temp
25
35
28.0
1
1
NIL
HORIZONTAL

SLIDER
11
313
183
346
minPARi
minPARi
200
600
200.0
10
1
NIL
HORIZONTAL

SLIDER
11
359
183
392
maxPARi
maxPARi
800
1600
950.0
10
1
NIL
HORIZONTAL

INPUTBOX
193
235
249
295
minCO2
400.0
1
0
Number

INPUTBOX
256
235
314
295
maxCO2
415.0
1
0
Number

INPUTBOX
321
235
385
295
fruit_start
20.0
1
0
Number

INPUTBOX
391
235
454
295
fruit_end
30.0
1
0
Number

SLIDER
11
405
183
438
first_generation_emergence
first_generation_emergence
16
22
19.0
1
1
NIL
HORIZONTAL

INPUTBOX
250
304
342
364
leaf_miner_start
19.0
1
0
Number

SLIDER
13
448
185
481
max_miner_density
max_miner_density
10
100
50.0
1
1
NIL
HORIZONTAL

INPUTBOX
193
304
243
364
too_old
2.0
1
0
Number

SLIDER
14
493
192
526
vigor_oviposition_threshold
vigor_oviposition_threshold
0
1
0.1
0.05
1
NIL
HORIZONTAL

SLIDER
16
534
188
567
initial_eggs
initial_eggs
20
300
30.0
10
1
NIL
HORIZONTAL

SLIDER
217
538
389
571
max_mature_mines
max_mature_mines
100
1000
240.0
10
1
NIL
HORIZONTAL

SLIDER
218
493
390
526
max_oviposition
max_oviposition
100
1000
240.0
10
1
NIL
HORIZONTAL

SLIDER
216
445
388
478
max_empty_mines
max_empty_mines
100
1000
240.0
10
1
NIL
HORIZONTAL

INPUTBOX
350
304
424
364
mature_age
21.0
1
0
Number

SLIDER
216
401
388
434
mort_threshold
mort_threshold
0
5
1.2
0.05
1
NIL
HORIZONTAL

INPUTBOX
402
400
479
460
L_mine_area
0.5
1
0
Number

INPUTBOX
402
470
479
530
variation_L_mine_area
0.05
1
0
Number

PLOT
490
573
690
723
mean plant vigor
Time [half-weeks]
Mean plant vigor [Number of leaves per sector / Total number of leaves]
0.0
10.0
-0.1
0.1
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_plant_vigor"

PLOT
938
412
1138
562
Total unmature mines
Time [half-weeks]
Total number of unmature mines [total count]
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [n_unmature_mines] of leaves"

PLOT
716
577
916
727
Histogram plant vigor
Mean plant vigor [Number of leaves per sector / Total number of leaves]
Count leaves
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "set-plot-pen-interval 0.05" "histogram [plant_vigor] of leaves"

PLOT
938
579
1138
729
Mean number of eggs
Time [half-weeks]
Mean number of eggs [total egg number / total number of leaf miners]
0.0
10.0
0.0
150.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [n_eggs] of leaf_miners / count leaf_miners"

PLOT
489
737
689
887
Mean leaf water potential
Time [half-weeks]
Leaf water potential [MPa]
0.0
10.0
-2.0
0.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean_leaf_wat_pot * -1"
"pen-1" 1.0 0 -7500403 true "" "plot mean [leaf_water_potential_damage] of leaves * -1"

PLOT
938
738
1138
888
Histogram larval development time
Larval development time [half-weeks]
Count leaf miners 
0.0
20.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [larval_development_time] of leaves"

PLOT
940
899
1140
1049
Histogram age distribution 
NIL
NIL
0.0
0.2
0.0
200.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "set-plot-pen-interval 0.005" "histogram [age] of leaf_miners"

SWITCH
216
637
322
670
Damage?
Damage?
0
1
-1000

SWITCH
214
689
376
722
No-learning?
No-learning?
1
1
-1000

SLIDER
15
583
187
616
plant_vigor_threshold
plant_vigor_threshold
0
1
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
218
583
390
616
nutrition_threshold
nutrition_threshold
0
1
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
12
636
184
669
start_growth
start_growth
13
19
16.0
1
1
NIL
HORIZONTAL

SLIDER
11
690
183
723
end_growth
end_growth
35
41
38.0
1
1
NIL
HORIZONTAL

PLOT
714
900
914
1050
Virtual leaf miner number
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -9276814 true "" ""

@#$#@#$#@
## WHAT IS IT?

The FRUIT model quantifies leaf mining damage inflicted by the spotted tentiform leafminer (_Phyllonorycter blancardella_) on its main host, the apple tree (_Malus domestica_) in an interactive system of leaf mining damage, plant physiology, and host selection. It can be used to investigate feedback effects of leaf mining damage on underlying insect phenolgy.

## HOW IT WORKS

The general modelling approach consists of two parts: firstly modelling plant physiology, and plant growth, and secondly modelling leaf miner phenology, and leaf mining damage. It is set up for the temperate climate zone, and includes environmental variation of incoming solar radiation, temperature and soil moisture. The model simulates growth processes of one individual apple tree over a period of 30 years in half-weekly timesteps with main outputs leaf number and fruit number. Each year individual leaves are infested by leaf mining insects which reduce the leaves photosynthetic capacity and thus the leaves capacity to produce fruits. On the other hand leaf mining insects have certain preferences towards their host leaves, including nutritional value and leaf vitality. This accounts for an interactive system in between leaf mining damage and leaf miner selection of individual leaves.   

## HOW TO USE IT

The model can be run stepwise or continuously. Sliders and Input boxes allow for the  regulation of most important model parameters. To investigate leaf mining damage certain procedures need to be changed manually. 

The switch "Damage?" controls if the apple tree is under infestation (leaf mining damage) or not (control treatment). In addition leaf miner host selection can be either switched on or off with the slider "No-learning?" which results in "picky" leaf miners or leaf miners not being "picky at all" in regard to leaf attributes. In addition the "picky" leaf miners also have a built-in learning ability which constantly redefines host selection thresholds. Those thresholds are dependent on the attributes of already visited leaves. If "No-learning?" is switched off leaf miners make oviposition choices depending on their implemented learning behavior. If "No-learning?" is switched on leaf miners make oviposition decisions depending on fixed plant vigor and nutritional value thresholds which can be determined by sliders.

## AN EXPLANATION OF THE INTERFACE

### Plots

1. **Environment** 
_Ambient temperature_ [°C] over half-weekly timesteps

2. **Plant physiology** 
_Leaf number_ over half-weekly timesteps
_Mean net assimilation rates_ [µmol m<sup>-2</sup> s<sup>-1</sup>] all leaves over half-weekly timesteps
-black line denotes net assimilation rates without infestation damage
-grey line denotes net assimilation rates with damage
_Fruit number_ over half-weekly timesteps
_Mean plant vigor_ of all leaves over half-weekly timesteps
_Histogram plant vigor_ of all leaves
_Mean leaf water potential_ [MPa] of all leaves over half-weekly timesteps

3. **Leaf miner phenology**
_Leaf miner population size_ over half-weekly timesteps
_Mean mature leaf mines_ of all leaves over half-weekly timesteps
_Mean oviposition events_ of all leaves over half-weekly timesteps
_Mean mined area_ [cm<sup>2</sup>] per leaf of all leaves over half-weekly timesteps
_Total empty mines_ of all leaves over half-weekly timesteps
_Total unmature mines_ of all leaves over half-weekly timesteps
_Mean egg number_ of all leaf miners over half-weekly timesteps
_Histogram larval development time_ [half-weeks] of all leaf miners
_Histogram age_ [years] of all leaf miners

### Sliders, Input boxes, Switches 

1. **Sliders**
_Initial_leaf_miners_: Initial number of leaf miners created in setup procedure
_Initial_leaves_: Initial number of leaves created in setup procedure
_min_temp_/_max_temp_: minimum and maximum yearly seasonal temperature 
_min_PARI_/_max_PARI_: minimum and maximum yearly seasonal radiation
_first_generation_emergence_: hatching date of the first generation of leaf miners
_max_miner_density_: leaf miner density threshold for reverse movement
_initial_eggs_: Initial number of eggs leaf miners are supplied with in setup procedure
_plant_vigor_threshold_: Threshold of leaf miners towards leaf quality for oviposition
_nutrition_threshold_: Threshold of leaf miners towards leaf quality for oviposition
_mort_threshold_: Parameter determining leaf miner mortality
_max_oviposition_: maximum possible number of oviposition events per leaf
_max_mature_mines_: maximum possible number of mature leaf mines per leaf
_max_empty_mines_: maximum possible number of empty leaf mines per leaf

2. **Input boxes**
_Max_carboxy_: Maximum carboxylation rate [µmol m<sup>-2</sup> s<sup>-1</sup>] of leaves
_L_area_: µ for normal distribution of leaf area 
_Variation_L_area_: σ for normal distribution of leaf area
_minCO2_/_maxCO2_: minimum and maximum yearly seasonal CO<sub>2</sub> concentration
_fruit_start_/_fruit_end_: yearly timepoints determining beginning/end of fruit formation
_leaf_miner_start_: yearly spring emergence date of leaf miners
_mature_age_: yearly timepoint acting as a threshold for oviposition of leaf miners
_too_old_: threshold determining the oviposition ability of leaf miners 
_L_mine_area_: µ for normal distribution of leaf mine area
_variation_L_mine_area_: σ for normal distribution of leaf mine area

3. **Switches**
_Damage?_: Allows for tree growth with and without infestation
_No-learning?_: Allows for "picky" or "tolerant" leaf miner behaviors

## THINGS TO NOTICE

**Host selection thresholds** are crucial parameters to this model. They determine how leaf mining insects select suitable leaves for oviposition. In the current model state those thresholds can be either set manually or they are determined by the learning behavior of the insects. 

In addition the model is very sensitive towards changes in min_PARI and max_PARI and will result in a manyfold inrease or decrease in primary production. 

Most important variables in relation to environment (1.), plant physiology (2.), and insect phenology (3.) can be observed in the respective plots.

## THINGS TO TRY

Play around with the host searching preferences of leaf miners and observe how leaf miner populations fluctuate accordingly. 

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)
Next to host selection also a very simplistic type of learning behavior is implemented in this model. Leaf miners are able to shift their host selection depending on leaf attributes of previously visited leaves. This learning behavior can be further expanded. 

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)
Note the use of the profiler extension to identify most computationally intense procedures. In addition leaves are determined as superindividuals where one superindividual leaf accounts for 20 individual leaves. Also note the application of the "virtual-ecologist" procedure where field sampling is simulated in the model.

## CREDITS AND REFERENCES

- Bonan, Gordon. (2019). Climate Change and Terrestrial Ecosystem Modeling. Cambridge University Press.
- Ennajeh, M., T. Tounekti, A. M. Vadel, H. Khemira, und H. Cochard. Water Relations and Drought-Induced Embolism in Olive (Olea Europaea) Varieties ‚Meski‘ and ‚Chemlali‘ during Severe Drought. Tree Physiology 28, Nr. 6 (1. Juni 2008): 971–76. https://doi.org/10.1093/treephys/28.6.971.
- Geng, S., Hou, H., & Jung, C. (2019). Effect of Diets and Low Temperature Storage on Adult Performance and Immature Development of Phyllonorycter ringoniella in Laboratory. Insects, 10(11), 387. https://doi.org/10.3390/insects10110387
- Geng, S., & Jung, C. (2017a). Effect of temperature on the demographic parameters of Asiatic apple leafminer, Phyllonorycter ringoniella Matsumura (Lepidoptera: Gracillariidae). 51 Journal of Asia-Pacific Entomology, 20(3), 886–892. https://doi.org/10.1016/j.aspen.2017.06. 009
- Geng, S., & Jung, C. (2017b). Effect of temperature on longevity and fecundity of Phyllonorycter ringoniella (Lepidoptera: Gracillariidae) and its oviposition model. Journal of Asia- Pacific Entomology, 20(4), 1294–1300. https://doi.org/10.1016/j.aspen.2017.09.012
- Geng, S., & Jung, C. (2018). Temperature-dependent development of overwintering pupae of Phyllonorycter ringoniella and its spring emergence model. Journal of Asia-Pacific Entomology, 21(3), 829–835. https://doi.org/10.1016/j.aspen.2018.06.006
- Inbar, M., Doostdar, H., & Mayer, R. T. (2001). Suitability of Stressed and Vigorous Plants to Various Insect Herbivores. Oikos, 94(2), 228–235.
- Li, X., Schmid, B., Wang, F., & Paine, C. E. T. (2016). Net Assimilation Rate determines the Growth Rates of 14 Species of Subtropical Forest Trees. PLOS ONE, 11(3), e0150644. https://doi.org/10.1371/journal.pone.0150644
- Pincebourde, S., Frak, E., Sinoquet, H., Regnard, J. L., & Casas, J. (2007). Herbivory mitigation through increased water-use efficiency in a leaf-mining moth?apple tree relationship. Plant, Cell & Environment, 29, 2238–2247. https://doi.org/10.1111/j.1365-3040.2006.01598.x
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

apple leaf
true
0
Line -7500403 true 150 0 75 90
Line -7500403 true 150 240 135 240
Line -7500403 true 135 240 120 240
Line -7500403 true 120 240 105 225
Line -7500403 true 105 225 90 210
Line -7500403 true 90 210 75 195
Line -7500403 true 75 195 75 90
Line -7500403 true 150 240 180 240
Line -7500403 true 180 240 225 195
Line -7500403 true 225 195 225 90
Line -7500403 true 150 0 225 90
Line -7500403 true 150 240 150 285

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
need-to-manually-make-preview-for-this-model
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="leaf number no damage" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count leaves</metric>
    <metric>count leaf_miners</metric>
    <metric>mean_net_phot</metric>
    <metric>mean_net_phot_damage</metric>
    <metric>mean_leaf_wat_pot</metric>
    <metric>mean_mined_area_per_leaf</metric>
    <metric>sum [virtual_count] of patches</metric>
    <enumeratedValueSet variable="variation_L_mine_area">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L_area">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_oviposition">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="too_old">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_empty_mines">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_miner_density">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fruit_end">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_temp">
      <value value="28"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min_temp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_eggs">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L_mine_area">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial_leaf_miners">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vigor_oviposition_threshold">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mature_age">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fruit_start">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial_leaves">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mort_threshold">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maxCO2">
      <value value="415"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Variation_L_area">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maxPARi">
      <value value="950"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minPARi">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="first_generation_emergence">
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Max_carboxy">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leaf_miner_start">
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mature_mines">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minCO2">
      <value value="400"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="host selection predictors" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>[plant_vigor] of leaves</metric>
    <metric>[mined_area_per_leaf] of leaves</metric>
    <enumeratedValueSet variable="variation_L_mine_area">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L_area">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_oviposition">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="too_old">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_empty_mines">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_miner_density">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fruit_end">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_temp">
      <value value="28"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min_temp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial_eggs">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="L_mine_area">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial_leaf_miners">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vigor_oviposition_threshold">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mature_age">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Initial_leaves">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fruit_start">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mort_threshold">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maxCO2">
      <value value="415"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Variation_L_area">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maxPARi">
      <value value="960"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minPARi">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="first_generation_emergence">
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Max_carboxy">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leaf_miner_start">
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max_mature_mines">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="minCO2">
      <value value="400"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
