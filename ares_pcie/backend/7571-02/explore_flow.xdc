##Create a script for a multivariable test for synthesis and implementation strategies for Vivado 2016.2
#June 2017 Alberto L. Gasso
#synthesis
set SYNTH_FLOW "Vivado Synthesis 2019"
set IMPL_FLOW  "Vivado Implementation 2019"

create_run synth_1 -flow ${SYNTH_FLOW}
create_run synth_2 -flow ${SYNTH_FLOW} -strategy Flow_AreaOptimized_high
create_run synth_3 -flow ${SYNTH_FLOW} -strategy Flow_PerfOptimized_high
 
########################################################################################################### 
# synth_1 implementations
########################################################################################################### 
create_run s1_impl_1  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_Explore
create_run s1_impl_2  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_ExplorePostRoutePhysOpt
create_run s1_impl_3  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_high
create_run s1_impl_4  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_low
create_run s1_impl_5  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_Retiming
create_run s1_impl_6  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_ExtraTimingOpt
create_run s1_impl_7  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_RefinePlacement
create_run s1_impl_8  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_SpreadSLLs
create_run s1_impl_9  -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Performance_BalanceSLLs
create_run s1_impl_10 -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Area_Explore
create_run s1_impl_11 -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Area_ExploreSequential
create_run s1_impl_12 -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Area_ExploreWithRemap
create_run s1_impl_13 -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Power_DefaultOpt
create_run s1_impl_14 -parent_run synth_1 -flow ${IMPL_FLOW} -strategy Power_ExploreArea
 

########################################################################################################### 
# synth_2 implementations
########################################################################################################### 
create_run s2_impl_1  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_Explore
create_run s2_impl_2  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_ExplorePostRoutePhysOpt
create_run s2_impl_3  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_high
create_run s2_impl_4  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_low
create_run s2_impl_5  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_Retiming
create_run s2_impl_6  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_ExtraTimingOpt
create_run s2_impl_7  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_RefinePlacement
create_run s2_impl_8  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_SpreadSLLs
create_run s2_impl_9  -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Performance_BalanceSLLs
create_run s2_impl_10 -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Area_Explore
create_run s2_impl_11 -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Area_ExploreSequential
create_run s2_impl_12 -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Area_ExploreWithRemap
create_run s2_impl_13 -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Power_DefaultOpt
create_run s2_impl_14 -parent_run synth_2 -flow ${IMPL_FLOW} -strategy Power_ExploreArea
 

########################################################################################################### 
# synth_3 implementations
########################################################################################################### 
create_run s3_impl_1  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_Explore
create_run s3_impl_2  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_ExplorePostRoutePhysOpt
create_run s3_impl_3  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_high
create_run s3_impl_4  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_NetDelay_low
create_run s3_impl_5  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_Retiming
create_run s3_impl_6  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_ExtraTimingOpt
create_run s3_impl_7  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_RefinePlacement
create_run s3_impl_8  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_SpreadSLLs
create_run s3_impl_9  -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Performance_BalanceSLLs
create_run s3_impl_10 -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Area_Explore
create_run s3_impl_11 -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Area_ExploreSequential
create_run s3_impl_12 -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Area_ExploreWithRemap
create_run s3_impl_13 -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Power_DefaultOpt
create_run s3_impl_14 -parent_run synth_3 -flow ${IMPL_FLOW} -strategy Power_ExploreArea
 