# Dataset: Source Code, Raw Data, Processed Data, Processing Scripts, and Results of the APPLE-POPDYN Model

## 1. Description

This dataset contains the model source code and original output from 500 model runs of the APPLE-POPDYN model, a dynamic simulation model designed to explore leaf miner herbivory in a system of mutual influences with plant physiological processes, plant growth, and leaf miner phenology.

In addition to the raw model outputs, the dataset includes processed data used to generate the figures presented in the results section of the associated publication. The dataset is intended to promote transparency and reproducibility of the simulation and analysis process.

## 2. Folder Structure

- `model src/`: Netlogo source code of the APPLE-POPDYN model
- `data/raw/`: Original model output from 500 simulation runs across different model scenarios. The raw data files are archived on Zenodo due to their size. Below is a description of each file in the data/raw/ directory.
- `data/processed/`: Simulated and observed data used to generate the figures in the result section.
- `scripts/`: R scripts used to process raw data and generate the analytical figures.
- `results/`: Outcome of model calibration and validation, and results from scenario analyses focused on leaf miner behavior.

## 3. File Descriptions

## 3.1 Raw Data

- `model src/APPLE POPDYN model 2D submit 6.2.0`: single Netlogo file which contains the complete source code of the APPLE-POPDYN model
- `data/raw/results500_no_damage_submit.csv`: CSV file containing the simulated results of 500 model runs under the control treatment scenario without damage. To access these files, visit the Zenodo archive:
📦 [https://doi.org/10.5281/zenodo.16027116](https://doi.org/10.5281/zenodo.16027116)
- `data/raw/results500_damage_submit.csv`: CSV file containing the simulated results of 500 model runs under the scenario with "tolerant" leaf miners. To access these files, visit the Zenodo archive:
📦 [https://doi.org/10.5281/zenodo.16027116](https://doi.org/10.5281/zenodo.16027116)
- `data/raw/results500_damage_learning_submit.csv`: CSV file containing the simulated results of 500 model runs under the scenario with "pciky" leaf miners. To access these files, visit the Zenodo archive:
📦 [https://doi.org/10.5281/zenodo.16027116](https://doi.org/10.5281/zenodo.16027116)

## 3.2 Processed Data

- `data/processed/Observed net assimilation.txt`: Text file containing the observed net assimilation from Fuji and Kennedy (1985), see Figure 4 and 6 in results
- `data/processed/Simulated net assimilation.txt`: Text file containing the simulated net assimilation of one model run without damage, see Figure 4 and 6 in results
- `data/processed/leaf number.txt`: Text file containing the simulated leaf number of one model run (see Figure 5 in results)
- `data/processed/Missouri leaf miner demographics grand pas 1991.txt`: Text file containing the observed leaf miner counts from Gagne and Barrett (1994) from the orchard Grand Pas in 1991, see Figures 7 and 8
- `data/processed/Missouri leaf miner demographics grand pas 1992.txt`: Text file containing the observed leaf miner counts from Gagne and Barrett (1994) from the orchard Grand Pas in 1992, see Figures 7 and 8
- `data/processed/Missouri leaf miner demographics waverly 1991.txt`: Text file containing the observed leaf miner counts from Gagne and Barrett (1994) from the orchard Waverly in 1991, see Figures 7 and 8
- `data/processed/Missouri leaf miner demographics waverly 1992.txt`: Text file containing the observed leaf miner counts from Gagne and Barrett (1994) from the orchard Waverly in 1992, see Figures 7 and 8
- `data/processed/Simulated leaf miner demographics year 15 model run 1.txt`: Text file containing the simulated leaf miner counts from model run 1 in year 15 under the scenario of "tolerant" leaf miners, see Figures 7 and 8
- `data/processed/Simulated leaf miner demographics year 15 model run 1 learning.txt`: Text file containing the simulated leaf miner counts from model run 1 in year 15 under the scenario of "picky" leaf miners, see Figures 7 and 8
- `data/processed/Simulated leaf miner demographics year 30 model run 1.txt`: Text file containing the simulated leaf miner counts from model run 1 in year 30 under the scenario of "tolerant" leaf miners, see Figures 7 and 8
- `data/processed/Simulated leaf miner demographics year 30 model run 1 learning.txt`: Text file containing the simulated leaf miner counts from model run 1 in year 30 under the scenario of "picky" leaf miners, see Figures 7 and 8
- `data/processed/leaf number.txt`: Text file containing the simulated leaf number of one model run (see Figure 5 in results)
- `data/processed/Missouri orchards leaf data.txt`: Text file containing the number of observed and simulated leaf mines for model validation (see Figure 9 in results)

## 3.3 Scripts and Results

- `scripts/data analysis submit1.R`: R script for data processing, visualization and statistical analysis
- `scripts/Graphical comparison.R`: additional R script for visualization only
- `scripts/nlrx operation submit.R`: R script for operation of the NetLogo source code of the APPLE-POPDYN model via the R package nlrx
- `results/Separate result section.docx`: Word document containing the results of the APPLE-POPDYN model

## 4. Licensing

This dataset is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/). You are free to use, distribute, and adapt the material, provided proper attribution is given.

## 5. Citation

**Häffner, F., Meyer, K., Pincebourde, S., Wiegand, K.** (2025). *Dataset: Raw Data, Processed Data, Processing Scripts, and Results of the APPLE-POPDYN Model*.

## 6. Contact

For questions or suggestions, please contact:

[Felix Sauke]
[Helmholtz-Centre for Environmental Resarch]
[felix.sauke@ufz.de]

## 7. References

- **Fujii, J. A., & Kennedy, R. A.** (1985). Seasonal Changes in the Photosynthetic Rate in Apple Trees: A Comparison between Fruiting and Nonfruiting Trees. Plant Physiology, 78(3), 519–524. https://doi.org/10.1104/pp.78.3.519
- **Gagne, R. S., & Barrett, B. A.** (1994). Seasonal Occurrence and Density ofPhyllonorycterspp. (Lepidoptera: Gracillariidae) and Major Parasitoids in Missouri Apple Orchards. Environmental Entomology, 23(1), 198–207. https://doi.org/10.1093/ee/23.1.198
