# Dataset: Source Code, Raw Data, Processed Data, Processing Scripts, and Results of the APPLE-POPDYN Model

## 1. Description

This dataset contains the model source code and original output from 500 model runs of the APPLE-POPDYN model, a dynamic simulation model designed to explore plant physiological processes, plant growth, leaf miner population dynamics, and their interactions with leaf cluster and insect attributes.

In addition to the raw model outputs, the dataset includes processed data used to generate the figures presented in the results section of the associated publication. The dataset is intended to promote transparency and reproducibility of the simulation and analysis process.

## 2. Folder Structure

- `model src/`: Netlogo source code of the APPLE-POPDYN model
- `data/raw/`: Original model output from 500 simulation runs across different model scenarios.
- `data/processed/`: Simulated and observed data used to generate the figures in the result section.
- `scripts/`: R scripts used to process raw data and generate the analytical figures.
- `results/`: Outcome of model calibration and validation, and results from scenario analyses focused on leaf miner behavior.

## 3. File Descriptions

- `model src/APPLE POPDYN model 2D submit 6.2.0`: single Netlogo file which contains the complete source code of the APPLE-POPDYN model
- `data/raw/results500_no_damage_submit.csv`: CSV file containing the simulated results of 500 model runs under the control treatment scenario without damage
- `data/raw/results500_damage_submit.csv`: CSV file containing the simulated results of 500 model runs under the scenario with "tolerant" leaf miners
- `data/raw/results500_damage_learning_submit.csv`: CSV file containing the simulated results of 500 model runs under the scenario with "pciky" leaf miners

## 4. Licensing

## 5. Citation

## 6. Contact
