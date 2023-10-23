Hydrology Deconvolution Toolbox for water residence time estimation 
(smooth signal estimator) with synthetic rainfall and basin measurements

This toolbox is released under the CeCILL-C French license
More info at: http://www.cecill.info/index.en.html

Authors: Alina-Georgiana Meresescu, Matthieu Kowalski, Frederic Schmidt, Francois Landais

The method was published in the following article. Please cite this reference in case of re-use: 
Meresescu, A. G.; Kowalski, M.; Schmidt, F. & Landais, F. Water Residence Time estimation by 1D deconvolution in the form of a l2-regularized inverse problem with smoothness, positivity and causality constraints Computers & Geosciences, Elsevier BV, 2018, 115, 105-121, http://dx.doi.org/10.1016/j.cageo.2018.03.009



No guarantees whatsover for this code when used in any real life applications.

RunDemo.m is the entry point in this toolbox.
- runForOptimalLambda takes the signal pairs x,y and a range of lambdas and
 estimates k, presenting the results for the best found lambda with the
correlation coefficient lambda strategy.
- the 4 tests are for different cases of constraints applied on k all
along its estimation; the best result for causality and positivity applied
is in the last plot
- changing the length of x, determines which dataset is loaded
- the k length can be chosen, as long as it is smaller than the length of x
and it should be an even number
- test cases can be chosen randomly or with a fixed index (100 test cases available)
from the 5 datasets, each dataset having different x lengths; 
- k and y are generated in the chooseSignals function; 
- k type can be changed to a gaussian
- k is considered real for this application
