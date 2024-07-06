
//Clear the log window if it was open
	if (isOpen("Log")){
		selectWindow("Log");
		run("Close");
	}

//Find the orignal directory and create a new one for processed pngs
original_dir = getDirectory("Select a directory");
akap_dir = original_dir + "/AKAP11/";
dapi_dir = original_dir + "/DAPI/";

print("Welcome to the .czi files processing macro!");

// Get a list of all the files in the directory
	//file_list = getFileList(original_dir);
	akap_list = getFileList(akap_dir);
	dapi_list = getFileList(dapi_dir);
	//create a shorter list contiaiing . czi files only
	czi_list = newArray(0);
	czi_list_2 = newArray(0);
	for(z = 0; z < akap_list.length; z++) {
		if(endsWith(akap_list[z], ".tif")) {
			czi_list = Array.concat(czi_list, akap_list[z]);
			czi_list_2 = Array.concat(czi_list_2, dapi_list[z]);
			}
		}
		
print("");		
print(czi_list.length + " AKAP11 images were detected for analysis" + " and " + czi_list_2.length + " DAPI images were detected for analysis");

// Loop through the list of files, excluding subfolders
	for (i = 0; i < czi_list.length; i++){
	path = akap_dir + czi_list[i];
	path2 = dapi_dir + czi_list_2[i];
	print(path2);
		if (File.isFile(path)){
		print(" ");
		
		print("Processing image " + i+1 + " out of " + czi_list.length);
		run("Bio-Formats Importer",  "open=path");
		title_1 = getTitle();
	    run("Bio-Formats Importer",  "open=path2");  
	      //get file title    
			title = getTitle();
			t = lengthOf(title);
			title_without_file_extension = substring(title, 0, t-4);
			run("Duplicate...", "HELLO");
			//CH = title_without_file_extension + "-flu.czi"
			//run("Split Channels");

			//Protein of Interest 
			//selectWindow("C1-" + title_without_file_extension + ".tif");
			//run("Subtract Background...", "rolling=12");
			setAutoThreshold("Otsu dark");
			//AKAP11 = 80, DAPI = 80
			//setThreshold(95, 255);
			run("Create Selection");
			run("Add to Manager");
			selectWindow(title_1);
			run("Brightness/Contrast...");
			setMinAndMax(38, 255);
			run("Apply LUT");
			//run("Make Binary");
			//run("Invert LUTs");
			
			roiManager("select", i);
			
			run("Set Measurements...", "mean min standard limit display");
			run("Measure");
			/*
			selectWindow(title);
			run("Brightness/Contrast...");
			setMinAndMax(39, 255);
			run("Apply LUT");
			//run("Make Binary");
			//run("Invert LUTs");
			roiManager("select", i);
			run("Measure");*/
			/*
			//DAPI
			selectWindow("C2-"+ title_without_file_extension + ".tif");
			setAutoThreshold("Default dark");
			setThreshold(84, 255);
			run("Make Binary");
			run("Set Measurements...", "mean min standard display");
			run("Measure");
			*/
	}
  }
roiManager("deselect");
roiManager("delete");
run("Close All");
print(" ");
print("Done!");
print("You can find your processed images in the folder " + original_dir);
print(" ");