#!/bin/sh

declare -A LABELS=( [a_b]="A + B" [a_double_b]="A + 2 B" [a_half_b]="A + 0.5 B" [a_b_incl]="A + B + Inclusive" [a_double_b_incl]="A + 2 B + Inclusive" [a_half_b_incl]="A + 0.5 B + Inclusive" )

declare -A RESCALED_ALPHAS=( [a_b]="alpha" [a_double_b]="atan(tan(alpha*TMath::Pi()/2)*sqrt(2))*2/TMath::Pi()" [a_half_b]="atan(tan(alpha*TMath::Pi()/2)*sqrt(0.5))*2/TMath::Pi()" [a_b_incl]="alpha" [a_double_b_incl]="atan(tan(alpha*TMath::Pi()/2)*sqrt(2))*2/TMath::Pi()" [a_half_b_incl]="atan(tan(alpha*TMath::Pi()/2)*sqrt(0.5))*2/TMath::Pi()" )

for MODE in a_b a_double_b a_half_b a_b_incl a_double_b_incl a_half_b_incl;
do

	cd ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/

	text2workspace.py -m 125 -P CombineExamples.RelativeFractionOfSignals.physicsmodel:mu_alpha datacard_${MODE}.txt -o workspace_${MODE}.root
	
	combine -m 125 -M MultiDimFit -S 0 --algo grid --points 1600 workspace_${MODE}.root -n .${MODE}
	
	combine -m 125 -M MultiDimFit -S 0 --redefineSignalPOIs alpha --floatOtherPOIs true --algo grid --points 40 workspace_${MODE}.root -n .${MODE}.mu_floating

	cd -
	
	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.MultiDimFit.mH125.root -f limit -x alpha -y mu -z deltaNLL --tree-draw-options prof --x-bins 40,0,1 --y-bins 40,0,2 -m COLZ L L L L L L L L L L --filename deltaNLL_VS_mu_VS_alpha_${MODE}_forComparison --z-lims 0 12 --title "${LABELS[$MODE]}" --analysis-modules ContourFromHistogram --2d-histogram-nicks nick0 --contour-thresholds "1 4" --contour-modes singlegraphs -C kBlack --contour-graph-nicks contour --nicks-whitelist nick0 contour --line-widths 3 $@
	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.MultiDimFit.mH125.root -f limit -x alpha -y mu -z deltaNLL --tree-draw-options prof --x-bins 40,0,1 --y-bins 40,0,2 -m COLZ L L L L L L L L L L --filename deltaNLL_VS_mu_VS_alpha_${MODE} --z-lims 0 --title "${LABELS[$MODE]}" --analysis-modules ContourFromHistogram --2d-histogram-nicks nick0 --contour-thresholds "1 4" --contour-modes singlegraphs -C kBlack --contour-graph-nicks contour --nicks-whitelist nick0 contour --line-widths 3 $@
	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.MultiDimFit.mH125.root -f limit -x "${RESCALED_ALPHAS[$MODE]}" -y mu -z deltaNLL --tree-draw-options prof --x-bins 20,0,1 --y-bins 40,0,2 -m COLZ L L L L L L L L L L --filename deltaNLL_VS_mu_VS_rescaled_alpha_${MODE}_forComparison --z-lims 0 12 --title "${LABELS[$MODE]}" --analysis-modules ContourFromHistogram --2d-histogram-nicks nick0 --contour-thresholds "1 4" --contour-modes singlegraphs -C kBlack --contour-graph-nicks contour --nicks-whitelist nick0 contour --line-widths 3 --x-label "rescaled alpha" $@
	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.MultiDimFit.mH125.root -f limit -x "${RESCALED_ALPHAS[$MODE]}" -y mu -z deltaNLL --tree-draw-options prof --x-bins 20,0,1 --y-bins 40,0,2 -m COLZ L L L L L L L L L L --filename deltaNLL_VS_mu_VS_rescaled_alpha_${MODE} --z-lims 0 --title "${LABELS[$MODE]}" --analysis-modules ContourFromHistogram --2d-histogram-nicks nick0 --contour-thresholds "1 4" --contour-modes singlegraphs -C kBlack --contour-graph-nicks contour --nicks-whitelist nick0 contour --line-widths 3 --x-label "rescaled alpha" $@

	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.mu_floating.MultiDimFit.mH125.root -f limit -x alpha -y deltaNLL --tree-draw-options TGraph -m L --line-widths 3 --filename deltaNLL_VS_alpha_${MODE} --x-lims 0 1 --y-lims 0 --title "${LABELS[$MODE]}" $@
	higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.${MODE}.mu_floating.MultiDimFit.mH125.root -f limit -x "${RESCALED_ALPHAS[$MODE]}" -y deltaNLL --tree-draw-options TGraph -m L --line-widths 3 --filename deltaNLL_VS_rescaled_alpha_${MODE} --x-lims 0 1 --y-lims 0 --title "${LABELS[$MODE]}" --x-label "rescaled alpha" $@

done

higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.a_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_b_incl.mu_floating.MultiDimFit.mH125.root higgsCombine.a_half_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_half_b_incl.mu_floating.MultiDimFit.mH125.root higgsCombine.a_double_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_double_b_incl.mu_floating.MultiDimFit.mH125.root -f limit -x alpha -y deltaNLL --tree-draw-options TGraph -m L --line-widths 3 --filename deltaNLL_VS_alpha_forComparison --labels "${LABELS[a_b]}" "${LABELS[a_b_incl]}" "${LABELS[a_half_b]}" "${LABELS[a_half_b_incl]}" "${LABELS[a_double_b]}" "${LABELS[a_double_b_incl]}" --legend-markers L --legend-cols 2 --legend 0.22 0.7 0.8 0.88 -C kRed kRed kGreen kGreen kBlue kBlue --line-styles 1 2 1 2 1 2 --x-lims 0 1 --y-lims 0 1.5 $@
higgsplot.py -d ${CMSSW_BASE}/src/CombineExamples/RelativeFractionOfSignals/data/ -i higgsCombine.a_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_b_incl.mu_floating.MultiDimFit.mH125.root higgsCombine.a_half_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_half_b_incl.mu_floating.MultiDimFit.mH125.root higgsCombine.a_double_b.mu_floating.MultiDimFit.mH125.root higgsCombine.a_double_b_incl.mu_floating.MultiDimFit.mH125.root -f limit -x "${RESCALED_ALPHAS[a_b]}" "${RESCALED_ALPHAS[a_b_incl]}" "${RESCALED_ALPHAS[a_half_b]}" "${RESCALED_ALPHAS[a_half_b_incl]}" "${RESCALED_ALPHAS[a_double_b]}" "${RESCALED_ALPHAS[a_double_b_incl]}" -y deltaNLL --tree-draw-options TGraph -m L --line-widths 3 --filename deltaNLL_VS_rescaled_alpha_forComparison --labels "${LABELS[a_b]}" "${LABELS[a_b_incl]}" "${LABELS[a_half_b]}" "${LABELS[a_half_b_incl]}" "${LABELS[a_double_b]}" "${LABELS[a_double_b_incl]}" --legend-markers L --legend-cols 2 --legend 0.22 0.7 0.8 0.88 -C kRed kRed kGreen kGreen kBlue kBlue --line-styles 1 2 1 2 1 2 --x-lims 0 1 --y-lims 0 1.5 --x-label "rescaled alpha" $@

