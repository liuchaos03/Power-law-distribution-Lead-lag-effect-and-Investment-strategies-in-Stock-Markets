# Power-law-distribution-Lead-lag-effect-and-Investment-strategies-in-Stock-Markets

We have multiple data and multiple programs. Please read the program introduction carefully before executing.

Two stock sets are selected for the application and validation of the proposed method. One is the set of the 300 stocks contained in China Securities Index 300 index. The other is the set of stocks included in the Standard & Poor’s 500 Index. Data is available for download via network disk.
URL：https://pan.baidu.com/s/1UzkjPXjhxTcysZW4Yuzqfg 
password：r0xk 

The network disk contains two files:
final_csi_09-20.mat is the trading data of 300 stocks in Shanghai and Shenzhen from 2009 to 2020
final_sp500_09-20.mat is theTrading data for S&P 500 stocks from 2009 to 2020



The backtest code of section 5 is stored in two folders, CSI300 and S&P500, respectively.
Each stock market contains three types of strategies, among which P_lead_lag_ori is the execution file of Pure lead-lag strategy;The file named P_ORI_alpha_XX is the execution file corresponding to Pure Alpha XX Strategy;The P_XXX_LEAD_LAG is the execution file for the Alpha XXX Enhancement Strategy


In addition, P_read_sp500.m or P_READ_CSI.m files are required to load the required data before execution, and the benchmark selected can be used to load different data. The corresponding data names should be modified in this file
