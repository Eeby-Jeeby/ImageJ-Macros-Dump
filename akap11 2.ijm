
//Clear the log window if it was open
	if (isOpen("Log")){
		selectWindow("Log");
		run("Close");
	}

//Find the orignal directory and create a new one for processed pngs
original_dir = getDirectory("Select a directory");

print("Welcome to the .czi files processing macro!");

// Get a list of all the files in the directory
	file_list = getFileList(original_dir);
	//create a shorter list contiaiing . czi files only
	czi_list = newArray(0);
	for(z = 0; z < file_list.length; z++) {
		if(endsWith(file_list[z], ".tif")) {
			czi_list = Array.concat(czi_list, file_list[z]);
			}
		}
		
print("");		
print(czi_list.length + " images were detected for analysis");

// Loop through the list of files, excluding subfolders
	for (i = 0; i < czi_list.length; i++){
	path = original_dir + czi_list[i];
		if (File.isFile(path)){
		print(" ");
		print("Processing image " + i+1 + " out of " + czi_list.length);
		run("Bio-Formats Importer",  "open=path");
	      
	      //get file title    
			title = getTitle();
			t = lengthOf(title);
			title_without_file_extension = substring(title, 0, t-4);
			
			//CH = title_without_file_extension + "-flu.czi"
			//run("Split Channels");

			//Protein of Interest 
			//selectWindow("C1-" + title_without_file_extension + ".tif");
			//run("Subtract Background...", "rolling=12");
			setAutoThreshold("Default dark");
			//AKAP11 = 80, DAPI = 80
			setThreshold(95, 255);
			run("Make Binary");
			run("Invert LUTs");
			run("Set Measurements...", "mean min standard display");
			run("Measure");
			
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

print(" ");
print("Done!");
print("You can find your processed images in the folder " + original_dir);
print(" ");