# ELE344 Conception et architecture de processeurs
# ÉTÉ 2024 Ecole de technologie superieure
# Fonction: Test le ual 32 bit selon le test bench ual_tb
#           
# ***** Desrochers Etienne ************
# ***** Code DESE28369801 ************
# Auteur: Etienne Desrochers
# ----------------------------------------------------

# 1) Créé la librarie work
vlib work

# 2) Compiler ual_tb.vhd avec VHDL 1993
vcom -93 -work work txt_util.vhd
vcom -93 -work work ual.vhd
vcom -93 -work work ual_tb.vhd

# 3) Démarrer la simulation avec le design
#    "ual" defini dans ual_tb.vhd
vsim ual_tb

# 4) Ouvrir certaines fenètres pour visualiser
view structure
view signals
view wave

# 5) Montrer tous les signaux dans la fenètre wave
add wave -r *

# 6) Éxécute pendant 410 ns
run 410 ns