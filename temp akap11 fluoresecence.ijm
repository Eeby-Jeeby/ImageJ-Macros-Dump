run("Split Channels");

//Protein of Interest 
selectWindow("C1-MAX_40x Sleep Mouse 1 Hippocampus image 2 AKAP11 and DAPI.tif");
setAutoThreshold("Default dark");
setThreshold(74, 255);
run("Make Binary");
run("Set Measurements...", "mean min standard");
run("Measure")

//DAPI
selectWindow("C2-MAX_40x Sleep Mouse 1 Hippocampus image 2 AKAP11 and DAPI.tif");
setAutoThreshold("Default dark");
setThreshold(84, 255);
run("Make Binary");
run("Set Measurements...", "mean min standard");
run("Measure")