################################################################################
## Title: visOutputs
## Last Update: 14/07/2022
## Version: 1.0
## Developer Contact: analytics-unit@nhsx.nhs.uk
################################################################################

# ------------ stminsights ------------------------
# Visualise the outputs of the model using stminsights. use_browser = FALSE
# results in a pop up interactive window instead of opening in a browser.
#
# In the interactive browser, load the saved .Rdata file produced from the file
# main.R. On the webpage you are able to view the topic contents,
# correlation, document distribution etc.
run_stminsights() 

# ------------Plot semantic coherence vs exclusivity ------------
options(repr.plot.width=7, repr.plot.height=7, repr.plot.res=100)

plotexcoer <-
  ggplot(ModsExSem, aes(SemanticCoherence, Exclusivity, color = Model)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_text(aes(label = K), nudge_x = .05, nudge_y = .05) +
  labs(x = "Semantic coherence",
       y = "Exclusivity",
       title = "Comparing exclusivity and semantic coherence")

plotexcoer

# ------------ Visualise topics ------------------------
# This code runs `toLDAvis` package and opens a visualisation of stm that allows 
# the user to explore the topic/word distribution in an interactive browser. If 
# the open.browser variable is missing, toLDA vis will lauch in R studios as an 
# interactive plot. 
stm::toLDAvis(mod = model9, docs = stmdata$documents, open.browser = interactive())

# ------------ Topic Labels ------------------------
# This code displays the topic labels for the topics using sageLabels() 
# function. This displays the real words (as opposed to the processed words) 
# most associated with each topic. findThoughts() then displays the most 
# representative texts for each topic. 
sageLabels(model9)
findThoughts(model9, stmdata$meta$Response)
