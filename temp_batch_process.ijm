
//Clear the log window if it was open
	if (isOpen("Log")){
		selectWindow("Log");
		run("Close");
	}

//Find the orignal directory and create a new one for processed pngs
original_dir = getDirectory("Select a directory");


print("Welcome to the .czi files processing macro!");

//Dialog wundow to request info from the user about the desired processing parameters
	  Channel_number = newArray("1", "2", "3", "4");
	  Channel_1 = "CFOS";
	  Color_for_Ch_1 = newArray("Green", "Grays", "Blue", "Red");
	  
	  Channel_number_2 = newArray("1", "2", "3", "4");
	  Channel_2 = "CFOS";
	  Color_for_Ch_2 = newArray("Green", "Grays", "Blue", "Red");

	  Dialog.create("Please type in the desired processing parameters");
	  Dialog.addChoice("Which channel to export:", Channel_number);
	  Dialog.addString("Exported channel name:", Channel_1);
	  Dialog.addChoice("Pick a color for the Channel 1", Color_for_Ch_1);
	  Dialog.show();
	  Channel_number = Dialog.getChoice();
	  Channel_1 = Dialog.getString();
	  Color_for_Ch_1 = Dialog.getChoice();
	  
	  Dialog.create("Please type in the desired processing parameters");
	  Dialog.addChoice("Which channel to export:", Channel_number_2);
	  Dialog.addString("Exported channel name:", Channel_2);
	  Dialog.addChoice("Pick a color for the Channel 1", Color_for_Ch_2);
	  Dialog.show();
	  Channel_number_2 = Dialog.getChoice();
	  Channel_2 = Dialog.getString();
	  Color_for_Ch_2 = Dialog.getChoice();
	  
output_dir = original_dir +Channel_1 + File.separator;
File.makeDirectory(output_dir);
output_dir_2 = original_dir +Channel_2 + File.separator;
File.makeDirectory(output_dir_2);
  

// Get a list of all the files in the directory
	file_list = getFileList(original_dir);
	//create a shorter list contiaiing . czi files only
	czi_list = newArray(0);
	for(z = 0; z < file_list.length; z++) {
		if(endsWith(file_list[z], ".czi")) {
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
								
			//create a ROI for cropping, place it by default in the center 
			setSlice(Channel_number);
			run("Duplicate...", "duplicate channels=Channel_number");
			run("Z Project...", "projection=[Max Intensity]");
			Ch_1 = "MAX_"+title_without_file_extension + "-1.czi";
				selectWindow(Ch_1);	
	            run(Color_for_Ch_1);
	        index = lengthOf(Ch_1);
				new_Ch1_title = title_without_file_extension + Channel_1;
				saveAs("tif", output_dir + new_Ch1_title + ".tif");
				Ch1_name = new_Ch1_title + ".tif";
			run("Close");
	        selectWindow(title);    
			setSlice(Channel_number_2);
			//print(Channel_number_2);
			run("Duplicate...", "duplicate channels=Channel_number_2");
			run("Z Project...", "projection=[Max Intensity]");
			//Ch_2 = getTitle();
	        Ch_2 = "MAX_"+title_without_file_extension + "-1-1.czi";
	        //selectWindow(Ch_2);
	        run(Color_for_Ch_2);
	        index = lengthOf(Ch_2);
				new_Ch2_title = title_without_file_extension + Channel_2;
				saveAs("tif", output_dir_2 + new_Ch2_title + ".tif");
				Ch2_name = new_Ch2_title + ".tif";
			//run("Close");
			//process and save the channel of interest
			
	           
				//Find the length of the channel name and crop off C1 and .czi
				//new_Ch_title = title_without_file_extension + " " + Channel_1 + " and " + Channel_2;
				//saveAs("tif", output_dir + new_Ch_title + ".tif");
				//Ch_name = new_Ch_title + ".tif";	
				
			run("Close All");
			roiManager("reset");
			
	}
  }

print(" ");
print("Done!");
print("You can find your processed images in the folder " + output_dir);
print(" ");