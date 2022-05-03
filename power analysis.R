###PREPARING DATA##############
###from Green & MacLeod (2016) - SIMR: An R Package for power analysis of generalized linear mixed models by simulation
###Make simulated data###
###y = outcome (psychosis), x = level 1 observation (stress), g = level 2 grouping variable (id)

van_der_steen<-read.csv("van_der_steen.csv")
sim_dat<-van_der_steen

#add participant no. to match id
sim_dat%>%count(subjno)%>%filter(n>60)
#15200 (#25) has 61 beeps, 15697 has 70 (#64). All others hae 60.
id<-c((rep(1:24, each = 60)),
      (rep(25, each = 61)), 
      (rep(26:63, each = 60)), 
      (rep(64, each = 70)), 
      (rep(65:72, each = 60)))

sim_dat<-cbind(sim_dat, id)

#reverse code act_well
sim_dat<-sim_dat%>%mutate(act_well_reverse = reverse.code(-1, act_well))
sim_dat$act_well_reverse<-as.integer(sim_dat$act_well_reverse)

#compute summary score for stress_act
sim_dat<-sim_dat%>%mutate(stress_act = (act_else + act_difficul + act_well_reverse)/3) 

#for eve_pleasant - all positive events reduced to 0 and all negative ones multipled by -1
#write function
eve_pleas_recode<-function(x) {
  if(is.na(x)) {  
    as.numeric(NA)
  } else if(x>=0){
    0
  } else {
    x * -1
  }
}

#change variables in database
for (i in seq_along(sim_dat$eve_pleasant)) {
  sim_dat$eve_pleasant[[i]] <- eve_pleas_recode(sim_dat$eve_pleasant[[i]])
}

#rename
colnames(sim_dat)[14] <- "stress_event"
sim_dat$stress_event<-as.integer(sim_dat$stress_event)

#not necess to compute anything for social stress just renamed
colnames(sim_dat)[13] <- "stress_soc"

#compute summary score for psychosis
sim_dat<-sim_dat%>%mutate(psychosis = (pat_suspic + pat_th_head + pat_unreal + pat_voices + pat_seething + pat_losectrl + pat_th_othrs)/7) 

#compute summary score for neg_aff
sim_dat<-sim_dat%>%mutate(neg_aff = (mood_guilty + mood_insecur + mood_lonely + mood_anxious)/4)

###get rid of missing rows - otherwise power estimates return as 0.00%
sim_dat<-sim_dat[, -1]
sim_dat_NA<-sim_dat[complete.cases(sim_dat), ]

###POWER ANALYSIS START#######################

###three types of stress

model_act<-lmer(psychosis ~ stress_act + (1|id), data = sim_dat_NA)
model_soc<-lmer(psychosis ~ stress_soc + (1|id), data = sim_dat_NA)
model_event<-lmer(psychosis ~ stress_event + (1|id), data = sim_dat_NA)

summary(model_act)
summary(model_soc)
summary(model_event)

###Under Estimate, x - you can see the estimated effect size 

###Power Analysis###

powerSim(model_act, seed = 123, nsim = 1000)
powerSim(model_soc, seed = 123, nsim = 1000)
powerSim(model_event, seed = 123, nsim = 1000)

#power is 100% here. Look at the curve to see what sample size is needed for 80% power

pc_act<- powerCurve(model_act, along="id")
print(pc_act)
plot(pc_act)

pc_soc <- powerCurve(model_soc, along="id")
print(pc_soc)
plot(pc_soc)

pc_event<-powerCurve(model_event, along="id")
print(pc_event)
plot(pc_event)

#12 participants needed.

###Power analysis with negative affect as mediator###

model_act_outcome<-lmer(psychosis ~ stress_act + neg_aff + (1|id), data = sim_dat_NA)
model_act_mediate <- lmer(neg_aff ~ stress_act + (1|id), data = sim_dat_NA)

mediation_act_result <- mediate(
  model_act_mediate, 
  model_act_outcome, 
  sims = 500,
  treat = "stress_act",
  mediator = "neg_aff"
)

summary(mediation_act_result)
plot(mediation_act_result)

pc_med_act<-powerCurve(model_act_outcome, along="id")
print(pc_med_act)
plot(pc_med_act)

pc_med_act_mediation<-powerCurve(model_act_mediate, along="id")
print(pc_med_act_mediation)
plot(pc_med_act_mediation)

model_event_outcome<-lmer(psychosis ~ stress_event + neg_aff + (1|id), data = sim_dat_NA)

pc_med_event<-powerCurve(model_event_outcome, along="id")
print(pc_med_event)
plot(pc_med_event)

model_soc_outcome<-lmer(psychosis ~ stress_soc + neg_aff + (1|id), data = sim_dat_NA)
pc_med_soc<-powerCurve(model_soc_outcome, along="id")
print(pc_med_soc)
plot(pc_med_soc)

#after introducing negative affect as mediator, power needed goes up from 12 participants to 32.
