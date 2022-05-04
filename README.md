# ESM-parents-with-psychosis
R code used to analyse ESM (experience sampling methodology) data from a study measuring stress and psychosis in parents

## Power analysis
We computed a power analysis using the data from the van der Steen et al. (2017) to determine how many participants would be needed in this study. We used the R package described in Green & MacLeod (2016) - SIMR: An R Package for power analysis of generalized linear mixed models by simulation. We looked at three models with psychosis as the outcome for the three different types of stress - event stress, activity stress and social stress - and included negative affect in the model since we hypothesised it would be important as a mediator of the relationship between stress and psychosis. The largest sample size returned from the three power analyses was 32 participants.

## Hypothesis testing
This is a large file containing all the analyses used to test the four hypotheses in the paper "Parenting and psychosis: An experience sampling methodology study investigating the inter-relationship between stress from parenting and positive psychotic symptoms" which was accepted as a registered report by the British Journal of Clinical Psychology in 2020 and is due to be published in 2022/2023.

### Chunk 1 Packages
Packages are loaded

### Chunk 2 Read in datasets
Data is read in and cleaned from two files. Firstly, the time invariant questionnaires given to participants at the beginning of the study. Each participant's individual score is calculcated for the separate questionnaires by summing together the individual questions. The time-varying (ESM) data is then read in. Participant 25 has data recorded twice because her phone stopped working so her data is reduced to 60 beeps. The relevant items are reversed coded before being summed together for the negative affect, psychosis and stress (event, activity, social) scores. Mean-centred variables and parenting-only stress variables are created. Lagged variables are created.

### Chunk 3 Missing data
Missingness is inspected by determining whether missingness in one variable depends on another for the variable psychosis. Missingness in psychosis was related to observation number and therefore observation number was included in all analyses.

Multiple imputation was performed and diagnostic plots were inspected.

### Chunk 4 Visualisation theme
A visulation theme was created.

### Chunk 5 Empty model
An empty multi-level model was created to inspect the ICC. This was compared to an OLS model, and a likelihood ratio test demonstrated its superiority.

### Chunk 6 Mediation
The mediation package was used to check whether negative affect was a mediator of the relationship between stress and psychosis. 1000 simulations were computed.

### Chunks 7-15 Psychosis regression
Linear mixed model regressions of psychosis as the outcome variable were computed, with each parenting stress variable separately. Level-2 (time invariant) variables were included and inspected as covariates and moderators. Visulation plots were computed, and models' residuals were inspected.

### Chunk 16-17 Parenting stress regression with type-of-stress indicator
The same linear mixed models were run separately for each type of stress, but a type-of-stress indicator was included as a moderator of the relationship. Residuals were checked.

###  Chunk 18-27 Parenting stress regression
Linear mixed model regresion of the separate types of parenting stress (event, activity, social) were run with psychosis included as a predictor. Level-2 (time invariant) variables were included and inspected as covariates and moderators. Visulation plots were computed, and models' residuals were inspected.

### Chunk 28 Missing data imputation
The multiple imputation datasets created earlier were pooled together to check the earlier models. 

### Chunk 29 Exploratory analysis
The earlier models were run with additional covariates added to see if any changes occured in significance and beta coefficients.
