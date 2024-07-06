
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
			run("Duplicate...", " ");
			setAutoThreshold("Default dark");
			setThreshold(25, 255);
			run("Convert to Mask");
			run("Watershed");
			run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Outlines add");
			roiManager("Save", original_dir+ title_without_file_extension+"ROIset.zip");
			Ch_1 = title_without_file_extension+".tif";
			selectWindow(Ch_1);
			run("Set Measurements...", "area mean min integrated");
			roiManager("Measure");
			selectWindow("Results");
			new_title = title_without_file_extension + " AKAP11";
			saveAs("Results", original_dir + new_title + ".csv");
			run("Clear Results");			
			run("Close All");
			roiManager("reset");
			
	}
  }

print(" ");
print("Done!");
print("You can find your processed images in the folder " + original_dir);
print(" ");