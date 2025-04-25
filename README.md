# In-vivo-Sholl-Analysis
Analyze in vivo sholl data from Imaris 

Required software:
R and R studio: https://posit.co/download/rstudio-desktop/
Note this script was tested with R 4.0.0 and R studio 2022.07.1 Build 554. Updates to R may deprecate parts of the code. Please report an issue if so.

Required R packages:
ggplot2 [v3.4.0]
car [v3.0-8]
nlme [v3.1-148]
multcomp [1.4-13]

Input data:
The example data sholl_InputData.csv is from 3D Sholl Analysis from Imaris. 
Please see the following citation for detailed methods: Baldwin, K. T., Tan, C. X., Strader, S. T., Jiang, C., Savage, J. T., Elorza-Vidal, X., ... & Eroglu, C. (2021). HepaCAM controls astrocyte self-organization and coupling. Neuron, 109(15), 2427-2442.
Input data should be a .csv file

Expected output:
![image](https://user-images.githubusercontent.com/65187156/229168874-03d96c20-632e-4646-a816-072b2c0c0b59.png)

Expected run time: < 5 minutes

This research was funded [in part] by Aligning Science Across Parkinson’s [ASAP-020607] through the Michael J. Fox Foundation for Parkinson’s Research (MJFF).
