using POMDPs
using POMCPOW
using SubHunt
using LaserTag
using POMDPSimulators
using POMDPPolicies
using BasicPOMCP
using D3Trees

# Abbreviate：
# adr: average discounted reward
# ast: average searching time
# atd: average tree depth


pomdp = SubHuntPOMDP()
hr = HistoryRecorder(max_steps=100)
hr2 = HistoryRecorder(max_steps=100)


solver_pomcp = POMCPSolver()
planner_pomcp = solve(solver_pomcp, pomdp)
# solver_pomcpow = POMCPOWSolver(criterion=MaxUCB(20.0,0.5))# c,beta
solver_pomcpow = POMCPOWSolver(criterion=MaxUCB(20.0),k=0.7)
planner_pomcpow = solve(solver_pomcpow, pomdp)

# POMCPOW
if isfile("sub_ow_output.txt") == false
    touch("sub_ow_output.txt")
end
io2 = open("sub_ow_output.txt", "w");
adr_pomcpow_sum = 0
atd_pomcpow_sum = 0

for i = 1 : 10000
    hist_pomcpow = simulate(hr, pomdp, planner_pomcpow)
    adr_pomcpow = discounted_reward(hist_pomcpow)
    atd_pomcpow = tree_depth(hist_pomcpow)
    global adr_pomcpow_sum += adr_pomcpow
    global atd_pomcpow_sum += atd_pomcpow
    avg_adr_pomcpow = adr_pomcpow_sum / i
    avg_atd_pomcpow = atd_pomcpow_sum / i
    println("""
        Simulation $(i)
            POMCPOW: 
                ADR: $(adr_pomcpow)
                ATD: $(atd_pomcpow)
        Cumulative Statistics (for $(i) simulation)
            POMCPOW: 
                AVG_ADR: $(avg_adr_pomcpow)
                AVG_ATD: $(avg_atd_pomcpow)
        """)	
    write(io2, """
        Simulation $(i)
            POMCPOW: 
                ADR: $(adr_pomcpow)
                ATD: $(atd_pomcpow)
        Cumulative Statistics (for $(i) simulation)
            POMCPOW: 
                AVG_ADR: $(avg_adr_pomcpow)
                AVG_ATD: $(avg_atd_pomcpow)
        """)
end


# # POMCP
# if isfile("sub_cp_output.txt") == false
#     touch("sub_cp_output.txt")
# end
# io1 = open("sub_cp_output.txt", "w");
# adr_pomcp_sum = 0
# atd_pomcp_sum = 0

# for i = 1 : 1000
#     hist_pomcp = simulate(hr2, pomdp, planner_pomcp)
#     adr_pomcp = discounted_reward(hist_pomcp)
#     atd_pomcp = tree_depth(hist_pomcp)
#     global adr_pomcp_sum += adr_pomcp
#     global atd_pomcp_sum += atd_pomcp
#     avg_adr_pomcp = adr_pomcp_sum / i
#     avg_atd_pomcp = atd_pomcp_sum / i
#     println("""
#         Simulation $(i)
#             POMCP: 
#                 ADR: $(adr_pomcp)
#                 ATD: $(atd_pomcp)
#         Cumulative Statistics (for $(i) simulation)
#             POMCP: 
#                 AVG_ADR: $(avg_adr_pomcp)
#                 ATD: $(avg_atd_pomcp)
#         """)	
#     write(io1, """
#         Simulation $(i)
#             POMCP: 
#                 ADR: $(adr_pomcp)
#                 ATD: $(atd_pomcp)
#         Cumulative Statistics (for $(i) simulation)
#             POMCP: 
#                 AVG_ADR: $(avg_adr_pomcp)
#                 ATD: $(avg_atd_pomcp)
#         """)
# end

# 修改的启发式算法
# if isfile("sub_owh_output.txt") == false
#     touch("sub_owh_output.txt")
# end
# io2 = open("sub_owh_output.txt", "w");
# adr_pomcpow_sum = 0
# atd_pomcpow_sum = 0

# for i = 1 : 1000
#     hist_pomcpow = simulate(hr, pomdp, planner_pomcpow)
#     adr_pomcpow = discounted_reward(hist_pomcpow)
#     atd_pomcpow = tree_depth(hist_pomcpow)
#     global adr_pomcpow_sum += adr_pomcpow
#     global atd_pomcpow_sum += atd_pomcpow
#     avg_adr_pomcpow = adr_pomcpow_sum / i
#     avg_atd_pomcpow = atd_pomcpow_sum / i
#     println("""
#         Simulation $(i)
#             POMCPOW: 
#                 ADR: $(adr_pomcpow)
#                 ATD: $(atd_pomcpow)
#         Cumulative Statistics (for $(i) simulation)
#             POMCPOW: 
#                 AVG_ADR: $(avg_adr_pomcpow)
#                 AVG_ATD: $(avg_atd_pomcpow)
#         """)	
#     write(io2, """
#         Simulation $(i)
#             POMCPOW: 
#                 ADR: $(adr_pomcpow)
#                 ATD: $(atd_pomcpow)
#         Cumulative Statistics (for $(i) simulation)
#             POMCPOW: 
#                 AVG_ADR: $(avg_adr_pomcpow)
#                 AVG_ATD: $(avg_atd_pomcpow)
#         """)
# end

# #画图
# b = initialstate_distribution(pomdp)
# a, info = POMCPOW.action_info(planner_pomcpow, b)
# d3t = D3Tree(info[:tree])
# inchrome(d3t)

