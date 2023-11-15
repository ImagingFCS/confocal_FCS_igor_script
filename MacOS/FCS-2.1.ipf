#pragma rtGlobals=1		// Use modern global access method.
// correctted wave names
//********************************************************************************
//Renamed FCS-2.1 		Build 12/13/2017 by Ashwin Nelanuthala VS
//FCS-Flex02-12D1.51.ipf	(mm/dd/yyyy)
//						Ver 2.1 Build 11/02/2017 by Ashwin Nelauthala VS
//						Ver 1.9 Build 05/12/2010 by Yong Hwee Foo
//						Ver 1.8 Build 06/25/2009 by Yong Hwee Foo
//						Ver 1.7 Build 12/10/2007 by Yong Hwee Foo
//						Ver 1.6 Built 09/20/2006 by Xiaotao Pan
//						Ver 1.5 Build 10/5/2004 by T. Wohland
//						Ver 1.21 Build 2/12/2004 by L.C. Hwang  
//						Ver 1.2 Build 1/29/2004 by T. Wohland
//						Ver 1.1 Build 8/12/2003 by T. Wohland
//						Ver 1.0 Build 8/12/2003 by T. Wohland
//						Ver 3.2 Build 5/16/2003 by T. Wohland
//						Ver 3.0 Build 5/14/2003 by T. Wohland
//						Ver 2.2 Build 5/9/2003 by T. Wohland
//                Ver 2.10 Build 105 by Bo Huang on 2002.03.26
//                Ver 1.00 Build 000 by Bo Huang on 2001.12.25
//  Adapted from FCS-Flex99R.ipf by T. Wohland
//********************************************************************************
//
//Version History
//
// 2002.03.26  Ver 2.10 Build 105
//     Allow user to chose path and file name in an open file dialog
//     Add the function of loading all the files in one directory
//     Add file existence check before calling LoadWave in FCSLoadFile
//     Change the seperator in short file name from '_' to '\'
//
// 2002.03.16  Ver 2.01 Build 104
//     Improved statistics result display and error (multiple model use) detection.
//
// 2002.02.19  Ver 2.00 Build 103
//     Fix bug in cut off string by blank space when loading path name in configuration
//     Bug fixation for Data Validity CheckBox
//
// 2002.02.16  Ver 2.00 Build 101
//     New data selection interface!
//     Adding configuration saving feature
//     Rearranging button patterns
//     Confirmation before killing and normalization
//     Support for cross correlation (two intensities)
//     Re-design Load First-Last interlock to allow LoadFirst change with LoadLast when decreasing LoadLast
//     
// 2002.01.12  Ver 1.22 Build 100
//     Correct fitting parameter stdev error due to assigning WeightWave=1 to FuncFit
//
//	NEW CORRELATOR with new structure, renaming of file according FCS-Flex02-12D 
//
//Ver 1.0 Build 8/12/2003 by T. Wohland
//	Adapted to the new correlator with several correaltion functions 
//	New timescale included 
// Ver 1.1 Build 8/12/2003 by T. Wohland
//	automatic loading of files and choice of files to load given
//
// Ver 1.2 Build 1/29/2004 by T. Wohland
//	N originally total numebr of particles in singlet is changed to total number of particles
//	configuration file adapted
//
// Ver 1.21 Build 2/12/2004 by L.C. Hwang
//	Intensity (avg and stdev) in channels 1 and 2 included in Statistics results
//
//Ver 1.5 Build 10/5/2005 by T. Wohland
//	Data Models are automatically read in
//
//Ver 1.6 Build 09/20/2006 by Xiaotao Pan
//	Zeiss ConfoCor3 data loading
//      ACF and CCF batch data statistics
//
//Ver 1.7 Build 12/10/2007 by Yong Hwee Foo
//	Added calculation of brightness (Intensity/N) for FCS & FCCS
//	Fixed the bug related to LoadAll which previously does not work with Quad mode
//	Intesity Trace is set to green and red colour, corresponding to G & R channels, if FCCS data is loaded
//	Added FCCS fuctions (refer to FCCS section)
//	Slight changes made to some existing functions in order for the FCCS functions to work
//	For CF with amplitude less than 2, the y-axis scaling is adjusted to show the curves better 
//
//Ver 1.8 Build 06/25/2009 by Yong Hwee Foo
//	Kill Seleted in FCCS mode kills all of the 4 ACF and CCF when only one of them is selected to be kill
//	Removed the Fit 10 button, in place of this, the threshold for determining the chi square and hence termination of the fitting has been lowered to 0.00001. The number of iternations is increased from default of 40 to 80.
//
//Ver 1.9 Build 05/12/2010 by Yong Hwee Foo
//	Added in calculation of w0, z0, Veff and Concentration for calibration.
//	Added in Loading of data from Leica SP2 FCS output.
//	Added FCCS normalization options
//	Fixed the bug related to loading of SA data when the previous load was not SA mode.
// 
// Ver 2.1 Build 11/02/2017 by Ashwin NVS
//	Added provision to load of multiple ASCII data stored in .dat files exported from PicoQuant's Symphotime 64 
//********************************************************************************
//
//Renamed FCS-2.1 12/13/2017 by Ashwin NVS
// Added provision to load and fit FCCS ASCII data from Picoquant
//********************************************************************************
//  New menu item in Analysis menu
//********************************************************************************

Menu "Analysis"
   "FCS Da&ta Processing...", FCSClearLastRun();FCSInitVariables();FCSInitDataIndex();FCSInitModels(); FCSInitFormats();FCSShowWindows()
End

//********************************************************************************
//  Initiating Function for variable definition and windows control
//********************************************************************************

Function FCSClearLastRun()					//Clear the variables and waves of pervious run of this program, allow restarting
	if(DataFolderExists("root:FCS"))
		NVAR LoadedCount=root:FCS:LoadedCount
		Variable i
		for(i=0;i<=LoadedCount;i+=1)
			DoWindow /K $("Graph_"+num2str(i))
			DoWindow /K $("Table_"+num2str(i))
			DoWindow /K $("Residue_"+num2str(i))
			DoWindow /K $("FCCS_Graph_"+num2str(i))					//YH
			DoWindow /K $("Intensity_"+num2str(i))
		endfor
		DoWindow /K FCSGraph
		DoWindow /K FCSResidue
		DoWindow /K FCSTable
		DoWindow /K FCCSGraph						//YH
		DoWindow /K FCCSTable						//YH
		DoWindow /K FCSIntensity
		
		//NVAR dispCurrent=root:FCS:DispCurrent
		//String IntensityName	=  GetIntensityName(DispCurrent)
		//DoWindow/K $IntensityName		
		
		DoWindow /K FCSResult
		DoWindow /K FCSMainControl
		DoWindow /K FCSFileControl
		DoWindow /K FCCSPanel						//YH
		KillDataFolder root:FCS
	endif
End

//***************************************
Function FCSSaveConfFile()			//Save the used parameter into the configuration file
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	NVAR XStart, XEnd, LoadFirst, LoadLast, NumberofDigits, ShortNameStyle, WeightMethod, UseSameWindow
	SVAR PathName, FileName
	
	Silent 1
	PathInfo IgorUserFiles
	NewPath/O/Q Ihome, S_path + "Igor Procedures:"
	Variable ConfFile
	String ConfFileName="FCS-2.1.conf"
	Open /P=Ihome ConfFile as ConfFileName

	fprintf ConfFile, "FCS-Flex99R-New Configuration File\r\n"
	fprintf ConfFile, "Please do not add any blank line or change the line order, \r\nnor can the leading indicator (before =) be changed, \r\nwhile you can change the contents after that\r\n"
	fprintf ConfFile, "========================\r\n"
	fprintf ConfFile, "XStart=%d\r\n", XStart
	fprintf ConfFile, "XEnd=%d\r\n", XEnd
	fprintf ConfFile, "PathName=%s\r\n", PathName
	fprintf ConfFile, "FileName=%s\r\n", FileName
	fprintf ConfFile, "LoadFirst=%d\r\n", LoadFirst
	fprintf ConfFile, "LoadLast=%d\r\n", LoadLast
	fprintf ConfFile, "NumberofDigits=%d\r\n", NumberofDigits
	fprintf ConfFile, "ShortNameStyle=%d\r\n", ShortNameStyle
	fprintf ConfFile, "WeightMethod=%d\r\n", WeightMethod
	fprintf ConfFile, "UseSameWindow=%d\r\n", UseSameWindow
	fprintf ConfFile, "========================"
	
	Close ConfFile
	Print "Configuration saved"
	
	SetDataFolder dfSave
End

//***************************************
Function FCSLoadconfFile()			//Load configuration
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	NVAR XStart, XEnd, LoadFirst, LoadLast, NumberofDigits, ShortNameStyle, WeightMethod, UseSameWindow
	SVAR PathName, FileName
	
	Variable ConfFile
	String ConfFileName=":Igor Procedures:FCS-2.1.conf"
	Open /R /Z /P=Igor ConfFile as ConfFileName
	if(V_flag)
		Print "Unable to open configuration file."
		SetDataFolder dfSave
		return -1
	endif

	Variable i
	
	Make /O/N=16/T LoadedConf
	String LoadTemp
	for(i=0;i<16;i+=1)					//Pre-read each line
		FReadLine ConfFile, LoadTemp
		LoadedConf[i]=LoadTemp
	endfor
	
										//Check file format
	if(cmpstr(LoadedConf[4],"========================\r")||cmpstr(LoadedConf[15],"========================"))
		Print "Bad configuration file format."
		SetDataFolder dfSave
		return -1
	endif
										//Read configurations
	sscanf LoadedConf[5],  "XStart=%d", XStart
	sscanf LoadedConf[6],  "XEnd=%d", XEnd
	sscanf LoadedConf[7],  "PathName=%[^\r]", PathName
	sscanf LoadedConf[8],  "FileName=%[^\r]", FileName
	sscanf LoadedConf[9],  "LoadFirst=%d", LoadFirst
	sscanf LoadedConf[10], "LoadLast=%d", LoadLast
	sscanf LoadedConf[11], "NumberofDigits=%d", NumberofDigits
	sscanf LoadedConf[12], "ShortNameStyle=%d", ShortNameStyle
	sscanf LoadedConf[13], "WeightMethod=%d", WeightMethod
	sscanf LoadedConf[14], "UseSameWindow=%d", UseSameWindow

	KillWaves LoadedConf
	Close ConfFile
	Print "Configuration loaded"
	SetDataFolder dfSave
End

	
//***************************************
Function FCSInitVariables()					//Initiate Global variables
	String dfSave=GetDataFolder(1)
	NewDataFolder/O/S root:FCS				//The data folder for storing all the variables
	
	Variable/G XSTart=150,		XEnd=700		//Fitting range

	Variable/G DCurrent=0,    DEnd=0			//Memory data pointers
	Variable/G DispCurrent=-1

	String/G PathName=SpecialDirPAth("Documents",0,0,0)
	String/G FileName="AX00"						//File loading defaults
	Variable/G LoadFirst=0, LoadLast=4
	Variable/G NumberofDigits=2				// Number of digits to convert file number into file name
	String/G DataFormat="SA"				// SA - single autocorrelation; SC - single crosscorrelation;  DA - double autocorrelation;
											// DC - double cross correlation; Q - quadruple (double auto, double cross)
	Make/O/N=5 ValidColumns={11, 11, 16, 16, 24} // SA and SC - 11; DA and DC - 16; Q - 24
	Make/N=1/O/T DataNameApp="SA-"		// List prefixes for the different waves in one file
	Variable/G NumOfLoads=1					// How many correlation functions are in file
	Variable/G NumOfRuns=1					// How many loads have been done
		
// Below are system parameters to be set in Options dialog	box
	Variable/G ShortNameStyle=0				//How many directories are included in the short name
	Variable/G WeightMethod=0				//Fitting Model: 0 - No weight, 1 - Kopple weight,
												// 2 - statistics stdev for group fitting
	Variable/G UseSameWindow=1				//Using only one set of window to display all the data (fewer windows opened for large number of data)
	
	Variable/G FCCSMode=0						//Indicate whether the FCCS display is active			//YH
	
	String ConfFileName=":Igor Procedures:FCS-2.1.conf"
	Variable ConfFile

	Open /P=Igor /Z /R ConfFile as ConfFileName //Check file existence
	if(V_flag)
		Print "Create new configuration file"
		FCSSaveConfFile()						//Create configuration file
	else
		Close ConfFile
		FCSLoadConfFile()						//Read configuration
	endif
		
	SetDataFolder dfSave
End

//****************************************
Function FCSInitDataIndex()					//Initiate data indeces
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	Variable/G DMax=80						//Maximum number of loaded data
	NVAR UseSameWindow
	if(UseSameWindow)
		DMax=1000
	endif
	
	Variable/G DLast=-1						//The pointer of the last data, equivalent to the number of loaded data - 1
	Variable/G LoadedCount=-1				//Cumulative loaded data count, used for naming the waves
	
	Make /O/N=(1)	DataNumIndex			//Value set according to LoadedCount, used for wave names and window names
	Make /O/N=(1)/T	DataNameIndex			//Short name, used for window titles and control panel list
	Make /O/N=(1)/T	FileNameIndex			//Full path and file name
	Make /O/N=(1)	Intensity1					//Average intensity for Channel A
	Make /O/N=(1)	Intensity2					//Average intensity for Channel B
	Make /O/N=(1)	AcquisitionTime			//Data acquisition time
	Make /O/N=(1)	IsValid					//If it is valid
	Make /O/N=(1)  SelectionIndex		//For data selection display
	Make /O/N=(1)	ModelIndex				//Model number used for fitting
	Make /O/N=(1)/T	ModelNameIndex			//Model name used for fitting
	Make /O/N=(1)	Chis						//Reduced Chi^2
	Make /O/N=(1,20) FitResults				//Fitting results
	
	Make /O/N=300   Zeros = 0				//For the horizontal line at zero in residue graph

	SetDataFolder dfSave
End	
	
//****************************************
Macro FCSInitModels()	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	Variable fnum, pos1, pos2, pos3, pos4, postmp
	Variable nfunc, i, k, strpos1, strpos2
	String line, tmpstr1, tmpstr2
	
	String/G ModelMenu=""
	Variable/G DModel=0

	//Define filename and path, should be equal on all computers
	Silent 1
	PathInfo IgorUserFiles
	NewPath/O/Q Ihome, S_path + "Igor Procedures:"
	Open/Z=2/R/P=Ihome fnum as "FCS-Fitting Functions4.6.ipf"

	nfunc=0	// Count number of functions present in the funtion file
	do
		FReadLine fnum, line
		postmp=strsearch(line,"Function/D mod_",0)
		if(postmp>=0)
			nfunc+=1
		endif
		FStatus fnum
	while(V_logEOF-V_filePos>0)

	//Read Models
	Make/O/N=(nfunc)/T ModelList
	FSetPos fnum, 0
	i=0
	do
		do
			FReadLine fnum, line
			pos1=strsearch(line,"Function/D mod_",0)
		while(pos1<0)
		pos1=pos1+11
		pos2=strsearch(line,"(",0)-1
		ModelList[i]=line[pos1+4,pos2]
		if(i==nfunc)
			ModelMenu = ModelMenu + ModelList[i]
		else
			ModelMenu = ModelMenu + ModelList[i] + ";"
		endif
		tmpstr1="m"+line[pos1+4,pos2]
		postmp=strsearch(line,"|",0)-1
		pos3=strsearch(line,"(",postmp)+1
		pos4=strsearch(line,")",postmp)-1
		Make/O/T $tmpstr1
		strpos1=pos3
		k=0
		do
			strpos2=strsearch(line,",",strpos1)-1
			$tmpstr1[k]=line[strpos1,strpos2]
			if(strpos2>=0)
				strpos1=strpos2+2
			endif
			k+=1
		while(strpos2>=0)
		$tmpstr1[k-1]=line[strpos1,pos4]
		Redimension/N=(k) $tmpstr1
	i+=1
	while(i<nfunc)

	Close fnum
	SetDataFolder dfSave
EndMacro
//****************************************
Function FCSInitFormats()	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	String/G FormatMenu=""
	Variable i
	
	Make/O/N=5/T FormatList= {"SA","SC","DA","DC","Q"}

	For(i=0;i<4;i+=1)
		FormatMenu = FormatMenu + FormatList[i] + ";"
	EndFor
	FormatMenu = FormatMenu+FormatList[i]
	SetDataFolder dfSave
End
//*********************************
Function FCSShowWindows()
	DoWindow/K Table0
	FCSShowMainControl()
	FCSCreateResult()
	DoWindow/F FCSMainControl
End


//********************************************************************************
//  Main Control Panel definitions
//********************************************************************************

Function FCSShowMainControl()
	DoWindow/K FCSMainControl
	Execute "FCSMainControl()"
End	

//***********************************
Window FCSMainControl() : Panel
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	String CurrentFileName, StartFileName, EndFileName
	
	CurrentFileName=DataNameIndex[DCurrent]
//	StartFileName=DataNameIndex[DStart]
	EndFileName=DataNameIndex[DEnd]
	
	PauseUpdate; Silent 1
	NewPanel/K=2/W=(480,10,980,298) as "FCS Data Processing"	// initial values depend on screen, old (730,10,1140,280)

	GroupBox FitControls title="Fitting", pos={5,5},size={133,120}
	PopupMenu SelectModel title="Model:",fsize=12,font="Arial",pos={2,32},size={133,24},value=root:FCS:ModelMenu,proc=OnSelectModel
	SetVariable XStart title="X Start",font="Arial",fsize=12,pos={15,68},size={113,20}
	SetVariable XStart value=XStart,limits={0,Inf,1}//,proc=OnXStartEndChange
	SetVariable XEnd title="X End",font="Arial",fsize=12,pos={20,98},size={109,20}
	SetVariable XEnd value=XEnd,limits={0,Inf,1}//,proc=OnXStartEndChange
	
	GroupBox DataList title="Data", pos={142,5},size={118,120}
//	SetVariable DCurrent title="Current",font="Arial",fsize=12,pos={172,32},size={109,20}
//	SetVariable DCurrent value=DCurrent,proc=OnDCurrentChange
//	CheckBox IsValid title="Valid",pos={229,62},size={48,14}
//	CheckBox IsValid proc=OnValidCheck
//	Button CurrentFileName frame=0,font="Arial",fsize=12,pos={287,30},size={110,20}, proc=OnCurrentFileNameClick

//	SetVariable DEnd title="End",font="Arial",fsize=12,pos={196,95},size={84,20}
//	SetVariable DEnd value=DEnd,proc=OnDEndChange
//	Button EndFileName frame=0,font="Arial",fsize=12,pos={287,94},size={110,20}, proc=OnEndFileNameClick

	Button Prev title="<Prev<", pos={149,32}, size={50,30}, proc=OnPrevClick
	Button Next title=">Next>", pos={204,32}, size={50,30}, proc=OnNextClick
	CheckBox IsValid title="Valid", pos={175,101}, size={48, 14}, proc=OnValidCheck
	
	
	Button CurrentFileName pos={147, 70}, size={110,20},fsize=12, frame=0, proc=OnRedrawCurrentClick
	ListBox DataSelection pos={264,17}, size={230, 258}, frame=2
	ListBox DataSelection mode=3, selWave=SelectionIndex, listWave=DataNameIndex, proc=OnDataSelection

	UpdateDPointersDisplay()

	
	GroupBox Actions title="Actions",pos={5,128},size={255,156}
//	Button Statistics title="Statistics",pos={206,190},size={90,30},proc=OnStatisticsClick
//	Button ResultTable title="Result Table",pos={299,190},size={90,30},proc=OnResultTableClick
	Button FitCurrent title="Fit First",pos={12,150},size={115,30},proc=OnFitCurrentClick
//	Button FitCurrent10s title="Fit 10",pos={95,150},size={75,30},proc=OnFitCurrent10Click						//YH
	Button FitSelected title="FitSelected",pos={138,150},size={115,30},proc=OnFitSelectedClick
	Button VolCali title="Vol. Calibration",pos={95,220},size={75,30},proc=OnVolCaliClick						//YH
	Button Statistics  title="Statistics", pos={12, 185}, size={75,30}, proc=OnStatisticsClick
	Button KillData title="Kill Selected",pos={95,185},size={75,30},proc=OnKillDataClick
	Button ACFcurve title="ACFcurve",pos={178,185},size={75,30},proc=OnClickACFcurve	
//	Button RedrawCurrent title="Redraw Current", pos={132, 185}, size={110,30},proc=OnRedrawCurrentClick
	Button LoadDialog title="Load...",pos={12,220},size={75,55},proc=OnLoadDialogClick
	Button CalBright title="Cpm",pos={95,255},size={50,20},proc=OnBrightnessClick						//YH
	Button FCCSPanel title="FCCS Panel",pos={178,220},size={75,30},proc=OnClickFCCSPanel					//YH		
	PopupMenu OtherOptions title="Other Options", pos={152,257}, size={118,30}
	PopupMenu OtherOptions value="Redraw current data;Repaint results;Kill selected;Normalize selected;Options...;Save configuration",mode=0,proc=OnOtherOptionsSelect

//	ListBox SelectCurrentFile frame=2, listWave=DataNameIndex, mode=2, disable=1
//	ListBox SelectCurrentFile pos={287, 20}, size={120, 200}, selRow=DCurrent, proc=OnSelectCurrentFile
//	ListBox SelectEndFile frame=2, listWave=DataNameIndex, mode=2, disable=1
//	ListBox SelectEndFile pos={287, 20}, size={120, 200}, selRow=DEnd, proc=OnSelectEndFile

	SetDataFolder dfSave
End

//*********************************

Function OnSelectModel(ctrlName, popNum, popString)
	String ctrlName, popString
	Variable popNum
	
	NVAR DModel=root:FCS:DModel
	NVAR DCurrent=root:FCS:DCurrent
	NVAR DLast=root:FCS:DLast
	
	DModel=popNum-1
	if(DLast>=0)
		FCSResetModel(DCurrent, DModel, 1)
	endif
End
		

//Function UpdateDPointersDisplay()
//	NVAR DLast=root:FCS:DLast
//	NVAR DEnd=root:FCS:DEnd
//	NVAR DCurrent=root:FCS:DCurrent
//	NVAR DModel=root:FCS:DModel
//	WAVE/T DataNameIndex=root:FCS:DataNameIndex
//	WAVE/T FileNameIndex=root:FCS:FileNameIndex
//	WAVE   IsValid=root:FCS:IsValid
//	WAVE   ModelIndex=root:FCS:ModelIndex
//	
//	if(DLast<0)				//When no data loaded
//		CheckBox IsValid win=FCSMainControl, value=0
//		SetVariable DCurrent win=FCSMainControl, limits={0,DLast,1}, help={"No Data Loaded"}
//		Button      CurrentFileName win=FCSMainControl, title="No Data", help={"No Data Loaded"}
//		SetVariable DEnd     win=FCSMainControl, limits={DCurrent, DLast, 1}, help={"No Data Loaded"}
//		Button      EndFileName win=FCSMainControl, title="No Data", help={"No Data Loaded"}
//		PopupMenu   SelectModel win=FCSMainControl, mode=1
//	else	
//		CheckBox IsValid win=FCSMainControl, value=IsValid[DCurrent]
//		String DataName=DataNameIndex[DCurrent]
//		String FileName=FileNameIndex[DCurrent]
//		SetVariable DCurrent win=FCSMainControl, limits={0,DLast,1}, help={FileName}
//		Button      CurrentFileName win=FCSMainControl, title=DataName, help={FileName}
//		DataName=DataNameIndex[DEnd]
//		FileName=FileNameIndex[DEnd]
//		SetVariable DEnd     win=FCSMainControl, limits={DCurrent, DLast, 1}, help={FileName}
//		Button      EndFileName win=FCSMainControl, title=DataName, help={FileName}
//		PopupMenu   SelectModel win=FCSMainControl, mode=(ModelIndex[DCurrent]+1)
//		DModel=ModelIndex[DCurrent]
//	endif
//End

Function UpdateDPointersDisplay()
	NVAR DLast=root:FCS:DLast
	NVAR DEnd=root:FCS:DEnd
	NVAR DCurrent=root:FCS:DCurrent
	NVAR DModel=root:FCS:DModel
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	WAVE/T FileNameIndex=root:FCS:FileNameIndex
	WAVE   IsValid=root:FCS:IsValid
	WAVE   SelectionIndex=root:FCS:SelectionIndex
	WAVE   ModelIndex=root:FCS:ModelIndex
	
	if(DLast<0)				//When no data loaded
		CheckBox IsValid win=FCSMainControl, value=0
		PopupMenu   SelectModel win=FCSMainControl, mode=1
		ListBox DataSelection win=FCSMainControl,disable=1
		Button CurrentFileName win=FCSMainControl, title="No Data", help={"No Data"}
	else	
		ListBox DataSelection win=FCSMainControl,disable=0			//Adjust list position
		if(DCurrent<7||DLast<15)
			ListBox DataSelection win=FCSMainControl, row=0
		elseif(DCurrent>DLast-8)
			ListBox DataSelection win=FCSMainControl, row=(DLast-15)
		else
			ListBox DataSelection win=FCSMainControl, row=(DCurrent-7)
		endif
					
		Variable i							//Generage new selection index if DCurrent or DEnd is changed
		for(i=0;i<=DLast;i+=1)
			SelectionIndex[i]=0
		endfor
		for(i=DCurrent;i<=DEnd;i+=1)
			SelectionIndex[i]=1
		endfor
			
		CheckBox IsValid win=FCSMainControl, value=IsValid[DCurrent]		//Set display
		String DataName=DataNameIndex[DCurrent]
		String FileName=FileNameIndex[DCurrent]
		Button CurrentFileName win=FCSMainControl, title=DataName, help={FileName}
		DModel=ModelIndex[DCurrent]
		PopupMenu   SelectModel win=FCSMainControl, mode=(ModelIndex[DCurrent]+1)
	endif
//	Print "DCurrent=",DCurrent,", DEnd=",DEnd,", DLast=",DLast
End

Function UpdateListBoxDPointersDisplay()  	//When do selection from data name listbox, there is no need to calculate selection index
	NVAR DEnd=root:FCS:DEnd					//and list position cannot be changed, otherwise it will cause wrong selection
	NVAR DCurrent=root:FCS:DCurrent
	NVAR DModel=root:FCS:DModel
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	WAVE/T FileNameIndex=root:FCS:FileNameIndex
	WAVE   IsValid=root:FCS:IsValid
	WAVE   ModelIndex=root:FCS:ModelIndex
	
	CheckBox IsValid win=FCSMainControl, value=IsValid[DCurrent]
	String DataName=DataNameIndex[DCurrent]
	String FileName=FileNameIndex[DCurrent]
	Button CurrentFileName win=FCSMainControl, title=DataName, help={FileName}
	DModel=ModelIndex[DCurrent]
	PopupMenu   SelectModel win=FCSMainControl, mode=(ModelIndex[DCurrent]+1)
//	Print "DCurrent=",DCurrent,", DEnd=",DEnd,", DLast=",DLast
End

Function OnNextClick(ctrlName):ButtonControl  //DCurrent += 1
	String ctrlName
	NVAR DCurrent=root:FCS:DCurrent
	NVAR DEnd=root:FCS:DEnd
	NVAR DLast=root:FCS:DLast

	if(DCurrent<DLast)
		DCurrent+=1
		if(DEnd<DCurrent)
			DEnd=DCurrent
		endif
	endif
	UpdateDPointersDisplay()
	FCSB2F(DCurrent)
End

Function OnPrevClick(ctrlName):ButtonControl  //DCurrent -= 1
	String ctrlName
	NVAR DCurrent=root:FCS:DCurrent
	
	if(DCurrent>0)
		DCurrent-=1
	endif
	UpdateDPointersDisplay()
	FCSB2F(DCurrent)
End
//*********************************
Function OnDataSelection(ctrlName,row,col,event)
	String ctrlName // name of this control
	Variable row // row if click in interior, -1 if click in title
	Variable col // column number
	Variable event // event code
	
	NVAR DEnd=root:FCS:DEnd, DCurrent=root:FCS:DCurrent, DLast=root:FCS:DLast
	WAVE SelectionIndex=root:FCS:SelectionIndex
	
	Variable i		
	if(event==4||event==5)		//List selection
		for(i=0;i<DLast;i+=1)		//Find DCurrent and DEnd from selection index
			if(SelectionIndex[i]!=0)
				break
			endif
		endfor
		DCurrent=i
		for(i=DCurrent;i<=DLast;i+=1)
			if(SelectionIndex[i]==0)
				break
			endif
		endfor
		DEnd=i-1
		if(DCurrent>DEnd)
			DEnd=DCurrent
		endif
		UpdateListBoxDPointersDisplay()		//Use the special one
		FCSB2F(DCurrent)
	endif	
	return 0
End

//**********************************
//Function OnDCurrentChange(ctrlName, varNum, varStr, varName) : SetVariableControl
//	String ctrlName, varStr, varName
//	Variable varNum
//	
//	NVAR DEnd=root:FCS:DEnd
//	
//	If(DEnd<varNum)
//		DEnd=varNum
//	Endif
//	
//	UpdateDPointersDisplay()
//	FCSB2F(varNum)
//End

	
//Function OnDEndChange(ctrlName, varNum, varStr, varName) : SetVariableControl
//	String ctrlName, varStr, varName
//	Variable varNum
//	
//	UpdateDPointersDisplay()
//End

//*************************************
Function OnCurrentFileNameClick(ctrlName)
	String ctrlName
	
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	NVAR DCurrent=root:FCS:DCurrent
	ListBox SelectCurrentFile win=FCSMainControl, disable=0, selRow=DCurrent
End

Function OnSelectCurrentFile(ctrlName,row,col,event)
	String ctrlName // name of this control
	Variable row // row if click in interior, -1 if click in title
	Variable col // column number
	Variable event // event code
	
	NVAR DCurrent=root:FCS:DCurrent, DEnd=root:FCS:DEnd
	if(event==4)
		DCurrent=row
		ListBox SelectCurrentFile win=FCSMainControl, disable=1
		if(DEnd<DCurrent)
			DEnd=DCurrent
		Endif
		UpdateDPointersDisplay()
	endif
End

Function OnEndFileNameClick(ctrlName)
	String ctrlName
	
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	NVAR DEnd=root:FCS:DEnd
	ListBox SelectEndFile win=FCSMainControl, disable=0, selRow=DEnd
End

Function OnSelectEndFile(ctrlName,row,col,event)
	String ctrlName // name of this control
	Variable row // row if click in interior, -1 if click in title
	Variable col // column number
	Variable event // event code
	
	NVAR DEnd=root:FCS:DEnd, DCurrent=root:FCS:DCurrent
	if(event==4&&row>DCurrent)
		DEnd=row
		ListBox SelectEndFile, disable=1
		UpdateDPointersDisplay()
	endif
End

//*************************************
Function OnValidCheck(ctrlName, Checked)
	String ctrlName
	Variable Checked
	
	NVAR DCurrent=root:FCS:DCurrent
	WAVE IsValid=root:FCS:IsValid
	
	Print "Check", DCurrent, "=",Checked
	IsValid[DCurrent]=Checked
End


//*********************************
Function OnLoadDialogClick(ctrlName) : ButtonControl
	String ctrlName
	
	DoWindow/F FCSFileControl
	if (V_Flag != 0)
		return 0
	endif
	
	Execute "FCSFileControl()"
End

Function OnStatisticsClick(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR DStart=root:FCS:DCurrent,DEnd=root:FCS:DEnd
	FCSStat(DStart,DEnd)
End

Function OnResultTableClick(ctrlName) : ButtonControl
	String ctrlName
	
	FCSB2FResult()
End

Function OnFitCurrentClick(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR DCurrent=root:FCS:DCurrent,DModel=root:FCS:DModel
	
	FCSFit(DCurrent, DCurrent, DModel)
End

//************************************************************
//Function OnFitCurrent10Click(ctrlName) : ButtonControl
//	String ctrlName
	
//	NVAR DCurrent=root:FCS:DCurrent,DModel=root:FCS:DModel
	
//	Variable i
//	for (i=1; i<10; i+=1)
//		FCSFit(DCurrent, DCurrent, DModel)
//	endfor
//End

//************************************************************

Function OnFitSelectedClick(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR DStart=root:FCS:DCurrent,DEnd=root:FCS:DEnd,DModel=root:FCS:DModel
	FCSFit(DStart,DEnd,DModel)
End

//***************************************************************
Function OnClickACFcurve(ctrlName) : ButtonControl
	String ctrlName
	
	ACFmain()
	
End
//****************************************************************


Function OnRedrawCurrentClick(ctrlName) :ButtonControl
	String ctrlName
	NVAR DCurrent=root:FCS:DCurrent
	
	FCSShowData(DCurrent)
end
	
//********************

Function OnKillDataClick(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR FCCSMode=root:FCS:FCCSMode																//YH
	
	if(FCCSMode)																						
		DoAlert 1, "Are you sure to kill the selected data and the other related auto and cross-correlation data?"
		if(V_flag==1)
			NVAR DStart=root:FCS:DCurrent,DEnd=root:FCS:DEnd
			FCCSKillData(DStart,DEnd)
		endif
	else																									//YH
		DoAlert 1, "Are you sure to kill the selected data?"
		if(V_flag==1)
			NVAR DStart=root:FCS:DCurrent,DEnd=root:FCS:DEnd
			FCSKillData(DStart,DEnd)
		endif
	endif
End

//********************
Function OnOtherOptionsSelect(ctrlName, popNum, popString) : PopupMenuControl
	String ctrlName, popString
	Variable popNum

	NVAR DCurrent=root:FCS:DCurrent, DEnd=root:FCS:DEnd
	switch (popNum)
		case 1:
			OnRedrawCurrentClick("")
			break
		case 2:
			FCSCreateResult()
			break
		case 3:
			OnKillDataClick("")
			break
		case 4:
			DoAlert 1, "Are you sure to normalize the selected data?"
			if(V_flag!=1)
				break
			endif
			FCSNormalize(DCurrent, DEnd)
			break
		case 5:
			FCSShowOptions()
			break
		case 6:
			FCSSaveConfFile()
			break
	endswitch
End
			

//************************************************************************************
//   Load File Dialog
//************************************************************************************


Function FCSShowFileControl()
	DoWindow/F FCSFileControl
	if (V_Flag != 0)
		return 0
	endif
	Execute "FCSFileControl()"
End	

//**********************************
Window FCSFileControl() : Panel
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NumOfLoads=1										//YH: to reset the number to 1 for SA mode since SA is the default when the Load.. button is clicked.
	Make/O/T/N=1 DataNameApp="SA-"					//YH
	
	PauseUpdate; Silent 1 // building window...

	NewPanel/W=(300,240,743,702)/K=1 as "Load File"

	GroupBox FlexFCS pos={9,9}, title="FlexFCS data loading", fsize=11, size={425,145}, fColor=(0,0,65535), fstyle=001, font="Arial"
	SetVariable PathName,	title="Path Name",		fsize=12, font="Arial", pos={20,35},size={400,30},frame=1,value=PathName
	SetVariable FileName,	title="File Name", 	fsize=12, font="Arial", pos={26,60},size={150,30},frame=1,value=FileName
	SetVariable LoadFirst,	title="First File", 	fsize=12, font="Arial", pos={33,85},size={122,30},frame=1,value=LoadFirst,limits={0,Inf,1},proc=OnLoadFirstChange
	SetVariable LoadLast,	title="Last File", 	fsize=12, font="Arial", pos={34,110},size={120,30},frame=1,value=LoadLast,limits={0,Inf,1},proc=OnLoadLastChange
	PopupMenu DataFormat title="Format:",fsize=12,font="Arial",pos={180,60},size={60,20},value=root:FCS:FormatMenu,proc=OnSelectFormat
	SetVariable NumberofDigits, title="# of Digits", fsize=12, font="Arial", pos={310,60},size={110,30},frame=1,value=NumberofDigits,limits={0,4,1}
	Button OpenFile pos={165,95}, size={90,30}, fsize=12, font="Arial", title="Change Dir...",win=FCSFileControl, proc=OnOpenFileClick
	Button OpenFile win=FCSFileControl, help={"Change current folder for data files"}
	Button LoadFile pos={259,95},size={78,30},fsize=12,font="Arial",title="Load",win=FCSFileControl,proc=OnLoadFileClick
	Button LoadFile win=FCSFileControl, help={"Load files range from FileName+LStart to FileName+LEnd"}
	Button LoadAll  pos={341,95},size={78,30},fsize=12,font="Arial",title="Load All!",win=FCSFileControl,proc=OnLoadAllClick
	Button LoadAll win=FCSFileControl, help={"Load all files in current folder"}
	CheckBox Flex99 pos={355,133},size={78,15},title="Flex99", fsize=10, value=0
	
	//************************ Zeiss ConfoCor3 data loading ************************//  by Xiaotao on 20060920
	GroupBox ConfoCorDataLoading pos={9,160}, title="ConfoCor3 data loading", fsize=11, size={425,95}, fColor=(0,0,65535), fstyle=001, font="Arial"
	CheckBox SAuto pos={20,185},size={78,15},title="A x A", fsize=12, value=1,mode=1,proc=OnCheckCFClick									//YH: Changed to AxA on default due to resetting of NumofLoads to 1.
	CheckBox DAuto pos={20,205},size={78,15},title="A x A ; B x B", fsize=12, value=0,mode=1,proc=OnCheckCFClick
	CheckBox Quad pos={20,225},size={78,15},title="A x A ; B x B ; A x B ; B x A", fsize=12, value=0,mode=1,proc=OnCheckCFClick
	Button FindFile  pos={230,200},size={85,30},fsize=12,font="Arial",title="Find .fcs File",win=FCSFileControl,proc=OnFindFileClick
	Button LoadConfoCor  pos={330,200},size={70,30},fsize=12,font="Arial",title="Load",win=FCSFileControl,proc=OnLoadConfoCorClick
	//****************************************
	//************************ Leica SP2 FCS ************************//  by Yong Hwee on 20091022
	GroupBox LeicaFCS pos={9,260}, title="Leica SP2 FCS data loading", fsize=11, size={425,95}, fColor=(0,0,65535), fstyle=001, font="Arial"
	CheckBox LeiSAuto pos={20,290},size={78,15},title="Autocorrelation", fsize=12, value=1,mode=1,proc=OnCheckLeicaClick
	CheckBox LeiTri pos={20,310},size={78,15},title="Cross-correlation", fsize=12, value=0,mode=1,proc=OnCheckLeicaClick
	Button FindcsvFile  pos={230,300},size={85,30},fsize=12,font="Arial",title="Find .csv Files",win=FCSFileControl,proc=OnOpencsvFileClick
	Button Loadcsv  pos={330,300},size={70,30},fsize=12,font="Arial",title="Load All",win=FCSFileControl,proc=OnLoadcsvClick
	//****************************************
	//************************ PicoQuant FCS ************************//  by Thorsten on 20151105
	GroupBox PicoQuantFCS pos={9,360}, title="PicoQuant FCS data loading", fsize=11, size={425,95}, fColor=(0,0,65535), fstyle=001, font="Arial"
	CheckBox PicoQuantSAuto pos={20,390},size={78,15},title="Autocorrelation", fsize=12, value=1,mode=1,proc=OnCheckPicoQuantClick
	CheckBox PicoQuantTri pos={20,410},size={78,15},title="Cross-correlation", fsize=12, value=0,mode=1,proc=OnCheckPicoQuantClick
	Button FinddatFile  pos={230,400},size={85,30},fsize=12,font="Arial",title="Find .dat Files",win=FCSFileControl,proc=OnOpendatFileClick
	Button Loaddat  pos={330,400},size={70,30},fsize=12,font="Arial",title="Load All",win=FCSFileControl,proc=OnLoaddatClick
	//****************************************
	
	SetDataFolder dfSave
End


//*********************************
Function OnLoadFirstChange(ctrlName, varNum, varStr, varName) : SetVariableControl
	String ctrlName, varStr, varName
	Variable varNum
	
	NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	If(LoadFirst>LoadLast)			//LoadFirst and LoadLast interlock
		LoadLast=LoadFirst
	endif
	
	SetVariable LoadFirst,win=FCSFileControl, limits={0,Inf,1}
	SetVariable LoadLast, win=FCSFileControl, limits={0,Inf,1}
End

Function OnLoadLastChange(ctrlName, varNum, varStr, varName) : SetVariableControl
	String ctrlName, varStr, varName
	Variable varNum
	
	NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	If(LoadFirst>LoadLast)			//LoadFirst and LoadLast interlock
		LoadFirst=LoadLast
	endif
	
	SetVariable LoadFirst,win=FCSFileControl, limits={0,Inf,1}
	SetVariable LoadLast, win=FCSFileControl, limits={0,Inf,1}
End


//**********************************
Function OnLoadFileClick(ctrlName) : ButtonControl
	String ctrlName

	NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	FCSLoadFiles(PathName, FileName, LoadFirst, LoadLast)
	DoWindow/K FCSFileControl

	NVAR DCurrent=root:FCS:DCurrent
	FCSB2F(DCurrent)
End

//**********************************
Function OnCheckCFClick(ctrlName,checked) : CheckBoxControl					//mode: autocorrelation or cross-correlation
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
		
	NVAR NumOfLoads=root:FCS:NumOfLoads
	
	strswitch (ctrlName)
		case "SAuto":
			NumOfLoads = 1
			break
		case "DAuto":
			NumOfLoads = 2
			break
		case "Quad":
			NumOfLoads = 4
			break
	endswitch
	
	CheckBox SAuto,value= NumOfLoads==1
	CheckBox DAuto,value= NumOfLoads==2
	CheckBox Quad,value= NumOfLoads==4

End



//**********************************

//**********************************
Function OnFindFileClick(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	ConfoCorOpenFilename()
	
End

//**********************************
Function OnLoadConfoCorClick(ctrlName) : ButtonControl
	String ctrlName

	//NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	//ConfoCorOpenFilename()
	
	ConfoCorLoad(PathName, FileName)	
	DoWindow/K FCSFileControl
	
	NVAR DLast=root:FCS:DLast
	FCSShowData(DLast)

	NVAR DCurrent=root:FCS:DCurrent
	FCSB2F(DCurrent)
End


//**********************************
Function OnOpenFileClick(ctrlName) :ButtonControl
	String ctrlName
	
	FCSOpenFilename()	

End

//**********************************
Function OnLoadAllClick(ctrlName) :ButtonControl
	String ctrlName
	
	SVAR PathName=root:FCS:PathName
	FCSLoadAll(PathName)
	DoWindow/K FCSFileControl

	NVAR DCurrent=root:FCS:DCurrent
	FCSB2F(DCurrent)
End

//**********************************
Function OnSelectFormat(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName, popStr
	Variable popNum
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	SVAR DataFormat=root:FCS:DataFormat
	NVAR NumOfLoads=root:FCS:NumOfLoads
	//WAVE/T DataNameApp=root:FCS:DataNameApp
	
	strswitch(popStr)
		case "SA":
			NumOfLoads=1
			Make/O/T/N=1 DataNameApp="SA-"
		break
		case "SC":
			NumOfLoads=1
			Make/O/T/N=1 DataNameApp="SC-"	
		break
		case "DA":
			NumOfLoads=2
			Make/O/T/N=2 DataNameApp={"GA-","RA-"}	
		break
		case "DC":
			NumOfLoads=2
			Make/O/T/N=2 DataNameApp={"AB-","BA-"}	
		break
		case "Q":
			NumOfLoads=4
			Make/O/T/N=4 DataNameApp={"GA-","RA-","AB-","BA-"}		
		break
	endswitch
	SetDataFolder dfSave 
End

//********************************************************************************
//  Options Dialog
//********************************************************************************
Function FCSShowOptions()
	DoWindow/F FCSOptions
	if (V_Flag != 0)
		return 0
	endif
	Execute "FCSOptions()"
End	

Window FCSOptions() :Panel
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	PauseUpdate; Silent 1 // building window...

	NewPanel/W=(300,240,660,380)/K=1 as "Options"

	CheckBox    UseSameWindow, title="Use the same window for all data", fsize=12, font="Arial", pos={10,10}, value=UseSameWindow, proc=OnUseSameWindowCheck
	SetVariable ShortNameStyle,title="Number of directories included in short name",	fsize=12, font="Arial", pos={10,40},size={340,30},frame=1,limits={0,3,1},value=ShortNameStyle
	PopupMenu   WeightMethod, title="Weighting Method", fsize=12, font="Arial", pos={2, 70}
	PopUpMenu   WeightMethod, mode=(WeightMethod+1), value="No Weight;Koppel's Formula;Statistical Stdev", proc=OnSelectWeightMethod
	Button      OptionsOK, title="OK", fsize=12, font="Arial", pos={120, 100}, size={120,30}, proc=OnOptionsOKClick
	SetDataFolder dfSave
End

Function OnUseSameWindowCheck(ctrlName, Checked) :CheckBoxControl
	String CtrlName
	Variable Checked
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	NVAR LoadedCount=root:FCS:LoadedCount
	NVAR DispCurrent=root:FCS:DispCurrent
	NVAR DLast=root:FCS:DLast

	Variable i
	Variable SaveDispCurrent=DispCurrent

	if(UseSameWindow==0&&Checked==1)
		for(i=0;i<=DLast;i+=1)
			DoWindow/K $(GetGraphName(i))
			DoWindow/K $(GetResidName(i))
			DoWindow/K $(GetTableName(i))
			DoWindow/K $(GetIntensityName(i))						//YH
		endfor
		UseSameWindow=1
		FCSShowData(DispCurrent)
	elseif(UseSameWindow==1&&Checked==0)
		DoWindow/K $(GetGraphName(DispCurrent))
		DoWindow/K $(GetResidName(DispCurrent))
		DoWindow/K $(GetTableName(DispCurrent))
		DoWindow/K $(GetIntensityName(DispCurrent))					//YH
		UseSameWindow=0
		for(i=0;i<=DLast;i+=1)
			FCSShowData(i)
		endfor
	endif
	DispCurrent=SaveDispCurrent
	FCSB2F(DispCurrent)
End

Function OnSelectWeightMethod(ctrlName, popNum, popString) : PopupMenuControl
	String ctrlName, popString
	Variable popNum
	
	NVAR WeightMethod=root:FCS:WeightMethod
	
	WeightMethod=popNum-1 
	
End	
	
Function OnOptionsOKClick(ctrlName)
	String ctrlName
	DoWindow/K FCSOptions
end

//********************************************************************************
//  File Loading and Formating
//********************************************************************************

Function FCSOpenFilename()							//Let the user chose the path and filename
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	SVAR PathName, FileName
	NVAR NumberofDigits
	String tempName, FormatString=""
	
	Variable refNum
	PathInfo /S PathName			//Set the path used in open to PathName
	Open /D/R/M="Choose any of the files in the directory..."/T=".sin"/Z refNum as PathName+":*.sin"		//Show the open file dialog

	Variable 	Len=strlen(S_FileName)
	if(V_flag==0&&Len>0)						//If the dialog is not canceled
		Variable i=0,j=0,k=0
		for(i=0;i<Len;i+=1)				//Counting directory seperator ':'
			if(!cmpstr(S_FileName[i],":"))
				j=i
			endif
		endfor
		PathName=S_FileName[0,j-1]	//Get path name
		
		for(i=j;i<Len;i+=1)			//The extension name is the characters after the last '.'
			if(!cmpstr(S_FileName[i],"."))
				k=i
			endif
		endfor
		if(k==0)						//if no extension name
			k=Len
		endif
		FileName=S_FileName[j+1,k-1]	//Get file name, delete the last characters which is user for listing
		for(i=strlen(FileName)-1;i>=0;i-=1)
			if(char2num(FileName[i])<char2num("0")||char2num(FileName[i])>char2num("9"))
				j=i
				break
			endif
		endfor
		NumberofDigits=strlen(FileName)-j-1
		FileName=FileName[0,j]
	endif
	
	SetDataFolder dfSave
End

//********************************************						//Zeiss ConfoCor data loading  // by Xiaotao on 20060920
Function ConfoCorOpenFilename()							//Let the user chose the path and filename
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	SVAR PathName, FileName
	String tempName, FormatString=""
	
	Variable refNum
	PathInfo /S PathName			//Set the path used in open to PathName
	Open /D/R/M="Chose any of the files in the directory..."/T=".fcs"/Z refNum as PathName+":*.fcs"		//Show the open file dialog

	Variable 	Len=strlen(S_FileName)
	if(V_flag==0&&Len>0)						//If the dialog is not canceled
		Variable i=0,j=0,k=0
		for(i=0;i<Len;i+=1)				//Counting directory seperator ':'
			if(!cmpstr(S_FileName[i],":"))
				j=i
			endif
		endfor
		PathName=S_FileName[0,j-1]	//Get path name
		
		for(i=j;i<Len;i+=1)			//The extension name is the characters after the last '.'
			if(!cmpstr(S_FileName[i],"."))
				k=i
			endif
		endfor
		if(k==0)						//if no extension name
			k=Len
		endif
		FileName=S_FileName[j+1,k-1]	

	endif
	
	SetDataFolder dfSave
End



//********************************************
Function FCSLoadFiles(Path, File, First, Last)			//Load a series of files
	String Path, File
	Variable First, Last
	
	String FileName
	NVAR NumberofDigits=root:FCS:NumberofDigits
	NVAR UseSameWindow=root:FCS:UseSameWindow
	NVAR DLast=root:FCS:DLast
	NVAR NumOfLoads=root:FCS:NumOfLoads
	NVAR NumOfRuns=root:FCS:NumOfRuns
	NVAR DCurrent=root:FCS:DCurrent
	
	Variable i, k, LoadCount=0
	
		if(NumberofDigits==0)									//Load a single file with full name provided
			For(k=1;k<=NumOfLoads;k+=1)
				NumOfRuns=k
				sprintf FileName,"%s:%s.sin",Path,File
				LoadCount+=FCSLoad(FileName)
			EndFor
		else													//A series of files
			For(k=1;k<=NumOfLoads;k+=1)
				NumOfRuns=k
				For(i=First;i<=Last;i+=1)
					sprintf FileName,"%s:%s%0"+num2str(NumberofDigits)+"d.sin",Path,File,i
					if(FCSLoad(FileName)) //intervene here for several loads
						LoadCount+=1
						if(!UseSameWindow)
							FCSShowData(DLast)
						endif
					endif
				EndFor
			EndFor
		endif	
	
	If(LoadCount==0)										//Print summary
		Print "No file loaded"
	Elseif(LoadCount==1)
		Print "1 file loaded"
	Else
		Print LoadCount/NumOfLoads, "experiment files loaded"
		Print LoadCount, "data files loaded"
	Endif
	
		FCSB2F(DCurrent)
	
End

//**************************************
Function FCSLoadAll(PathName)							//Load all the .sin file in one directory
	String PathName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NewPath/O/Q DataFolder PathName
	variable i,j,k=0,LoadCount=0
	String FileList
	NVAR UseSameWindow, DLast,DCurrent
	NVAR NumOfLoads=root:FCS:NumOfLoads			//YH
	NVAR NumOfRuns=root:FCS:NumOfRuns			//YH
	
	FileList=IndexedFile(DataFolder,-1,".sin")			//Counting files
	for(i=0;i<strlen(FileList);i+=1)
		if(!cmpstr(FileList[i],";"))
			j+=1
		endif
	endfor
	if(j==0)
		Print "No file in the folder"
	else
		Make/O/T/N=(j) FolderFileList
		for(i=0;i<j;i+=1)									//Creat file list
			FolderFileList[i]=IndexedFile(DataFolder,i,".sin")
		endfor
		
		Sort FolderFileList, FolderFileList				//Sort filelist
		
		For(k=1;k<=NumOfLoads;k+=1)			//YH
				NumOfRuns=k					//YH
			for(i=0;i<j;i+=1)									//Load files
				if(FCSLoad(PathName+":"+FolderFileList[i]))
					LoadCount+=1
					if(!UseSameWindow)
						FCSShowData(DLast)
					endif
				endif
			endfor
		endfor									//YH
	endif			
	
	
	If(LoadCount==0)										//Print summary
		Print "No file loaded"
	elseif(LoadCount==1)
		Print "1 file loaded"
	else
		Print LoadCount, "files loaded"
	endif
	
	FCSShowData(DCurrent)

	KillWaves/Z FolderFileList
	SetDataFolder dfSave
End



//**************************************											// by Xiaotao on 20060919
Function ConfoCorLoad(PathName, FileName)								//Load a single Zeiss ConfoCor3 file
	String PathName, FileName
	
	String tmpfn
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR XStart, XEnd
	NVAR DModel
	NVAR DMax,DEnd, DLast, LoadedCount
	NVAR NumOfLoads, NumOfRuns
	WAVE/T DataNameIndex, FileNameIndex, ModelNameIndex, ModelList, DataNameApp
	WAVE   DataNumIndex,IsValid, ModelIndex, Intensity1, Intensity2, AcquisitionTime
	
	Variable SLoadedNum //single loaded data number
		
	XStart = 3; XEnd=163										//Initiate start and end point
	
	switch (NumOfLoads)
		case 1:
			Make/O/T/N=1 DataNameApp={"SA-"}
			SLoadedNum = 8
			break
		case 2:
			Make/O/T/N=2 DataNameApp={"RA-","GA-"}
			SLoadedNum = 16
			break
		case 4:
			Make/O/T/N=4 DataNameApp={"RA-","GA-","AB-","BA-"}
			SLoadedNum = 20
			break
	endswitch
	
	LoadWave/Q/D/G/N=TempLoadedData PathName+":"+FileName+".fcs"			//Load correlation data and intensity
	String LoadedWaves = WaveList ("TempLoadedData*",";","")
	Variable LoadedNum = ItemsInList(LoadedWaves)
	Variable MultipleRunNum = LoadedNum / SLoadedNum
	Variable flag_LoadedNum = mod(LoadedNum, SLoadedNum)
	
	Variable i, j
	String TmpWaveName, tmpString
	String acf_ch1, acf_ch2, ccf_ch1ch2	, ccf_ch2ch1, int_ch1, int_ch2
	String XDat, YDat, i1dat, i2dat, xidat
	String SeqFileName, tmpFileName
	WAVE/Z TempLoadedData0, TempLoadedData2
	
	if (flag_LoadedNum)
																				//Check if the assigned load mode fits with the number of data
		for(i=0;i<LoadedNum;i+=1)
			tmpString ="TempLoadedData"+num2str(i)
			KillWaves/Z $tmpString
		endfor
		print "Data Loading Error: the number is inconsistent with loading mode"
	
	else																		// Start loading...
		
		Variable CutScale = 100
		Make/O/N=(numpnts(TempLoadedData2)) taufile=TempLoadedData2							//TempLoadedData2: the wave with correlation time
		Variable min_pnts = min(numpnts(TempLoadedData0),numpnts(TempLoadedData8)) / CutScale		//TempLoadedData0 & 8: the intensity files for Ch1 and Ch2, cut short the intensity trace raw data
		Make/O/N=(min_pnts) timefile=TempLoadedData0(p*CutScale)
		
		for (j=0; j<NumOfLoads; j+=1)
			for (i=0; i<MultipleRunNum; i+=1)	
				LoadedCount+=1
				SeqFileName = FileName + "-" + num2str(i)
				
				XDat="X_"+num2str(LoadedCount)							//Create memory data set
				YDat="Y_"+num2str(LoadedCount)
				Make/O/N=(numpnts(taufile)) $XDat, $YDat
				WAVE XData=$XDat										//Multi-tau calculated timeseries
				WAVE YData=$YDat										//Correlation Function data
				XData = taufile
				
				int_ch1 = "TempLoadedData" + num2str(SLoadedNum*i+1)			//Load Intensity Data
				if (NumOfLoads==1)
					int_ch2 = int_ch1
				else
					int_ch2 =  "TempLoadedData" + num2str(SLoadedNum*i+9)
				endif
				WAVE IntensityCh1 = $int_ch1
				WAVE IntensityCh2 = $int_ch2
				i1dat="I1_"+num2str(LoadedCount)					//Create memory data set
				i2dat="I2_"+num2str(LoadedCount)				
				xidat="XI_"+num2str(LoadedCount)
				Make/O/N=(min_pnts) $i1dat,$i2dat,$xidat
				WAVE I1Data=$i1dat
				WAVE I2Data=$i2dat
				WAVE XIData=$xidat
				XIData=timefile											// Intensity Timeserie File
				I1Data=IntensityCh1[p*CutScale]
				I2Data=IntensityCh2[p*CutScale]
	
				switch (NumOfLoads)									
					case 1:														//NumOfLoads=1; AA 
						XEnd=163
						acf_ch1 = "TempLoadedData" + num2str(SLoadedNum*i+3)
						WAVE WacfCh1 = $acf_ch1
						YData = WacfCh1
						tmpFileName=DataNameApp[0]+SeqFileName
						break
					
					case 2:	
						switch(j)													//NumOfLoads=2; AA BB
							case 0:
								acf_ch1 = "TempLoadedData" + num2str(SLoadedNum*i+3)
								WAVE WacfCh1 = $acf_ch1
								YData = WacfCh1
								tmpFileName=DataNameApp[0]+SeqFileName
								break
							case 1:
								acf_ch2 = "TempLoadedData" + num2str(SLoadedNum*i+11)
								WAVE WacfCh2 = $acf_ch2
								YData = WacfCh2
								tmpFileName=DataNameApp[1]+SeqFileName
								break
						endswitch	
						break
					
					case 4:			
						switch(j)													//NumOfLoads=4; AA BB AB BA
							case 0:
								acf_ch1 = "TempLoadedData" + num2str(SLoadedNum*i+3)
								WAVE WacfCh1 = $acf_ch1
								YData = WacfCh1
								tmpFileName=DataNameApp[0]+SeqFileName
								break
							case 1:
								acf_ch2 = "TempLoadedData" + num2str(SLoadedNum*i+11)
								WAVE WacfCh2 = $acf_ch2
								YData = WacfCh2
								tmpFileName=DataNameApp[1]+SeqFileName
								break
							case 2:
								ccf_ch1ch2 = "TempLoadedData" + num2str(SLoadedNum*i+17)
								WAVE WccfCh1Ch2 = $ccf_ch1ch2
								YData = WccfCh1Ch2
								tmpFileName=DataNameApp[2]+SeqFileName
								break
							case 3:
								ccf_ch2ch1 = "TempLoadedData" + num2str(SLoadedNum*i+19)
								WAVE WccfCh2Ch1 = $ccf_ch2ch1
								YData = WccfCh2Ch1
								tmpFileName=DataNameApp[3]+SeqFileName
								break
						endswitch
						break
				endswitch
												
				DLast+=1
				FCSUpdateDLast()
				
				FileNameIndex[DLast] =FileName						//Set the data index
				DataNameIndex[DLast] =tmpFileName
				DataNumIndex[DLast]  =LoadedCount
				IsValid[DLast]       =1
				WaveStats/Q I1Data							//Average intensity A
				Intensity1[DLast]    =V_avg
				WaveStats/Q I2Data							//Average intensity B
				Intensity2[DLast]    =V_avg
				WaveStats/Q XIData
				AcquisitionTime[DLast]=V_max
				ModelIndex[DLast]    =DModel
				ModelNameIndex[DLast]=ModelList[DModel]
				
				FCSCreatFittingParameters(DLast, LoadedCount, DModel)

				DEnd=DLast												//Expand the selected range
				UpdateDPointersDisplay()
								
			endfor				//endfor for j
		endfor					//endfor for i
		
		KillWaves/Z taufile, timefile
		for(i=0;i<LoadedNum;i+=1)
			tmpString ="TempLoadedData"+num2str(i)
			KillWaves/Z $tmpString
		endfor	
	
	endif

	SetDataFolder dfSave
	return 1
End


//**************************************
Function FCSLoad(FileName)								//Load a single file
	String FileName
	
	String tmpfn
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR DModel
	NVAR DMax,DEnd, DLast, LoadedCount
	NVAR NumOfLoads=root:FCS:NumOfLoads 
	NVAR NumOfRuns=root:FCS:NumOfRuns
	WAVE/T DataNameIndex, FileNameIndex, ModelNameIndex, ModelList, DataNameApp
	WAVE   DataNumIndex,IsValid, ModelIndex, Intensity1, Intensity2, AcquisitionTime, ValidColumns
	
	If (DLast>=DMax-1)										//Data number control
		Print "Exceed maximum data number of", DMax
		SetDataFolder dfSave
		return 0
	Endif
	
	Variable i
	Open /R/Z i as FileName									//Test the existence of the file
	if(V_flag!=0)
		Print "Cannot open file", FileName
		SetDataFolder dfSave
		return 0
	endif
	Close i
	
	for(i=0;i<=23;i+=1)
		tmpfn="TempLoadedData"+num2str(i)
		KillWaves/Z $tmpfn
	endfor
	
	if(NumOfLoads==1)
	tmpfn="TempLoadedData"+num2str(ValidColumns[0]-1)
	endif
	if(NumOfLoads==2)
	tmpfn="TempLoadedData"+num2str(ValidColumns[2]-1)
	endif
	if(NumOfLoads==4)
	tmpfn="TempLoadedData"+num2str(ValidColumns[4]-1)
	endif
	
	LoadWave/Q/D/G/N=TempLoadedData FileName 			//Load data and intensity
	if(!WaveExists($tmpfn))									//If file loaded incorrectly
		Print "Error loading file", FileName
		SetDataFolder dfSave
		return 0
	endif

	DLast+=1
	FCSUpdateDLast()
	
	LoadedCount+=1
	
	String ShortName=FCSGetShortName(FileName)
	
	WAVE/Z TempLoadedData0, TempLoadedData1, TempLoadedData2, TempLoadedData3, TempLoadedData4
	WAVE/Z TempLoadedData7, TempLoadedData8, TempLoadedData10, TempLoadedData11, TempLoadedData12
	WAVE/Z TempLoadedData13, TempLoadedData14, TempLoadedData15, TempLoadedData19, TempLoadedData20
	WAVE/Z TempLoadedData21, TempLoadedData22, TempLoadedData23
	
	Make/O/N=(numpnts(TempLoadedData0)) taufile=TempLoadedData0
	
	NVAR XStart, XEnd
	
	if(NumOfLoads==1)		// which waves are necessary
		ShortName=DataNameApp[0]+Shortname
		Make/O/N=(numpnts(TempLoadedData1)) corfile=TempLoadedData1
		Make/O/N=(numpnts(TempLoadedData7)) timefile=TempLoadedData7
		Make/O/N=(numpnts(TempLoadedData8)) intfile1=TempLoadedData8
		Make/O/N=(numpnts(TempLoadedData8)) intfile2=TempLoadedData8

	endif
	if(NumOfLoads==2)
		Make/O/N=(numpnts(TempLoadedData11)) timefile=TempLoadedData11
		Make/O/N=(numpnts(TempLoadedData12)) intfile1=TempLoadedData12
		Make/O/N=(numpnts(TempLoadedData13)) intfile2=TempLoadedData13
		if(NumOfRuns==1)
		ShortName=DataNameApp[0]+Shortname
		Make/O/N=(numpnts(TempLoadedData1)) corfile=TempLoadedData1
		endif
		if(NumOfRuns==2)
		ShortName="B"+DataNameApp[1]+Shortname
		Make/O/N=(numpnts(TempLoadedData2)) corfile=TempLoadedData2
		endif
	endif
	if(NumOfLoads==4)
		Make/O/N=(numpnts(TempLoadedData19)) timefile=TempLoadedData19
		Make/O/N=(numpnts(TempLoadedData20)) intfile1=TempLoadedData20
		Make/O/N=(numpnts(TempLoadedData21)) intfile2=TempLoadedData21
		if(NumOfRuns==1)
		ShortName=DataNameApp[0]+Shortname
		Make/O/N=(numpnts(TempLoadedData1)) corfile=TempLoadedData1
		endif
		if(NumOfRuns==2)
		ShortName=DataNameApp[1]+Shortname
		Make/O/N=(numpnts(TempLoadedData2)) corfile=TempLoadedData2
		endif
		if(NumOfRuns==3)
		ShortName=DataNameApp[2]+Shortname
		Make/O/N=(numpnts(TempLoadedData3)) corfile=TempLoadedData3
		endif
		if(NumOfRuns==4)
		ShortName=DataNameApp[3]+Shortname
		Make/O/N=(numpnts(TempLoadedData4)) corfile=TempLoadedData4

		endif
	endif

	FileNameIndex[DLast] =FileName						//Set the data index
	DataNameIndex[DLast] =ShortName
	DataNumIndex[DLast]  =LoadedCount
	IsValid[DLast]       =1
	WaveStats/Q intfile1							//Average intensity A
	Intensity1[DLast]    =V_avg
	WaveStats/Q intfile2							//Average intensity B
	Intensity2[DLast]    =V_avg
	WaveStats/Q timefile
	AcquisitionTime[DLast]=V_max
	ModelIndex[DLast]    =DModel
	ModelNameIndex[DLast]=ModelList[DModel]
		
	String XDat="X_"+num2str(LoadedCount)					//Create memory data set
	String YDat="Y_"+num2str(LoadedCount)
	
	Make/O/N=(numpnts(TempLoadedData0)) $XDat, $YDat
	WAVE XData=$XDat
	WAVE YData=$YDat
	XData=taufile
	YData=corfile
//Thorsten
	String i1dat="I1_"+num2str(LoadedCount)					//Create memory data set
	String i2dat="I2_"+num2str(LoadedCount)
	String xidat="XI_"+num2str(LoadedCount)
	
	Make/O/N=(numpnts(timefile)) $i1dat,$i2dat,$xidat
	WAVE I1Data=$i1dat
	WAVE I2Data=$i2dat
	WAVE XIData=$xidat
	I1Data=intfile1
	I2Data=intfile2
	XIData=timefile
//Thorsten End
	
	FCSCreatFittingParameters(DLast, LoadedCount, DModel)
//	FCSShowData(DLast)

	DEnd=DLast												//Expand the selected range
	UpdateDPointersDisplay()
	
//	printf "File loaded successfully \"%s \" as \"%s\", DataNumIndex = %d\r",FileName, ShortName, LoadedCount
	KillWaves/Z taufile,corfile,timefile,intfile1,intfile2
	SetDataFolder dfSave
	return 1
End

//********************************
Function/S FCSGetShortName(FName)					//Generate short name from a full name, used for window titles and control panel list
	String FName
	
	NVAR ShortNameStyle=root:FCS:ShortNameStyle
	String SName
	String Dir0, Dir1, Dir2, Dir3, Diri
	Variable i=-1,j=0
	
	do												//Count the number of directories
		i=strsearch(FName, ":", i+1)
		j=j+(i>=0)
	while (i>=0)
	
	String ScanFormat=""							//Generate scanf format string
	for(i=0;i<j-ShortNameStyle;i+=1)				//Directory names to skip
		ScanFormat=ScanFormat+"%*[^:]%*[:]"
	endfor
	for(i=0;i<ShortNameStyle;i+=1)				//Directory names to read
		ScanFormat=ScanFormat+"%[^:]%*[:]"
	endfor
	ScanFormat=ScanFormat+"%[^.]"					//File name with out extension
	
	switch(ShortNameStyle)							//Generate short name
		case 3:
			sscanf FName, ScanFormat, Dir0, Dir1, Dir2, Dir3
			SName=Dir0+"\\"+Dir1+"\\"+Dir2+"\\"+Dir3
			break
		case 2:
			sscanf FName, ScanFormat, Dir0, Dir1, Dir2
			SName=Dir0+"\\"+Dir1+"\\"+Dir2
			break;
		case 1:
			sscanf FName, ScanFormat, Dir0, Dir1
			SName=Dir0+"\\"+Dir1
			break;
		case 0:
			sscanf FName, ScanFormat, Dir0
			SName=Dir0
	endswitch

	return SName
End

//***************************************************
Function FCSCreatFittingParameters(D, NumIndex, Model)		//Creat the fitting parameter waves
	Variable D, NumIndex, Model
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	WAVE/T ModelList
	NVAR DModel
	
	String ParaName="Param_"+num2str(NumIndex)
	String Hold    ="Hold_" +num2str(NumIndex)
	String PValue  ="Value_"+num2str(NumIndex)
	String FErr    ="Error_"+num2str(NumIndex)
	WAVE   Xdat=$("X_"+num2str(NumIndex))
	WAVE   Ydat=$("Y_"+num2str(NumIndex))
	NVAR   XStart, XEnd
	
	
	Variable j,tautmp, Ntmp=1/(YDat(XStart)-1)				//Initial guess value of N and tau
	for (j=XStart;j<XEnd;j+=1)
		if ((Ydat[j])<((Ydat[XStart]-1)/2+1))
			tautmp=Xdat[j]
			break
		endif
	endfor
	
	KillWaves/Z $ParaName, $Hold, $PValue, $FErr

	String ModelName="m"+ModelList[DModel]
	WAVE/T ParaNameFromList=root:FCS:$ModelName
	Make /O/T/N=(numpnts($ModelName)) $ParaName=paraNameFromList	//Parameter name list
	Make /O/D/N=(numpnts($ModelName)) $Hold=0						//Whether to hold this parameter
	Make /O/D/N=(numpnts($ModelName)) $PValue						//Initial value for fitting, assuming 3D_1p model
	Make /O/D/N=(numpnts($ModelName)) $FErr							//Fitting errors
	
	WAVE HoldWave=$Hold
	WAVE PValueWave=$PValue
	HoldWave[numpnts(HoldWave)-2]=1
	PValueWave[0]=Ntmp
	PValueWave[1]=tautmp
	PValueWave[numpnts(PValueWave)-2]=5
	PValueWave[numpnts(PValueWave)-1]=1
	
	
	SetDataFolder dfSave
End

//********************************************************************************
//  Data display
//********************************************************************************
Function /T GetGraphName(DP)					//Name of the data graph window (DP=Data Pointer)
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCSGraph"
	else
		return "Graph_"+num2str(DataNumIndex[DP])
	endif
end

Function /T GetResidName(DP)					//Name of the fitting residue window
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCSResidue"
	else
		return "Residue_"+num2str(DataNumIndex[DP])
	endif
end

Function /T GetTableName(DP)					//Name of the fitting parameter window
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCSTable"
	else
		return "Table_"+num2str(DataNumIndex[DP])
	endif
end

//Thorsten
Function /T GetIntensityName(DP)					//Name of the fitting parameter window
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCSIntensity"
	else
		return "Intensity_"+num2str(DataNumIndex[DP])
	endif
end
//Thorsten End

//*******************************************
Function FCSShowData(Current)						//Create New Data Display
	Variable Current
	
	NVAR dispCurrent=root:FCS:DispCurrent
	NVAR FCCSFront=root:FCS:FCCSFront			//YH
	NVAR FCCSMode=root:FCS:FCCSMode			//YH
	DispCurrent=Current
	FCSCreateGraph(Current)
	FCSUpdateGraph(Current)
	FCSCreateTable(Current)
	FCSUpdateTable(Current)
//Thorsten
	FCSCreateIntensity(Current)
	FCSUpdateIntensity(Current)
//Thorsten End
//YH	
	if(FCCSMode)
		GroupFCCSData(Current)	
		FCCSCreateTable(Current)
		FCCSUpdateTable(Current)	
		FCCSCreateGraph(Current)		
		if(FCCSFront)			
			FCCSUpdateGraph(Current)			
		else
			DoWindow/F $(GetGraphName(Current))
		endif
	endif
//YH
End

//************************************************
Function FCSCreateGraph(Current)				//Create data and residue windows
	Variable Current
	
	WAVE /T DataNameIndex=root:FCS:DataNameIndex
	WAVE    Zeros=root:FCS:Zeros
	String GraphName	=  GetGraphName(Current)
	String ResidueName	=  GetResidName(Current)

	DoWindow/K $GraphName
	Display/W=(5,0,350,220)/K=2			// Create Graph window
	DoWindow/C $GraphName					// Name the graph

	
	DoWindow/K $ResidueName
	Display/W=(5,280,350, 340) /K=2 Zeros as "Residue of "+DataNameIndex[Current]
	DoWindow /C $ResidueName
End

//******************************
Function FCSUpdateGraph(Current)		//paint or repaint Graph windows
	Variable Current
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR XStart, XEnd
	WAVE DataNumIndex, Zeros
	WAVE/T DataNameIndex
	NVAR DispCurrent, UseSameWindow
	
	if(UseSameWindow&&DispCurrent!=Current)
		SetDataFolder dfSave
		return -1
	endif
		
	String DI=num2str(DataNumIndex[Current])
	WAVE   Xdat			=$("X_"    +DI)
	WAVE   Ydat			=$("Y_"    +DI)
	String FitY			=  "FitY_" +DI
	String Residue		=  "Res_"+DI
	String GraphName	=  GetGraphName(Current)
	String ResidueName	=  GetResidName(Current)

	DoWindow/T $GraphName "Graph of "+DataNameIndex(Current)
	RemoveFromGraph /W=$GraphName /Z $("Y_"+DI)
	AppendtoGraph /W=$GraphName YDat vs XDat;DelayUpdate
	if(WaveExists($FitY))															// If is already fitted
		RemoveFromGraph /W=$GraphName/Z $FitY
		AppendtoGraph /W=$GraphName $FitY vs XDat;DelayUpdate					// Display fitted curve
		ModifyGraph/W=$GraphName rgb($FitY)=(0,0,0);DelayUpdate
	endif
	//ModifyGraph notation=0
	ModifyGraph /W=$GraphName log(bottom)=1;DelayUpdate
	WaveStats/Q/R=(XSTart,XEnd) YDat	
	SetAxis /W=$GraphName left V_max-(V_max-V_min)*1.05, (V_max-V_min)*1.05+V_min ;DelayUpdate	
	SetAxis /W=$GraphName bottom XDat[XStart],XDat[XEnd]

	DoWindow/T $ResidueName "Residue of "+DataNameIndex(Current)
	If(WaveExists($Residue))
		RemoveFromGraph /W=$ResidueName /Z $Residue
		AppendtoGraph /W=$ResidueName $Residue vs XDat;DelayUpdate			//Display Residue
		WaveStats/Q/R=(XSTart,XEnd) $Residue
		if(V_max<(-V_Min))
			V_Max=-V_Min
		endif
		SetAxis /W=$ResidueName left -V_max*1.01, V_max*1.01 ;DelayUpdate // Scale both axes		
	endif
	ModifyGraph /W=$ResidueName rgb(Zeros)=(0,0,0);DelayUpdate
	ModifyGraph /W=$ResidueName log(bottom)=1;DelayUpdate
	SetAxis /W=$ResidueName bottom XDat[XStart],XDat[XEnd]

	SetDataFolder dfSave
End

//**************************************
Function FCSCreateTable(Current)
	Variable Current
	
	String TableName	=  GetTableName(Current)

	DoWindow/K $TableName
	Edit/W=(5,360,350,570)/K=2	// Create table with parameters
	DoWindow /C $TableName
	FCSUpdateTable(Current)
End

//*******************************************
Function FCSUpdateTable(Current)		//Display and redraw fitting parameter table
	Variable Current
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	NVAR DispCurrent, UseSameWindow
	if(UseSameWindow&&DispCurrent!=Current)
		SetDataFolder dfSave
		return -1
	endif

	WAVE DataNumIndex
	WAVE/T DataNameIndex
	String DI=num2str(DataNumIndex[Current])
	String ParaName	=  "Param_"+DI
	String Hold			=  "Hold_" +DI
	String PValue		=  "Value_"+DI
	String FErr			=  "Error_"+DI

	String TableName	=  GetTableName(Current)

	DoWindow /F $TableName
	DoWindow /T $TableName "Fitting "+DataNameIndex[Current]
	AppendToTable $ParaName, $Hold, $PValue, $FErr
	Execute "ModifyTable width("+ParaName+")=40"
	Execute "ModifyTable width("+Hold+")=30"
	Execute "ModifyTable width("+FErr+")=80"

	SetDataFolder dfSave
End

//Thorsten
//************************************************
Function FCSCreateIntensity(Current)				//Create data and residue windows
	Variable Current
	
	WAVE /T DataNameIndex=root:FCS:DataNameIndex
	WAVE    Zeros=root:FCS:Zeros
	String IntensityName	=  GetIntensityName(Current)

	DoWindow/K $IntensityName
	Display/W=(360,278,735,378)/K=2			// Create Graph window
	DoWindow/C $IntensityName					// Name the graph

End

//******************************
Function FCSUpdateIntensity(Current)		//paint or repaint Intensity windows
	Variable Current
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR XStart, XEnd
	WAVE DataNumIndex, Zeros
	WAVE/T DataNameIndex
	NVAR DispCurrent, UseSameWindow
	NVAR DCurrent									
		
	if(UseSameWindow&&DispCurrent!=Current)
		SetDataFolder dfSave
		return -1
	endif
		
	String DI=num2str(DataNumIndex[Current])
	WAVE   XDat			=$("XI_"    +DI)
	WAVE   Y1Dat			=$("I1_"    +DI)
	WAVE   Y2Dat			=$("I2_"    +DI)
	String IntensityName	=  GetIntensityName(Current)
	
	
	DoWindow $IntensityName
	if(V_Flag == 1)
		DoWindow/T $IntensityName "Intensity of "+DataNameIndex(Current)
		RemoveFromGraph /W=$IntensityName /Z $("I1_"+DI)
		RemoveFromGraph /W=$IntensityName /Z $("I2_"+DI)
		AppendtoGraph /W=$IntensityName Y1Dat vs XDat;DelayUpdate
		AppendtoGraph /W=$IntensityName Y2Dat vs XDat;DelayUpdate
//YH				
		if (stringmatch(DataNameIndex(DCurrent),"S*")==1)								//Check if SA/SC or Quad mode and modify colours of the intensity traces
			ModifyGraph/W=$IntensityName rgb($("I2_"+DI))=(20000,20000,65000);DelayUpdate
		else
			ModifyGraph/W=$IntensityName rgb($("I1_"+DI))=(0,65000,0);DelayUpdate
			ModifyGraph/W=$IntensityName rgb($("I2_"+DI))=(65000,0,0);DelayUpdate				
		endif																	
//YH		
		WaveStats/Q Y2Dat
		if(V_avg == 0)
			WaveStats/Q Y1Dat
			SetAxis/W=$IntensityName left, V_min, V_max
		else
			SetAxis/W=$IntensityName /A
		endif
	endif
	
	SetDataFolder dfSave
End

//Thorsten End

//*****************************
Function FCSB2F(Current)						//Bring a data display to the front
	Variable Current
	
	WAVE DataNumIndex=root:FCS:DataNumIndex
	NVAR DispCurrent=root:FCS:DispCurrent
	NVAR UseSameWindow=root:FCS:UseSameWindow
	NVAR DLast=root:FCS:DLast
	NVAR FCCSFront=root:FCS:FCCSFront
	
	if(UseSameWindow&&DispCurrent!=Current)
		if(DispCurrent==-1)
			if(DLast>=0)
				FCSShowData(Current)
			endif
		else
			FCSB2FGraph_Table(Current)
		endif
	endif
	DispCurrent=Current
//YH	
	if(FCCSFront==1)
		DoWindow/F $(GetGraphName2(Current))
	else
		DoWindow/F $(GetGraphName(Current))
	endif
//YH
	DoWindow/F $(GetResidName(Current))
	DoWindow/F $(GetTableName(Current))
	DoWindow/F $(GetIntensityName(Current))	
	DoWindow/F $(GetTableName2(Current))			//YH
End


//*******************************
Function FCSB2FGraph_Table(Current)					// Change the current displayed (used only when UseSameWindow=1)
	Variable Current
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE DataNumIndex
	NVAR DispCurrent
	WAVE/T DataNameIndex							//YH
	
	String Y=num2str(DataNumIndex[DispCurrent])
	String YDat="Y_"+Y
	String FitY="FitY_"+Y
	String Res="Res_"+Y
	String I1="I1_"+Y
	String I2="I2_"+Y
	
	RemoveFromGraph /W=$(GetGraphName(DispCurrent)) /Z $YDat
	RemoveFromGraph /W=$(GetGraphName(DispCurrent)) /Z $FitY
	RemoveFromGraph /W=$(GetResidName(DispCurrent)) /Z $Res
	DoWindow $(GetIntensityName(DispCurrent))
	if(V_Flag == 1)
		RemoveFromGraph /W=$(GetIntensityName(DispCurrent)) /Z $I1
		RemoveFromGraph /W=$(GetIntensityName(DispCurrent)) /Z $I2
	endif
	
	String ParaName	=  "Param_"+Y
	String Hold			=  "Hold_" +Y
	String PValue		=  "Value_"+Y
	String FErr			=  "Error_"+Y
	
	DoWindow /F $(GetTableName(DispCurrent))
	RemoveFromTable $ParaName, $Hold, $PValue, $FErr
//YH
	NVAR FCCSMode
	if(FCCSMode)
		if(stringmatch(DataNameIndex(Current),"S*")==0)		
			GroupFCCSData(DispCurrent)	
			WAVE FCCSGroupNum
			DoWindow /F $(GetTableName2(DispCurrent))	
							
			if(FCCSGroupNum[0]!=-1)						
				String Y1=num2str(DataNumIndex[(FCCSGroupNum[0])])					//Remove previous result from FCCS graph and table
				String YDat1="Y_"+Y1
				String FitY1="FitY_"+Y1			
				String PValue1		=  "Value_"+Y1
				String ParaName1	="Param_"+Y1
				RemoveFromGraph /W=$(GetGraphName2(DispCurrent)) /Z $YDat1,$FitY1
				RemoveFromTable $ParaName1,$PValue1
			endif
			if(FCCSGroupNum[1]!=-1)		
				String Y2=num2str(DataNumIndex[(FCCSGroupNum[1])])	
				String YDat2="Y_"+Y2
				String FitY2="FitY_"+Y2			
				String PValue2		=  "Value_"+Y2
				String ParaName2	="Param_"+Y2
				RemoveFromGraph /W=$(GetGraphName2(DispCurrent)) /Z $YDat2,$FitY2
				RemoveFromTable $ParaName2,$PValue2
			endif
			if(FCCSGroupNum[2]!=-1)	
				String Y3=num2str(DataNumIndex[(FCCSGroupNum[2])])	
				String YDat3="Y_"+Y3
				String FitY3="FitY_"+Y3
				String PValue3		=  "Value_"+Y3
				String ParaName3	="Param_"+Y3
				RemoveFromGraph /W=$(GetGraphName2(DispCurrent)) /Z $YDat3,$FitY3
				RemoveFromTable $ParaName3,$PValue3
			endif
			if(FCCSGroupNum[3]!=-1)	
				String Y4=num2str(DataNumIndex[(FCCSGroupNum[3])])	
				String YDat4="Y_"+Y4
				String FitY4="FitY_"+Y4
				String PValue4		=  "Value_"+Y4
				String ParaName4	="Param_"+Y4
				RemoveFromGraph /W=$(GetGraphName2(DispCurrent)) /Z $YDat4,$FitY4
				RemoveFromTable $ParaName4,$PValue4
			endif
			
			GroupFCCSData(Current)						//Get current 4 FCCS file location to be used in later functions	
		
		else
			DoWindow /K $(GetGraphName2(DispCurrent))
			DoWindow /K $(GetTableName2(DispCurrent))
			DoWindow /K FCCSPanel
			FCCSMode=0
		endif
	endif	
//YH

	DispCurrent=Current
	FCSUpdateGraph(Current)
	FCSUpdateTable(Current)
	FCSUpdateIntensity(Current)

//YH	
	NVAR FCCSFront
	if(FCCSMode)
		FCCSUpdateTable(Current)
		if(FCCSFront)
			FCCSUpdateGraph(Current)
		endif
	endif
//YH		
	SetDataFolder dfSave
End

//*********************************// YH
Function OnVolCaliClick(ctrlName) : ButtonControl
	String ctrlName
	
	DoWindow/F VolCaliControl
	if (V_Flag != 0)
		return 0
	endif
	Execute "VolCaliControl()"
End

//*********************************			//by Yong Hwee Foo on 20091015
Window VolCaliControl() : Panel	//Creates a window for the calc of Veff / conc during dye calibration
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	PauseUpdate; Silent 1 // building window...
	
	Variable/G DiffCoe
	Variable/G TauDiff
	Variable/G Kstr
	Variable/G AveN
	
	NewPanel/W=(450,500,645,730)/K=1 as "Effective Vol."
	
	GroupBox FCSValuesInput pos={8,3}, title="Input values", fsize=11, size={180,110}, fColor=(0,0,65535), fstyle=001, font="Arial"
	SetVariable AveN title="N", bodyWidth=95, pos={130,25}, fsize=12, font="Arial", value=AveN, limits={0,Inf,0.1}
	SetVariable DiffCoe title="D (µm≤/s)", bodyWidth=95, pos={130,45}, fsize=12, font="Arial", value=DiffCoe, limits={0,Inf,1}
	SetVariable TauD title="TauD (s)", bodyWidth=95, pos={130,65}, fsize=12, font="Arial", value=TauDiff, limits={0,Inf,0.000001}
	SetVariable Kstr title="K", bodyWidth=95, pos={130,85}, fsize=12, font="Arial", value=Kstr, limits={0,Inf,0.1}
	
	GroupBox FCSValuesOutput pos={8,115}, title="Output values", fsize=11, size={180,110}, fColor=(0,0,65535), fstyle=001, font="Arial"
	ValDisplay Wradius title="w0 (µm)", bodyWidth=95, pos={130,135}, fsize=12, font="Arial",disable=2, frame=5
	ValDisplay Wradius value=(root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5					//Calc the laser radius w0
	ValDisplay Zaxial title="z0 (µm)", bodyWidth=95, pos={130,155}, fsize=12, font="Arial", disable=2, frame=5
	ValDisplay Zaxial value=((root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5)*root:FCS:Kstr		//Calc the laser axial distance z0
		
	ValDisplay Veff title="Veff (fL)", bodyWidth=95, pos={130,175}, fsize=12, font="Arial", disable=2, frame=5
	ValDisplay Veff value=(Pi^(3/2))*(((root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5)^2)*((root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5)*root:FCS:Kstr		//Calc the Veff
	ValDisplay Conc title="Conc (M)", bodyWidth=95, pos={130,195}, fsize=12, font="Arial", disable=2, frame=5, value=123
	ValDisplay Conc value=root:FCS:AveN/(6.0221415e23*(Pi^(3/2))*(((root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5)^2)*((root:FCS:TauDiff*4*root:FCS:DiffCoe)^0.5)*root:FCS:Kstr*1e-15)	//Calc the Concentration
	
	SetDataFolder dfSave
End

//*******************************************

//********************************************************************************
//  Memory data management
//********************************************************************************

Function FCSUpdateDLast()								//Called when DLast is changed
	NVAR   DLast         =root:FCS:DLast
	NVAR   DEnd          =root:FCS:DEnd
	NVAR   DCurrent      =root:FCS:DCurrent
	WAVE   DataNumIndex  =root:FCS:DataNumIndex
	WAVE/T DataNameIndex =root:FCS:DataNameIndex
	WAVE/T FileNameIndex =root:FCS:FileNameIndex
	WAVE   Intensity1    =root:FCS:Intensity1
	WAVE   Intensity2    =root:FCS:Intensity2
	WAVE   IsValid       =root:FCS:IsValid
	WAVE   SelectionIndex=root:FCS:SelectionIndex
	WAVE   ModelIndex    =root:FCS:ModelIndex
	WAVE/T ModelNameIndex=root:FCS:ModelNameIndex
	WAVE   FitResults    =root:FCS:FitResults
	
	Redimension/N=(DLast+1)    DataNumIndex			//Redimension data indexes
	Redimension/N=(DLast+1)    DataNameIndex
	Redimension/N=(DLast+1)    FileNameIndex
	Redimension/N=(DLast+1)    Intensity1
	Redimension/N=(DLast+1)    Intensity2
	Redimension/N=(DLast+1)    AcquisitionTime
	Redimension/N=(DLast+1)    IsValid
	Redimension/N=(DLast+1)    SelectionIndex
	Redimension/N=(DLast+1)    ModelIndex
	Redimension/N=(DLast+1)    ModelNameIndex
	Redimension/N=(DLast+1)    Chis
	Redimension/N=(DLast+1,20) FitResults
	
	if(DEnd>DLast)										//Reset data pointers
		DEnd=DLast
	endif
	if(DCurrent>DLast)
		DCurrent=DLast
	endif
	if(DLast==-1)										//When no data
		DCurrent=0
		DEnd=0
	endif
	UpdateDPointersDisplay()
End
	
//**************************************
Function FCSResetModel(DataNum, ModelNum, ResetPara)			//Reset the fitting mode for
	Variable DataNum, ModelNum, ResetPara
	
	WAVE DataNumIndex=root:FCS:DataNumIndex, ModelIndex=root:FCS:ModelIndex
	WAVE/T ModelNameIndex=root:FCS:ModelNameIndex
	WAVE/T ModelList=root:FCS:ModelList
	
	WAVE/T NewModel=root:FCS:$("m"+ModelList[ModelNum])
	WAVE/T ParaName=root:FCS:$("Param_"+num2str(DataNumIndex[DataNum]))
	WAVE   Hold    =root:FCS:$("Hold_" +num2str(DataNumIndex[DataNum]))
	WAVE   PValue  =root:FCS:$("Value_"+num2str(DataNumIndex[DataNum]))
	WAVE   PErr    =root:FCS:$("Error_"+num2str(DataNumIndex[DataNum]))

	Redimension /N=(numpnts(NewModel)) ParaName		//Redimension parameter list
	Redimension /N=(numpnts(NewModel)) Hold
	Redimension /N=(numpnts(NewModel)) PValue
	Redimension /N=(numpnts(NewModel)) PErr
	ParaName=NewModel								//Update parameter names
	if(ResetPara)
		PValue[numpnts(PValue)-2]=5						//Cannot do so because FCSFit uses this function to reset the model of the coming data
		PValue[Numpnts(PValue)-1]=1
		Hold=0
		Hold[numpnts(Hold)-2]=1
		Hold[numpnts(Hold)-1]=0
	endif
	
	ModelNameIndex[DataNum]=ModelList[ModelNum]		//Update data index
	ModelIndex[DataNum]=ModelNum
End
	
	
//*******************************
Function FCSNextValidData(Current)    //Return a pointer for the next valid data
	Variable Current
	NVAR DLast=root:FCS:DLast
	WAVE IsValid=root:FCS:IsValid
	
	if(Current<0||Current>=DLast)		//Check parameter validaty
		return -1
	endif
	
	do									//Find the next valid data
		Current+=1
		if(Current>DLast)
			return -1
		endif
		if(IsValid[Current])
			return Current
		endif
	while(1)
End

Function FCSPrevValidData(Current)	//Return a pointer for the previous valid data
	Variable Current
	NVAR DLast=root:FCS:DLast
	WAVE IsValid=root:FCS:IsValid
	
	if(Current<=0||Current>DLast)		//Check parameter validaty
		return -1
	endif
	do									//Find the previoud valid data
		Current-=1
		if(Current<0)
			return -1
		endif
		if(IsValid[Current])
			return Current
		endif
	while(1)
End

Function FCSNumofValidData(NStart, NEnd)	//Count the number of valid data between two pointers
	Variable NStart, NEnd
	NVAR DLast=root:FCS:DLast
	WAVE IsValid=root:FCS:IsValid
	
	if(NStart<0||NEnd<0||NStart>DLast||NEnd>DLast||NStart>NEnd)	//Check parameter validaty
		return -1
	endif	
	
	Variable s=0
	Variable i=NStart
	if(IsValid[i])							//If the first data is valid
		s=1
	Endif
	do										//Search until NEnd
		i=FCSNextValidData(i)
		if(i<0||i>NEnd)
			return s
		endif
		s+=1
	while(1)
End

//********************************
Function FCSKillData(KStart, KEnd)	//Kill a set of data
	Variable KStart, KEnd
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR   DLast, DCurrent, DispCurrent
	WAVE   DataNumIndex
	WAVE/T DataNameIndex
	WAVE/T FileNameIndex
	WAVE   Intensity1
	WAVE   Intensity2
	WAVE   IsValid
	WAVE   SelectionIndex
	WAVE   ModelIndex
	WAVE/T ModelNameIndex
	WAVE   FitResults
//NVAR UseSameWindow

	if(KEnd>DLast||KEnd<KStart||KStart<0)		//Check parameter validaty
		Print "Parameter error when calling FCSKillData(", KStart, "," , KEnd, ")"
		SetDataFolder dfSave
		return -1
	endif

	Variable i,j
	String Y
	
	for(i=KStart;i<=KEnd;i+=1)		//Kill corresponding waves and windows
		Y=num2str(DataNumIndex[i])
//		if(!UseSameWindow)
		DoWindow /K $(GetGraphName(i))
		DoWindow /K $(GetTableName(i))
//YH
		DoWindow /K $(GetGraphName2(i))
		DoWindow /K $(GetTableName2(i))
//YH		
		DoWindow /K $(GetResidName(i))
		DoWindow /K $(GetIntensityName(i))
//		endif
		KillWaves   $("Param_" +Y)
		KillWaves   $("Hold_"  +Y)
		KillWaves   $("Value_" +Y)
		KillWaves   $("Error_" +Y)
		KillWaves   $("X_"     +Y)
		KillWaves   $("Y_"     +Y)
		KillWaves/Z $("FitY_"  +Y)
		KillWaves/Z $("Res_"   +Y)
		KillWaves/Z $("I1_"   +Y)
		KillWaves/Z $("I2_"   +Y)
		KillWaves/Z $("XI_"   +Y)
	endfor	

	for(i=0;i<DLast-KEnd;i+=1)		//Delete data index entries
		FileNameIndex[KStart+i] =FileNameIndex[KEnd+i+1]
		DataNameIndex[KStart+i] =DataNameIndex[KEnd+i+1]
		DataNumIndex[KStart+i]  =DataNumIndex[KEnd+i+1]
		IsValid[KStart+i]       =IsValid[KEnd+i+1]
		SelectionIndex[KStart+i]=SelectionIndex[KStart+i+1]
		Intensity1[KStart+i]    =Intensity1[KEnd+i+1]
		Intensity2[KStart+i]    =Intensity2[KEnd+i+1]
		ModelIndex[KStart+i]    =ModelIndex[KEnd+i+1]
		ModelNameIndex[KStart+i]=ModelnameIndex[KEnd+i+1]
		for(j=0;j<20;j+=1)
			FitResults[KStart+i][j]=FitResults[KEnd+i+1][j]
		endfor
	endfor
	
	DLast-=(KEnd-KStart+1)				//Reset data index size
	FCSUpdateDLast()
	if(DLast>=0)
		FCSShowData(DCurrent)
	else
		DispCurrent=-1		
	endif

	SetDataFolder dfSave
End

Function FCSInvalidateFitting(DP)
	Variable DP
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	WAVE DataNumIndex=root:FCS:DataNumIndex
	String Y=num2str(DataNumIndex[DP])
	NVAR DispCurrent=root:FCS:DispCurrent
	NVAR UseSameWindow=root:FCS:UseSameWindow
	
	String FitY="FitY_"+Y
	String Res="Res_"+Y
	
	String Gname=GetGraphName(DP)
	if((!UseSameWindow)||DP==DispCurrent)
		RemoveFromGraph /W=$(GetGraphName(DP)) /Z $FitY
		RemoveFromGraph /W=$(GetResidName(DP)) /Z $Res
	endif
	KillWaves /Z $FitY, $Res					//If fitted, kill the fitted results
	SetDataFolder dfSave
end


//********************************************************************************
//  Fitting
//********************************************************************************

Function FCSFit(FStart, FEnd, Model)
	Variable FStart, FEnd, Model
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE DataNumIndex, FitResults, IsValid, Chis
	WAVE/T ModelList
	NVAR XStart, XEnd, DLast, WeightMethod
	Variable V_FitTol=0.00001													//tolerance for termaination of iteration based on the Chi Sq value (default without this line is 0.001)	//YH
	Variable V_FitMaxIters=100													//max number of iterations (default is 40 without this line)										//YH
	
	WAVE/T StParaName=$("Param_"+num2str(DataNumIndex[FStart]))		//Use the parameters of the first data for fitting all data
	WAVE   StHold    =$("Hold_" +num2str(DataNumIndex[FStart]))
	WAVE   StPValue  =$("Value_"+num2str(DataNumIndex[FStart]))
	
	String FitFunc="mod_"+ModelList[Model]							//Fitting function
	String HoldPara=""
	String Y
	
	If(!IsValid[FStart])
		FStart=FCSNextValidData(FStart)
	endif
	
	if(FStart<0||FStart>FEnd||FEnd>DLast)
		Print "Parameter error or no valid data"
		SetDataFolder dfSave
		return -1
	endif	
	
	Variable i,j, FitCount=0, FreeParameter=0
	
	for (i=0;i<numpnts(StParaName);i+=1)								//Generate held parameter list
		HoldPara=HoldPara+num2str(StHold[i]!=0)
		FreeParameter+=(StHold[i]==0)
	endfor

	Make /O/N=(numpnts($("X_"+num2str(DataNumIndex[FStart])))) WeightWave=1
	Variable UseWeightWave=0		
	
	if(WeightMethod==2&&FCSNumofValidData(FStart, FEnd)>1)			//Statistical stdev as weight
		UseWeightWave=2
		FCSStatWeightWave(FStart, FEnd)
	endif
	
	for(i=FStart;i<=FEnd;i+=1)										//Fit individual data
		if(!IsValid[i])
			continue
		endif
		Y=num2str(DataNumIndex[i])
		FCSResetModel(i,Model,0)										//Reset model (as well as parameter list)
		WAVE Hold  =$("Hold_" +Y)
		WAVE PValue=$("Value_"+Y)
		WAVE PErr  =$("Error_"+Y)
		PValue=StPValue												//Use the guess value of the first data or first fitted data
		Hold=StHold
		WAVE XDat=$("X_"+Y)
		WAVE YDat=$("Y_"+Y)

		String FitYWave="FitY_"+num2str(DataNumIndex[i])				//Create fitting curve and residue wave
		String ResidueWave="Res_"+num2str(DataNumIndex[i])
		Make /O/N=(numpnts(Xdat)) $ResidueWave
		Make /O/N=(numpnts(Xdat)) $FitYWave
		
		if(WeightMethod==1)											//Koppel formula as weight
			UseWeightWave=1
			FCSKoppelWeightWave(i)
		endif
		
		if(UseWeightWave)
			FuncFit /Q/N/M=2/H=HoldPara $FitFunc, PValue, YDat[XStart, XEnd] /X=XDat /I=1  /W=WeightWave //D=$FitYWave /R=$ResidueWave
		else
			FuncFit /Q/N/M=2/H=HoldPara $FitFunc, PValue, YDat[XStart, XEnd] /X=XDat
		endif			
		if(GetRTError(0))												//If there is error in fitting
			KillWaves $FitYWave, $ResidueWave
			Print "Error fitting wave number", i, GetRTErrMessage()
			if(GetRTError(1))
			endif
			break
		endif 
		WAVE M_Covar													//Get fitting error
		PErr=sqrt(M_Covar[p][p])
		
		for(j=0;j<numpnts(StParaName);j+=1)							//Create results list
			FitResults[i][2*j]=PValue[j]
			FitResults[i][2*j+1]=PErr[j]
		endfor
		
		WAVE Residue=$ResidueWave										//Calculate fitted curve and residue for the whole data range
		WAVE FitY=$FitYWave
		for(j=0;j<numpnts(Xdat);j+=1)
			FitY[j]=mod_ALL(Model, PValue, XDat[j])
			Residue[j]=Ydat[j]-FitY[j]
		endfor

		Variable Chi2=0												//Caculate reduced Chi^2
		for(j=XStart;j<=XEnd;j+=1)
			Chi2+=Residue[j]*Residue[j]/WeightWave[j]/WeightWave[j]
		endfor
		if(UseWeightWave==2)
			Chis[i]=Chi2/(XEnd-Xstart+1-FreeParameter)/(FCSNormFactor(i))^2
		else
			Chis[i]=Chi2/(XEnd-Xstart+1-FreeParameter)
		endif
//		printf "Fit data %d, Chi^2=%f\r", i, Chi2

		FitCount+=1
		FCSUpdateGraph(i)												//Update display
	endfor	
	Print FitCount, "data successfully fitted"
	SetDataFolder dfSave
End

//****************************              Calculate Weight
Function FCSKoppelWeightWave(DP)
	Variable DP
	
	WAVE WeightWave=root:FCS:WeightWave
	WAVE Intensity=root:FCS:Intensity1
	WAVE AcquisitionTime=root:FCS:AcquisitionTime
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	WAVE XDat=$("root:FCS:X_"+num2str(DataNumIndex[DP]))
	WAVE YDat=$("root:FCS:Y_"+num2str(DataNumIndex[DP]))
	
	NVAR XStart=root:FCS:XStart, XEnd=root:FCS:XEnd
	
	Variable j,t, mdt, N, M, nn, dt,s1,s2,Gdt,Gmdt
	
	N=1/FCSNormFactor(DP)				//Appoximate value of N and tau
	for (j=XStart;j<XEnd;j+=1)
		if ((Ydat[j])<(0.5/N+1))
			t=Xdat[j]
			break
		endif
	endfor
	
	for(j=XStart;j<=XEnd;j+=1)
		mdt=XDat[j]
		dt=XDat[j]-XDat[j-1]
		M=AcquisitionTime[DP]/dt
		nn=Intensity[DP]*dt
		
		Gdt=1/(1+dt/t)
		Gmdt=1/(1+mdt/t)
		
		s1=((1+Gdt*Gdt)*(1+Gmdt*Gmdt)/(1-Gdt*Gdt)+2*mdt/dt*Gmdt*Gmdt)/M/N/N
		s2=(2*(1+Gmdt*Gmdt)/N/nn+(1+Gmdt/N)/nn/nn)/M
		WeightWave[j]=sqrt(s1+s2)
		
		if(j>XStart&&(WeightWave[j]>WeightWave[j-1]))
			WeightWave[j]=WeightWave[j-1]
		endif
	endfor	
End	

//*************************
Function FCSStatWeightWave(FStart, FEnd)
	Variable FStart, FEnd
	
	Variable NumData=FCSNumofValidData(FStart, FEnd)
	if(NumData<2)
		return -1
	endif
	Make/O/N=(NumData) DList
	
	WAVE IsValid=root:FCS:IsValid
	WAVE DAtaNumIndex=root:FCS:DataNumIndex
	NVAR XStart=root:FCS:XStart
	WAVE WeightWAve=root:FCS:WeightWave
	
	Variable i,j=0
	for(i=FStart;i<=FEnd;i+=1)
		if(IsValid[i])
			DList[j]=i
			j+=1
		endif
	endfor
	
	Make/O/N=(NumData) YStat
	Make/O/N=(NumData) YNorm
	for(i=0;i<NumData;i+=1)
		YNorm[i]=FCSNormFactor(i)								//Normalize factor
	endfor
	for(j=0;j<=numpnts(WeightWave);j+=1)
		for(i=0;i<NumData;i+=1)
			WAVE Ydat=$("Y_"+num2str(DataNumIndex[i]))
			YStat[i]=(YDat[j]-1)/YNorm[i]+1
		endfor
		WaveStats/Q YStat
		WeightWave[j]=V_sdev
	endfor
End
	
//********************************************************************************
//  Normalization
//********************************************************************************

Function FCSNormFactor(Dp)
	Variable Dp
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	WAVE DataNumIndex
	NVAR XStart
	Variable n
	
	WaveStats/Q/R=[XStart, XStart+10] $("Y_"+num2str(DataNumIndex[Dp]))
	n=V_Avg-1
	
	SetDataFolder dfSave
	return n
End

Function FCSNormalize(NStart, NEnd)
	Variable NStart, NEnd
	Variable i
	WAVE DataNumIndex=root:FCS:DataNumIndex
	WAVE IsValid=root:FCS:IsValid
	
	for(i=NStart;i<=NEnd;i+=1)
		if(!IsValid[i])
			continue
		endif
		WAVE Ydat=$("root:FCS:Y_"+num2str(DataNumIndex[i]))
		Ydat=(Ydat(p)-1)/FCSNormFactor(i)+1								//Normalize
		FCSInvalidateFitting(i)
		FCSUpdateGraph(i)
	endfor
End

//********************************************************************************
//  Result Statistics
//********************************************************************************

Function FCSStat(SStart, SEnd)
	Variable SStart, SEnd
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE IsValid, ModelIndex
	WAVE FitResults
	WAVE/T ModelList
	WAVE Intensity1
	WAVE Intensity2
	
	DoWindow /H											//Bring history/command window to the front

	Variable s=FCSNumofValidData(SSTart,SEnd)		//Number of valid data
	
	if(s<2)												//No valid data or only one valid data
		Print "No or not enough valid data selected."
		SetDataFolder dfSave
		return -1
	endif

	Variable i,j,k,ks,MultipleModel=0, NumPara,n,m

	Make /O/N=(s) StatResult
	Make /O/N=10 Avg
	Make /O/N=10 Sdev
			
	
	
	if(!IsValid[SStart])							//Search for the first valid data
		ks=FCSNextValidData(SStart)
	else
		ks=SStart
	endif
	
	WAVE/T ParaName=$("m"+ModelList[ModelIndex[ks]])	
	NumPara=numpnts(ParaName)

	for(j=NumPara;j>=0;j-=1)									//j is for different parameters
		k=ks
		
		for(i=0;i<s;i+=1)								//Copy the valid results into StatResult
			StatResult[i]=FitResults[k][2*j]				
						k=FCSNextValidData(k)
			if(ModelIndex[k]!=ModelIndex[ks])
				MultipleModel=1
			endif
		endfor
			
		WaveStats /Q StatResult						//Do statistics
		Avg[j]=V_avg
		Sdev[j]=V_sdev
	endfor
		
		
		n=NumPara									//Ver 1.21: Do Intensity1 stats
		k=SStart									
	for(i=0;i<s;i+=1)	
			StatResult[i]=Intensity1[k]
			k=FCSNextValidData(k)
		endfor
		WaveStats /Q StatResult						
		Avg[n]=V_avg
		Sdev[n]=V_sdev
		
		m=NumPara+1
		k=SStart
	for(i=0;i<s;i+=1)								//Do Intensity2 stats
			StatResult[i]=Intensity2[k]
			k=FCSNextValidData(k)
		endfor	
		WaveStats /Q StatResult	
		Avg[m]=V_avg
		Sdev[m]=V_sdev
	
	
	Printf "-------------------------------------------------------------\r"
	Printf "Statistics of data %d to %d. Total number of valid data is %d\r", SStart, SEnd, s
	if(MultipleModel)
		Printf "Warning, multiple models used!\r"
	endif
	for(j=0;j<NumPara;j+=1)							//Results output
		printf "%8s: value=%.03e, stdev=%.03e\r", ParaName[j], Avg[j], Sdev[j]
	endfor
			if(Avg[m]==Avg[n] && Sdev[m]==Sdev[n])
			printf " Intensity1=%6.3f, stdev=%6.3f\r",Avg[n],Sdev[n]
			else
			printf " Intensity1=%6.3f, stdev=%6.3f\r",Avg[n],Sdev[n]
			printf " Intensity2=%6.3f, stdev=%6.3f\r",Avg[m],Sdev[m]
			endif
	printf "-------------------------------------------------------------\r"
	
	SetDataFolder dfSave
End	

//********************************************************************************
// Result Table
//********************************************************************************


Function FCSCreateResult()
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	DoWindow/K FCSResult
	Edit/K=2/W=(20,0,700,400) DataNameIndex,Intensity1,Intensity2,AcquisitionTime,IsValid,ModelNameIndex,Chis, FitResults as "FCS Index and Results"
	DoWindow/C FCSResult
//	Execute "ModifyTable title(DataNumIndex)=\"P.I.\", width(DataNumIndex)=23"
	Execute "ModifyTable title(DataNameIndex)=\"File Name\", alignment(DataNameIndex)=2, width(DataNameIndex)=90"
	Execute "ModifyTable title(Intensity1)=\"Intens. A\", width(Intensity1)=40, format(Intensity1)=2"
	Execute "ModifyTable title(Intensity2)=\"Intens. B\", width(Intensity2)=40, format(Intensity2)=2"
	Execute "ModifyTable title(AcquisitionTime)=\"Time\", width(AcquisitionTime)=20, format(AcquisitionTime)=2"
	Execute "ModifyTable title(IsValid)=\"Val.\", alignment(IsValid)=1, width(IsValid)=20"
	Execute "ModifyTable title(ModelNameIndex)=\"Model\", alignment(ModelNameIndex)=0, width(ModelNameIndex)=50"
	Execute "ModifyTable title(Chis)=\"Chi^2\", width(Chis)=40, sigdigits=3, digits=3, rgb=(100,100,100)"
	Execute "ModifyTable alignment(FitResults)=0, width(FitResults)=50, sigdigits=4, digits=3"
	
	FCSUpdateDLast()	//If it is the first time to run, there is no data. However, we must make a wave with at least 1 elements, otherwise
						//the table will not be created. So we reset the number of elements to zero after the table is created.
	
	SetDataFolder dfSave
End

Function FCSB2FResult()
	DoWindow/F FCSResult
End





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//*************************************************************************************************//
//
//			CFcurves_V1.2				bulit on 25/07/2006 by Xiaotao Pan
//			CFcurves_V1.1				built on 30/06/2006 by Xiaotao Pan
//
//************************************************************************************************//
//
//	Version History
//
// 27/10/2006		Auto color assign for all fitting curves
//
// 28/09/2006		Automatic statistics group by filenames. Each group doesn't have the same number of data
//
// 25/07/2006		V1.2
//				FitResults Analysis, average and standard deviation
//
// 30/06/2006		V1.1
//				two functions, DrawACF and NormACF, can be used to list ACF curves 
//				in a single graph and normalize a series of ACF curves
//
//*************************************************************************************************//

Menu "Analysis"
	"ACF Analysis ...", ACFmain()
End


Function ACFmain()
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS
	
	String/G ACFfunc = "NormACF;DrawACF"							// List of function names
	Variable/G tauStartTime=1e-6, tauEndTime=0.1						// Set Start and End time for tau
	Variable/G NumSelectFunc=1										// default selected function
	Variable/G tau_startTime = tauStartTime
	Variable/G tau_endTime = tauEndTime
	
	String/G SelectParam = "", init_prefix="s01"
	Variable/G init_multipleRun=3
	
	DoWindow/K ACFanalysis
	Execute "ACFanalysis()"
	
	SetDataFolder dfSave
End


Window ACFanalysis() : Panel
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Wavestats/Q DataNumIndex
	Variable/G n = V_npnts
	Make/O/D/N=(n) SelACFdataIndex									// SelWave for listbox "ACFdataIndex", 1 for selected, 0 for unselected
	
	Variable/G SelGroupFile = 1
	
	NewPanel/W=(480,500,880,815) as "ACF data analysis"

	// The list normalization of ACF curves
	GroupBox ACFcontrols title="ACF drawing", pos={9,5},size={170,135}, fColor=(0,0,65535), fstyle=011, fsize=11,  font="Arial"
	PopupMenu SelectFunc title="Function", font="Arial",fsize=12, pos={10,25},popColor= (0,65535,65535),value=root:FCS:ACFfunc, proc=OnClickSelectFunc
	SetVariable XStart title="X Start", font="Arial",fsize=12, pos={20,55},size={145,20}, value=tauStartTime,limits={0,Inf,1e-5}, proc=OnClickXStart
	SetVariable XEnd title="X End ", font="Arial",fsize=12, pos={20,80},size={145,20}, value=tauEndTime,limits={0,Inf,1}, proc=OnClickXEnd
	Button DrawCurve title="Draw", pos={20,105},size={60,26}, proc=OnDrawClick
	
	// List of all data
	GroupBox ACFdata title="ACF data", pos={190,5}, size={205,295}, fColor=(0,0,65535), fstyle=011, fsize=11,  font="Arial"
	ListBox ACFdataSel pos={195,20}, size={195, 275}, frame=2, mode=4, listWave=DataNameIndex, selWave=SelACFdataIndex, proc=OnSelectData
	
	// The statistics of FCS fit results
	GroupBox FitParameter title="Fit Parameters", pos={9,145},size={170,165}, fColor=(0,0,65535), fstyle=011, fsize=11,  font="Arial"
	PopupMenu SelectParam title="Select", font="Arial",fsize=12, pos={10,165},popColor= (0,65535,65535),value=root:FCS:SelectParam, proc=OnClickSelectPara
	SetVariable Prefix title="Prefix", font="Arial",fsize=12, pos={20,195},size={145,20}, value=init_prefix,limits={0,Inf,1}, proc=OnClickPreFix
	SetVariable Repetition title="MultipleRun", font="Arial",fsize=12, pos={20,220},size={145,20}, value=init_multipleRun,limits={0,Inf,1}, proc=OnClickMultipleRun
	CheckBox GroupFiles pos={20,247},size={78,15},title="Group by filenames", font="Arial", fsize=12, value=1, mode=0, proc=OnClickGroupFile
	CheckBox SelJoint pos={100,279},size={78,15},title="Joint", font="Arial", fsize=12, value=0, mode=0, proc=OnClickSelJoint
	Button AnalyzeFitResults title="Statistics", pos={20,278},size={60,26}, proc=OnClickStatistics
	
	SetDataFolder dfSave
End


Function OnSelectData(ctrlName,row,col,event)
	String ctrlName     // name of this control
	Variable row        // row if click in interior, -1 if click in title
	Variable col        // column number
	Variable event      // event code
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE SelACFdataIndex = root:FCS:SelACFdataIndex
	WAVE DataNumIndex = root:FCS:DataNumIndex
	Variable/G n
	Variable i=0
	String/G SelectParam
	String NumParamName
	
	if (event==4||event==5)
		for (i=0; i<n; i+=1)
			if (SelACFdataIndex(i)==1)
				NumParamName = "Param_" + num2str(DataNumIndex(i))
				break
			endif
		endfor
		SelectParam = StringNameList($NumParamName)
	endif
	
	SetDataFolder dfSave
	return 0            // other return values reserved
End

Function OnDrawClick(ctrlName) : ButtonControl
	String ctrlName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE SelACFdataIndex = root:FCS:SelACFdataIndex
	WAVE DataNumIndex = root:FCS:DataNumIndex
	WAVE/T DataNameIndex = root:FCS:DataNameIndex
	Variable/G NumSelectFunc, tau_startTime, tau_endTime, n
	Variable i
	String List_ACF="", List_ACFnames=""

	for (i=0; i<n; i+=1)													// If SelACFdataIndex(i)=1, it means that the respective wave is selected
		if (SelACFdataIndex(i) == 1)
			List_ACF += "Y_" + num2str(DataNumIndex(i)) + ";"			// DataNumIndex(i) => Y_i
			List_ACFnames += DataNameIndex(i) + ";"
		endif
	endfor

	switch (NumSelectFunc)											// Call the respective function based on the selection
		case 1:
			NormACF(List_ACF, List_ACFnames, tau_startTime, tau_endTime)
			break
		case 2:
			DrawACF(List_ACF,  List_ACFnames, tau_startTime, tau_endTime)
			break
	endswitch
	
	KillWaves  max_acf,min_acf
		
	SetDataFolder dfSave 
End


Function OnClickSelectFunc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Variable/G NumSelectFunc
	NumSelectFunc = popNum										// Get the number of selected function
	
	SetDataFolder dfSave 
End


Function OnClickXStart (ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable

	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Variable/G tau_startTime
	tau_startTime = varNum											// Set StartTime of tau
	
	SetDataFolder dfSave 
End


Function OnClickXEnd (ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable
	
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Variable/G tau_endTime
	tau_endTime = varNum									// Set EndTime of tau
	
	SetDataFolder dfSave 
End


Function DrawACF (Waves, NofWaves, Xstart, Xend)				// sample: DrawACF("Y_0;Y_1;Y_2", 1e-6, 0.1)
	String Waves, NofWaves
	Variable Xstart, Xend

	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	Variable i=0, j=0, index_Xstart=0, index_Xend=0
	Variable num_wave = ItemsInList(Waves)
	Make/O/D/N=(num_wave) min_acf, max_acf		// waves for storing the min and max peak values of ACF waves
	String Yacf, N_acf, fitY, V_X
	Variable r, g, b, rgbsize=0, rgbremainder=0, rgbstep=floor(65535/(num_wave)*3)				// Auto assgin different color for the fit curves
					
	Display											// Draw a new graph
	TextBox/C/N=LegendACF/F=0/A=RT/J "ACF Curves"			// Creat legend
	//*************************************************************//
	For (i=0; i<num_wave; i+=1)
		Yacf = StringFromList(i, Waves, ";")				// search through all input wave names and do normalization
		N_acf = StringFromList(i, NofWaves, ";")
		fitY = "Fit" + Yacf								// Get the fit data

		V_X = "X_"									// X_00 data
		for (j=2; j<strlen(Yacf); j+=1)
			V_X = V_X + Yacf[j]
		endfor
	
		Wave w_x = $V_X
		Wave w_ACF = $Yacf	
		Wavestats/Q w_x
		//*******************************************************// search for index of Xstart and Xend
		for (j=0; j<V_npnts; j+=1)
			if ((w_x[j] - Xstart) > 0)
				index_Xstart = j-1
				break
			endif
		endfor
		for (j=0; j<V_npnts; j+=1)
			if ((w_x[j] - Xend) > 0)
				index_Xend = j-1
				break
			endif
		endfor
		//***********************************************//
		Wavestats/Q/R=(index_Xstart, index_Xend) w_ACF
		min_acf[i] = V_min
		max_acf[i] = V_max	
		
		AppendToGraph w_ACF, $fitY vs w_x
		rgbremainder = mod(i, 3)
		rgbsize = (i-rgbremainder)/3
		r=0; g=0; b=0
		switch (rgbremainder)
			case 0:
				r = rgbsize + 1
				break
			case 1:
				g = rgbsize + 1
				break
			case 2:
				b = rgbsize + 1
				break
		endswitch
		ModifyGraph rgb($fitY)=(rgbstep*r, rgbstep*g, rgbstep*b)			// modify the line  color of fit curves
		ModifyGraph lsize($fitY)=2
		AppendText/N=LegendACF "\\s("+fitY+")" + N_acf
	Endfor
	
	Wavestats/Q max_acf
	Variable Y_V_max = V_max
	Wavestats/Q min_acf
	Variable Y_V_min = V_min
		
	SetAxis left Y_V_min*0.98, Y_V_max*1.02
	SetAxis bottom Xstart, Xend
	ModifyGraph log(bottom)=1, mirror=2, axOffset(bottom)=0.5, width=288,height=216
	ModifyGraph btLen(left)=4,stLen(left)=2, btLen(bottom)=4,stLen(bottom)=2
	
	Label left "\\Z14G(\\F'Symbol't\\F'System'\\F'Arial')"
	Label bottom "\\Z14\\F'Symbol't\\F'Arial'(s)"
	
	SetDataFolder dfSave
End


Function NormACF(Waves, NofWaves, Xstart, Xend)		// sample: DrawACF("Y_0;Y_1;Y_2", 1e-6, 0.1)
	String Waves, NofWaves							// CAUTION: do not insert any space in between the wave names expect ";"
	Variable Xstart, Xend
	
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS
									
	Variable i=0, j=0, index_Xstart=0, index_Xend=0, N, DC
	Variable num_wave = ItemsInList(Waves)
	Make/O/D/N=(num_wave) min_acf, max_acf											// waves for storing the min and max peak values of ACF waves
	String Yacf, N_acf, fitY, NofACF, NofFit, V_Param, V_X									// Yacf: the main ACF data. and Name of ACF curves, and fit curves
	Variable r, g, b, rgbsize=0, rgbremainder=0, rgbstep=floor(65535/(num_wave)*3)				// Auto assgin different color for the fit curves
	
	Display
	TextBox/C/F=0/A=RT/N=LegendNormACF "Normalized Curves"			// Creat legend
	//************************************************************
	For (i=0; i<num_wave; i+=1)
	
		Yacf = StringFromList(i, Waves, ";")				// search through all input wave names and do normalization
		N_acf = StringFromList(i, NofWaves, ";")
		NofACF = "NormACF_" + Yacf
		NofFit = "NormFit_" + Yacf
		fitY = "Fit" + Yacf								// Get the fit data

		V_Param = "Value_"							// Get the respective fitting parameter values, including N and DC
		V_X = "X_"									// X_00 data
		for (j=2; j<strlen(Yacf); j+=1)
			V_Param = V_Param + Yacf[j]
			V_X = V_X + Yacf[j]
		endfor
	
		Wave vParam=$V_Param				// Igor doesn't allow to direct use "$V_Param[0]", have to refer a wave to this $
		Wave w_x = $V_X
		Wave w_ACF = $Yacf	
				
		WaveStats/Q vParam
		N = vParam[0]
		DC = vParam[V_npnts - 1]
		
		Wavestats/Q w_x
		//***********************************************// search for index of Xstart and Xend
		for (j=0; j<V_npnts; j+=1)
			if ((w_x[j] - Xstart) > 0)
				index_Xstart = j-1
				break
			endif
		endfor
		for (j=0; j<V_npnts; j+=1)
			if ((w_x[j] - Xend) > 0)
				index_Xend = j-1
				break
			endif
		endfor
		//***********************************************//				
		Duplicate/O $Yacf, acfData
		Duplicate/O $fitY, fitData
		acfData = (acfData - DC) * N +1				// Normalization for each wave data
		fitData = (fitData - DC) * N + 1
		
		Wavestats/Q/R=(index_Xstart, index_Xend) acfData
		min_acf[i] = V_min
		max_acf[i] = V_max	
		
		Duplicate/O acfData, $NofACF
		Duplicate/O fitData, $NofFit
				
		AppendToGraph $NofACF, $NofFit vs w_x
		rgbremainder = mod(i, 3)
		rgbsize = (i-rgbremainder)/3
		r=0; g=0; b=0
		switch (rgbremainder)
			case 0:
				r = rgbsize + 1
				break
			case 1:
				g = rgbsize + 1
				break
			case 2:
				b = rgbsize + 1
				break
		endswitch
		ModifyGraph rgb($NofFit)=(rgbstep*r, rgbstep*g, rgbstep*b)			// modify the line  color of fit curves
		ModifyGraph lsize($NofFit)=2
		
		AppendText/N=LegendNormACF "\\s("+NofFit+")" + N_acf
	Endfor
	
	KillWaves acfData, fitData

	Wavestats/Q max_acf
	Variable Y_V_max = V_max
	Wavestats/Q min_acf
	Variable Y_V_min = V_min
		
	SetAxis left Y_V_min*0.98, Y_V_max*1.02
	SetAxis bottom Xstart, Xend	
	ModifyGraph log(bottom)=1, mirror=2, axOffset(bottom)=0.5, width=288,height=216
	ModifyGraph btLen(left)=4,stLen(left)=2, btLen(bottom)=4,stLen(bottom)=2
	
	Label left "\\Z14G(\\F'Symbol't\\F'System'\\F'Arial')"
	Label bottom "\\Z14\\F'Symbol't\\F'Arial'(s)"

	SetDataFolder dfSave
End



Function OnClickSelectPara(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Variable/G num_Parameter									// Get the number of selected parameter
	String/G nPara												// Get the name of parameter as a global string
	num_Parameter = popNum										
	nPara = popStr
	
	//************************************************//						// Delete blank in the string, like "  tauD"=>"tauD"
	Variable j
	String tmp=""
	
	for (j=0; j<strlen(nPara); j+=1)
		if (strsearch(nPara, " ", j) == (-1))
			break
		endif
	endfor
																// Find the position of last space (" ")
	tmp = nPara[j, strlen(nPara)-1]
	nPara = tmp													// Shift the string backward
	//************************************************//
	
	SetDataFolder dfSave 
End

Function OnClickPreFix(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable

	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	String/G init_prefix
	init_prefix = varStr											// Set the number of MultipleRun
	
	SetDataFolder dfSave 
End

Function OnClickMultipleRun(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable

	String dfSave = GetDataFolder(1)
	SetDataFolder root:FCS

	Variable/G init_multipleRun
	init_multipleRun = varNum											// Set the number of MultipleRun
	
	SetDataFolder dfSave 
End


Function OnClickGroupFile(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
	
	NVAR SelGroupFile = root:FCS:SelGroupFile
	
	SelGroupFile = checked

End

Function OnClickSelJoint(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
	
	if (checked)
		ListBox ACFdataSel mode=3
	else
		ListBox ACFdataSel mode=4
	endif

End


Function OnClickStatistics(ctrlName) : ButtonControl
	String ctrlName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE IsValid = root:FCS:IsValid
	WAVE SelACFdataIndex = root:FCS:SelACFdataIndex
	WAVE DataNumIndex = root:FCS:DataNumIndex
	WAVE FitResults = root:FCS:FitResults
	WAVE/T DataNameIndex = root:FCS:DataNameIndex
	
	NVAR n, init_multipleRun, num_Parameter
	Variable i, j, k, StartPoint, EndPoint, filecount =0
	Variable pos1=0, pos2
	NVAR SelGroupFile = root:FCS:SelGroupFile
	String/G nPara, init_prefix
	String StartEndPoints="", orgWave, avgWave, stdWave, avgFileName, FileSeq
	String FileName, cmpFileName=""

	DoWindow/K FitResultsStatisticsTable
	Edit/W=(5, 5, 555, 320) as "FCS FitResults Statistics"					// Create a table
	DoWindow/C FitResultsStatisticsTable

	Make/O/D/N=(n) SelListIndex										// Store the index numbers of these selected ACF
	j = 0
	for (i=0; i<n; i+=1)
		if (SelACFdataIndex(i) == 1)									// If SelACFdataIndex(i)=1, it means that the respective wave is selected
			SelListIndex[j] = i
			j+=1
		endif
	endfor
	Redimension/N=(j) SelListIndex
//	
//	for (i=0; i<n; i+=1)													
//		if (SelACFdataIndex(i) == 1)
//			StartPoint = i
//			break
//		endif
//	endfor
//	
//	for (i=(StartPoint+1); i<n; i+=1)
//		if (SelACFdataIndex(i) == 1)
//			EndPoint = i
//			break
//		endif
//	endfor
	
	orgWave = init_prefix + "_" + nPara
	avgWave = "avg_" + init_prefix + "_" + nPara
	avgFileName =  init_prefix + "_FileName"
	stdWave = "std_" + init_prefix + "_"+ nPara
	FileSeq = init_prefix + "_FileSeq"
	
	//Variable npnts = EndPoint - StartPoint + 1
	Wavestats/Q SelListIndex
	Variable npnts = V_npnts
	Make/O/D/N=(npnts) $orgWave
	Wave org = $orgWave
	
	for (i=0; i< npnts; i+=1)
//		if (IsValid(i+StartPoint)==0)
		if (IsValid(SelListIndex[i])==0)
			org[i] = NaN													// If invalid, set as NaN
		else
			//org[i] = FitResults(i+StartPoint)[2*(num_Parameter-1)]			// assignment of fitresults
			org[i] = FitResults(SelListIndex[i])[2*(num_Parameter-1)]			// assignment of fitresults
		endif
	endfor


	if (SelGroupFile)					
		Make/O/T/N=(npnts) $avgFileName									// cut all the digits at the end of file names, and store them into noDigitDataNames
		Make/O/D/N=(npnts) $FileSeq
		Wave/T avgfile = $avgFileName
		Wave FileSequence = $FileSeq
		
//		for (k=StartPoint; k<=EndPoint; k+=1)
		for (k=0; k<=npnts; k+=1)
	//		FileName = DataNameIndex[SelListIndex[k]]
			FileName = DataNameIndex[SelListIndex[k]]
			for(i=strlen(FileName)-1;i>=0;i-=1)
				if(char2num(FileName[i])<char2num("0")||char2num(FileName[i])>char2num("9"))
					j=i
					break
				endif
			endfor
			FileName = FileName[0,j]
			
			if ( !cmpstr(cmpFileName, FileName) )
				//FileSequence[k - StartPoint] = filecount
				FileSequence[k] = filecount
			else
				cmpFileName = FileName
				avgfile[filecount] = FileName
				
				filecount += 1
				//FileSequence[k - StartPoint] = filecount
				FileSequence[k] = filecount
			endif	
		endfor
		
		Wavestats/Q FileSequence
		Variable NumOfAvg = V_max
		Redimension/N=(NumOfAvg) avgfile
		Make/O/D/N=(NumOfAvg) $avgWave, $stdWave
		Wave avg = $avgWave
		Wave std = $stdWave
		
		Make/O/D/N=(NumOfAvg +1) statsPos = -1
		statsPos[NumOfAvg] = npnts - 1
		for (i=1; i<NumOfAvg; i+=1)
			for (j=0; j<npnts; j+=1)
				if (FileSequence[j] == i)
					statsPos[i] = j
				endif
			endfor
		endfor
		
		for (k=1; k<=NumOfAvg; k+=1)
			Wavestats/Q/R=(statsPos[k-1] +1, statsPos[k]) org
			avg[k -1] = V_avg
			std[k -1] = V_sdev
		endfor
	
		AppendToTable avgfile, FileSequence
		
	else 
	
		if (mod((npnts), init_multipleRun))									// the number of multipleRun is set wrongly, or StartPoint and EndPoint are wrong
			print "ERROR!!! the number of data is wrong!!"
			org=NaN; avg=NaN; std=NaN
		else
			Make/O/D/N=(npnts/init_multipleRun) $avgWave, $stdWave
			Wave avg = $avgWave
			Wave std = $stdWave
				
			for (i=0; i<(npnts/init_multipleRun); i+=1)
				Wavestats/Q/R=(i*init_multipleRun, i*init_multipleRun+init_multipleRun-1) org		// Wavestats, to get average and std
				avg[i] = V_avg
				std[i] = V_sdev
			endfor
		endif
	
	endif

																	// Search for all waves whose name begins with the defined prefix
	String matchStrW="*" + init_prefix +"*"
	String AllWaves=WaveList(matchStrW, ";", "")
	Variable num=ItemsInList(AllWaves)
	Make/O/T/N=(num) WavesInTable=StringFromList(p, AllWaves)
																	
	for (i=0; i<num; i+=1)
		AppendToTable $WavesInTable[i]
	endfor
	
	Display avg
	ModifyGraph mirror=2
	ErrorBars $avgWave, Y wave=(std, std)
	ModifyGraph width=288, height=216, mode=4, marker=16
	
	KillWaves  statsPos,WavesInTable
	
	SetDataFolder dfSave 
End



Function/S StringNameList(WaveN)							// A function to return a stringList from a textwave's content
	Wave/T WaveN
	String StringNameList=""
	
	Variable W_npnts = DimSize(WaveN, 0)
	Variable i
	For (i=0; i<W_npnts; i+=1)
		StringNameList = StringNameList + WaveN[i] +";"
	Endfor
	
	Return StringNameList
End






////////////////////////////////////// All the other useful functions ////////////////////////////////////////////

Function stats(nWave, num)						// nWave: the wave to be analyzed; num: the cycle number
	Wave nWave
	Variable num								// num: MultipleRun, the number of repeat experiments

	String SnWave=NameOfWave(nWave)
	String avg="avg"+SnWave
	String std = "std"+SnWave
	Variable i
			
	Wavestats/Q nWave
	Variable npnts=V_npnts + V_numNaNs
	Variable NewNum = npnts/num

	Make/O/D/N=(NewNum) $avg, $std
	WAVE avgWave = $avg
	WAVE stdWave = $std
	
	for (i=0; i<NewNum; i+=1)
		Wavestats/Q/R=(i*num, i*num+num-1) nWave
		avgWave[i] = V_avg
		stdWave[i] = V_sdev
	endfor
	
	Edit nWave, $avg, $std
	Display $avg
	ModifyGraph width=288,height=216,mode=4,marker=16
	ModifyGraph mirror=2
	ErrorBars $avg, Y wave=(stdWave, stdWave)	
End


Function CalAngles(tauFnet, tauFflow, tauFscan, r0)
	Wave tauFnet
	Variable tauFflow, tauFscan, r0
	
	Wavestats/Q tauFnet
	Make/O/D/N=(V_npnts) $("V_" + NameOfWave(tauFnet)), $("Ang_" + NameOfWave(tauFnet))
	Wave Vnet = $("V_" + NameOfWave(tauFnet))
	Wave VAngle = $("Ang_" + NameOfWave(tauFnet))
	
	Variable i, Vflow, Vscan
	Vflow = r0/tauFflow
	Vscan = r0/tauFscan
	Vnet = r0/tauFnet
	
	For (i=0; i<V_npnts; i+=1)
		VAngle[i] = Angles(Vnet[i], Vflow, Vscan, 90)
	Endfor

End


Function Angles(Vnet, Vflow, Vscan, AngleScan)
	Variable Vnet, Vflow, Vscan, AngleScan
	
	Variable V_cos = (Vnet^2 - Vflow^2 - Vscan^2) / (2*Vflow*Vscan)
	Variable Angle = acos(V_cos)*180/pi
	
	Return (Angle+AngleScan-180)
End


Function matrixMap(OrgWave, DestWave)
	Wave OrgWave
	String DestWave
	
	Duplicate/O OrgWave, $DestWave
	Wave wDestWave = $DestWave
	stats(wDestWave, 3)
	
	String nMat = "mat_"+DestWave
	String avgWave = "avg" + DestWave
	Make/O/D/N=(5,5) $nMat
	Wave wMat = $nMat
	Wave wavgWave = $avgWave
	 wMat = wavgWave
	 
	 Display; AppendMatrixContour wMat
	 ModifyGraph width=288,height=288
	 AppendImage wMat
	 SetAxis/A/R left

End


Function ModACFgraph()
            SetAxis left 0.98, 2
            SetAxis bottom 1e-6, 0.1        

            ModifyGraph log(bottom)=1, mirror=2, axOffset(bottom)=0.5, width=288,height=216
            ModifyGraph btLen(left)=4,stLen(left)=2, btLen(bottom)=4,stLen(bottom)=2         

            Label left "\\Z14G(\\F'Symbol't\\F'System'\\F'Arial')"
            Label bottom "\\Z14\\F'Symbol't\\F'Arial'(s)"
            Legend/C/N=text0/F=0/A=MC
End






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*************************************************************************************************//
//
//			FCCS Display				bulit on 10/12/2007 by Yong Hwee Foo
/
//************************************************************************************************//
//
//	Version History (mm/dd/yyyy)
//
// Ver 1.0	10/12/2007		A button to create a new panel for FCCS options
//							Allow switching display between FCS & FCCS graphs
//							New FCCS table showing fittting parameters
//							Allow location of one of the FCCS data using the Go To buttons
//							Integrated into the normal operations (eg. kill data, fitting of curves, linked to selection of data in list box)
//
// Ver 1.1	06/01/2009 		Kill Selected in FCCS mode kills all of the 4 ACF and CCF when only one of them is selected to be kill
// Ver 1.2	05/12/2010		Changed the calculation of cpm to only single channel
//							Normalization of FCCS curves
//
//*************************************************************************************************//

//************************************************
Menu "Analysis"
	"Convert to 1.9 ...", Convertto18()
End
//*************************************************
Function Convertto18()			//convert old non 1.8 version saved files to be compatible with this FCCS version 
	
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	NVAR DCurrent=root:FCS:DCurrent
	FCSInitVariables()
	FCSShowWindows()
	
	if(stringmatch(DataNameIndex(DCurrent),"S*")==0)
		InitFCCS()
		Execute "FCCSPanel()"
	endif			
End
//****************************************
Function InitFCCS()
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR FCCSMode
	NVAR DCurrent
	Variable/G FCCSFront=0				//Initial value for whether FCS / FCCS graph is in front, value=0: FCS graph is in front, value=1: FCCS in front
	Variable/G FCCSNorm=0				//For the normalization of FCCS curves
	Variable/G DrawFCCS=1111
	
	FCCSMode=1
	GroupFCCSData(DCurrent)
	FCCSCreateGraph(DCurrent)
	FCCSUpdateGraph(DCurrent)
	FCCSCreateTable(DCurrent)
	FCCSUpdateTable(DCurrent)
	DoWindow/F $(GetGraphName(DCurrent))
	
	SetDataFolder dfSave
End


Window FCCSPanel() : Panel
	PauseUpdate; Silent 1	
	DoWindow/K FCCSPanel
	NewPanel/K=2/W=(990,10,1190,335) as "FCCS Panel"
	GroupBox DisplayOpt title="Display Options", pos={9,5},size={181,90}
	CheckBox FCCSMode title="FCCS Mode ON/OFF", pos={15,25},fsize=12,value=root:FCS:FCCSMode, proc=OnFCCSONOFFCheck
	CheckBox FCSGraph pos={25,50},size={78,15},title="FCS Graph", fsize=12, value=1,mode=1,proc=OnGraphTypeCheck
	CheckBox FCCSGraph pos={25,70},size={78,15},title="FCCS Graph", fsize=12, value=0,mode=1,proc=OnGraphTypeCheck
	
	GroupBox DrawFCCS title="Draw FCCS Curves", pos={9,170},size={181,148}
	Button FCCSDraw title="Draw Graph", pos={50,190}, size={100,30}, proc=OnDrawFCCSClick
	CheckBox DrawFCCS0 title="GA", pos={15,230},fsize=12,value=1
	CheckBox DrawFCCS1 title="RA", pos={59,230},fsize=12,value=1
	CheckBox DrawFCCS2 title="AB", pos={103,230},fsize=12,value=1
	CheckBox DrawFCCS3 title="BA", pos={147,230},fsize=12,value=1
	
	CheckBox NonNorm title="No normalization", pos={25,255},fsize=12, value=1,mode=1, proc=OnFCCSNormCheck
	CheckBox NormG title="Normalized to GA", pos={25,275},fsize=12, value=0,mode=1, proc=OnFCCSNormCheck
	CheckBox NormR title="Normalized to RA", pos={25,295},fsize=12, value=0,mode=1, proc=OnFCCSNormCheck
	
	GroupBox Goto title="Go To Data", pos={9,100},size={181,62}
	Button GotoGA title="GA", pos={20,120}, size={35,30}, proc=OnGotoClick
	Button GotoRA title="RA", pos={61,120}, size={35,30}, proc=OnGotoClick
	Button GotoAB title="AB", pos={102,120}, size={35,30}, proc=OnGotoClick
	Button GotoBA title="BA", pos={143,120}, size={35,30}, proc=OnGotoClick
	
	//GroupBox Goto title="Go To Data", pos={9,180},size={181,62}
	//Button GotoGA title="GA", pos={20,200}, size={35,30}, proc=OnGotoClick
	//Button GotoRA title="RA", pos={61,200}, size={35,30}, proc=OnGotoClick
	//Button GotoAB title="AB", pos={102,200}, size={35,30}, proc=OnGotoClick
	//Button GotoBA title="BA", pos={143,200}, size={35,30}, proc=OnGotoClick
	
	
End


//************************************************
Function /T GetGraphName2(DP)					//Name of the FCCS data graph window (DP=Data Pointer)
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCCSGraph"
	else
		return "FCCS_Graph_"+num2str(DataNumIndex[DP])
	endif
end


Function /T GetTableName2(DP)					//Name of the FCCS fitting parameter window
	Variable DP
	
	NVAR UseSameWindow=root:FCS:UseSameWindow
	WAVE DataNumIndex=root:FCS:DataNumIndex
	
	if(UseSameWindow)
		return "FCCSTable"
	else
		return "FCCS_Table_"+num2str(DataNumIndex[DP])
	endif
end

//************************************************
Function OnClickFCCSPanel(ctrlName) : ButtonControl		//Create FCCS Panel
	String ctrlName
	
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	NVAR DCurrent=root:FCS:DCurrent
	
	if(stringmatch(DataNameIndex(DCurrent),"S*")==0)
		InitFCCS()
		Execute "FCCSPanel()"	
	else
		Print "This is not FCCS data"
	endif
End


Function OnFCCSONOFFCheck(ctrlName,checked) : CheckBoxControl		//Controls whether FCCS Panel is available or not			
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
	
	WAVE/T DataNameIndex=root:FCS:DataNameIndex
	NVAR DCurrent=root:FCS:DCurrent
	NVAR FCCSMode=root:FCS:FCCSMode

	if(checked)
		if(stringmatch(DataNameIndex(DCurrent),"S*")==0)	
			FCCSCreateTable(DCurrent)
			FCCSUpdateTable(DCurrent)
			FCCSCreateGraph(DCurrent)
			FCCSUpdateGraph(DCurrent)	
			FCCSMode=1
		else
			Print "This is not FCCS data"
		endif
	else
		if(stringmatch(DataNameIndex(DCurrent),"S*")==0)	
			DoWindow/F/K $(GetTableName2(DCurrent))
			DoWindow/F/K $(GetGraphName2(DCurrent))
			DoWindow/K FCCSPanel
			FCCSMode=0
		endif		
	endif
End

Function OnGraphTypeCheck(ctrlName,checked) : CheckBoxControl		//Switch display between FCS or FCCS	by bring one to the front		
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
		
	NVAR FCCSFront=root:FCS:FCCSFront
	NVAR DCurrent=root:FCS:DCurrent
		
	strswitch (ctrlName)
		case "FCSGraph":			
			FCCSFront = 0
			DoWindow/F $(GetGraphName(DCurrent))
			break
		case "FCCSGraph":			
			FCCSFront = 1
			DoWindow/F $(GetGraphName2(DCurrent))
			FCCSUpdateGraph(DCurrent)
			break
	endswitch
	
	CheckBox FCSGraph,win=FCCSPanel,value= FCCSFront == 0
	CheckBox FCCSGraph,win=FCCSPanel,value= FCCSFront == 1
End

Function OnGotoClick (ctrlName) : ButtonControl			//Go to either GA, RA, AB or BA file
	String ctrlName
	
	NVAR DCurrent=root:FCS:DCurrent
	GroupFCCSData(DCurrent)	
	WAVE FCCSGroupNum=root:FCS:FCCSGroupNum

	strswitch(ctrlName)
		case "GotoGA":
			if(FCCSGroupNum[0]!=-1)
				SelectDataonGoto(FCCSGroupNum[0])
			else
				Print "Data not found"
			endif
			break
		case "GotoRA":
			if(FCCSGroupNum[1]!=-1)
				SelectDataonGoto(FCCSGroupNum[1])
			else
				Print "Data not found"
			endif
			break
		case "GotoAB":
			if(FCCSGroupNum[2]!=-1)
				SelectDataonGoto(FCCSGroupNum[2])
			else
				Print "Data not found"
			endif
			break
		case "GotoBA":
			if(FCCSGroupNum[3]!=-1)
				SelectDataonGoto(FCCSGroupNum[3])
			else
				Print "Data not found"
			endif
			break
		endswitch
End

Function SelectDataonGoto(Current)				//select the file in the listbox indicated by the Go To buttons
	Variable Current
	
	WAVE SelectionIndex=root:FCS:SelectionIndex
	NVAR DLast=root:FCS:DLast
	NVAR DCurrent=root:FCS:DCurrent
	NVAR DEnd=root:FCS:DEnd
	
	Variable i										
	for(i=0;i<=DLast;i+=1)
		SelectionIndex[i]=0						//update selection in listbox
	endfor
	SelectionIndex[Current]=1
	ListBox DataSelection win=FCSMainControl, row=Current
	FCSB2F(Current)	
	DCurrent=Current
	DEnd=DCurrent
End

Function OnDrawFCCSSelectionCheck (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if checked, 0 if not

	strswitch(ctrlName)
		case "DrawGA":
			
			break
		case "DrawRA":
			
			break
	endswitch
End

Function OnFCCSNormCheck(ctrlName,checked) : CheckBoxControl		//selection of normalization for FCCS	
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
		
	NVAR FCCSNorm=root:FCS:FCCSNorm
	NVAR DCurrent=root:FCS:DCurrent
		
	strswitch (ctrlName)
		case "NonNorm":			
			FCCSNorm = 0
			break
		case "NormG":			
			FCCSNorm = 1
			break
		case "NormR":			
			FCCSNorm = 2
			break
	endswitch
	
	CheckBox NonNorm,win=FCCSPanel,value= FCCSNorm == 0
	CheckBox NormG,win=FCCSPanel,value= FCCSNorm == 1
	CheckBox NormR,win=FCCSPanel,value= FCCSNorm == 2
End

Function OnDrawFCCSClick (ctrlName) : ButtonControl			//Plot FCCS curves for presentation
	String ctrlName
	NVAR FCCSNorm=root:FCS:FCCSNorm
	
	if(FCCSNorm!=0)
		NormDrawFCCS()
	else
		NonNormDrawFCCS()
	endif
End

//************************************************************************************
Function NonNormDrawFCCS()	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR XStart, XEnd, FCCSNorm
	WAVE DataNumIndex, FCCSGroupNum
	WAVE/T DataNameIndex
	SVAR SDataNameIndex

	Display/W=(105,100,466,366)											// Draw a new graph
	TextBox/C/F=0/A=RT/N=DrawFCCS
			
	Variable FCCSVmin=1000000						//starting values for proper function of y-axis scaling involving V_min and V_max
	Variable FCCSVmax=-1000000
	Variable i
	
	
	for(i=0;i<=3;i+=1)
		String FCCSDrawControl="DrawFCCS"+num2str(i)
		ControlInfo/W=FCCSPanel $FCCSDrawControl
		if(V_Value)																				//check for the ticked checkbox to see which curves to plot
			if(FCCSGroupNum[i]!=-1)																//check if that file is still in the listbox
				String DI=num2str(DataNumIndex[FCCSGroupNum[i]])
				WAVE   Xdat		=$("X_"    +DI)
				WAVE   Ydat	=$("Y_"    +DI)
				String FitY		=  "FitY_" +DI
				AppendtoGraph YDat vs XDat;DelayUpdate
				ModifyGraph lsize($("Y_"+DI))=1.5
			
				if(WaveExists($FitY))	
					AppendtoGraph $FitY vs XDat
					ModifyGraph/Z lsize($FitY)=1.5
					AppendText "\\s("+FitY+")"+DataNameIndex[FCCSGroupNum[i]]
				endif
				
				switch (i)
					case 0:																		//gives GA green, RA red, AB blue and BA violet
						ModifyGraph rgb($("Y_"+DI))=(0,65000,0)
						ModifyGraph/Z rgb($FitY)=(0,65000,0)										
						break
					case 1:
						ModifyGraph rgb($("Y_"+DI))=(65000,0,0)															
						ModifyGraph/Z rgb($FitY)=(65000,0,0)						
						break
					case 2:
						ModifyGraph rgb($("Y_"+DI))=(0,0,65000)
						ModifyGraph/Z rgb($FitY)=(0,0,65000)					
						break
					case 3:
						ModifyGraph rgb($("Y_"+DI))=(30000,0,30000)
						ModifyGraph/Z rgb($FitY)=(30000,0,30000)				
						break
				endswitch
		
				WaveStats/Q/R=(XSTart,XEnd) YDat										//choose the correct y-axis scale for the 4 curves
				if(V_min<FCCSVmin)
					FCCSVmin = V_min
				endif
				if(V_max>FCCSVmax)
					FCCSVmax = V_max
				endif				
			endif
		endif	
	endfor
	
	SetAxis bottom Xdat[XStart],Xdat[XEnd]
	ModifyGraph log(bottom)=1, mirror=2, axOffset(bottom)=0.5
	ModifyGraph btLen(left)=4,stLen(left)=2, btLen(bottom)=4,stLen(bottom)=2
	Label left "\\Z14G(\\F'Symbol't\\F'System'\\F'Arial')"
	Label bottom "\\Z14\\F'Symbol't\\F'Arial'(s)"	
	SetAxis left FCCSVmin*0.9999, FCCSVmax*1.0001;DelayUpdate // Scale both axes

	SetDataFolder dfSave
	
End

//************************************************************************************
Function NormDrawFCCS()
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	WAVE DataNumIndex, FCCSGroupNum
	WAVE/T DataNameIndex
	SVAR SDataNameIndex
	NVAR XStart, XEnd, FCCSNorm
	Variable InvAmp
	String GraphName="Norm_FCCS"
	
	DoWindow/K $GraphName			
	Display/W=(105,100,466,366)	
	DoWindow/C $GraphName										// Draw a new graph
	TextBox/C/F=0/A=RT/N=DrawFCCS
	
	If(FCCSNorm==1)
		WAVE PValue=$("Value_"+num2str(DataNumIndex[FCCSGroupNum[0]]))			//Return value N for GA
		InvAmp=PValue[0]
		DoWindow/T $GraphName	"Normalized to GA "+SDataNameIndex
	Endif	
	
	If(FCCSNorm==2)
		WAVE PValue=$("Value_"+num2str(DataNumIndex[FCCSGroupNum[1]]))			//Return value N for RA
		InvAmp=PValue[0]
		DoWindow/T $GraphName	"Normalized to RA "+SDataNameIndex
	Endif		
	
	Variable i
	Variable FCCSVmin=1000000						//starting values for proper function of y-axis scaling involving V_min and V_max
	Variable FCCSVmax=-1000000
	
	For(i=0;i<=3;i+=1)
		String FCCSDrawControl="DrawFCCS"+num2str(i)
		ControlInfo/W=FCCSPanel $FCCSDrawControl
		if(V_Value)		
			if(FCCSGroupNum[i]!=-1)	
				String DI=num2str(DataNumIndex[FCCSGroupNum[i]])
				WAVE Xdat=$("X_"+DI)
				WAVE Ydat=$("Y_"+DI)
				WAVE PValue=$("Value_"+DI)
				WAVE FitY=$("FitY_" +DI)				
				Duplicate/O Ydat, $("CNormYdat_"+DI)
				Duplicate/O FitY, $("CNormFitY_"+DI)				
				WAVE NormYdat=$("CNormYdat_"+DI)
				WAVE NormFitY=$("CNormFitY_"+DI)
				WaveStats/Q PValue																			
				NormYdat=(NormYdat-PValue[V_npnts-1])*InvAmp+1					//(Orignal Curve Amplitude-DC)*N (GA/RA); curves needed to be fitted for normalization to work.	
				NormFitY=(NormFitY-PValue[V_npnts-1])*InvAmp+1					//same as above but for fitted data						
				AppendToGraph NormYdat vs Xdat;DelayUpdate
				AppendToGraph NormFitY vs Xdat;DelayUpdate
				String FitYName="CNormFitY_" +DI
				AppendText "\\s("+FitYName+")"+DataNameIndex[FCCSGroupNum[i]]
				switch (i)
					case 0:																																		
						ModifyGraph rgb($("CNormYdat_"+DI))=(0,65000,0);DelayUpdate
						ModifyGraph rgb($("CNormFitY_"+DI))=(0,65000,0);DelayUpdate							
						break
					case 1:					
						ModifyGraph rgb($("CNormYdat_"+DI))=(65000,0,0);DelayUpdate	
						ModifyGraph rgb($("CNormFitY_"+DI))=(65000,0,0);DelayUpdate							
						break
					case 2:					
						ModifyGraph rgb($("CNormYdat_"+DI))=(0,0,65000);DelayUpdate
						ModifyGraph rgb($("CNormFitY_"+DI))=(0,0,65000);DelayUpdate								
						break
					case 3:					
						ModifyGraph rgb($("CNormYdat_"+DI))=(30000,0,30000);DelayUpdate	
						ModifyGraph rgb($("CNormFitY_"+DI))=(30000,0,30000);DelayUpdate																		
						break					
				endswitch
				ModifyGraph/Z lsize($("CNormYdat_"+DI))=1.5
				ModifyGraph/Z lsize($("CNormFitY_"+DI))=1.5
				WaveStats/Q/R=(XSTart,XEnd) NormYdat			
				
				if(V_min<FCCSVmin)
					FCCSVmin = V_min
				endif
				if(V_max>FCCSVmax)
					FCCSVmax = V_max
				endif	
			endif	
		endif	
	Endfor		
			
	SetAxis bottom Xdat[XStart],Xdat[XEnd]
	ModifyGraph log(bottom)=1, mirror=2, axOffset(bottom)=0.5
	ModifyGraph btLen(left)=4,stLen(left)=2, btLen(bottom)=4,stLen(bottom)=2
	Label left "\\Z14G(\\F'Symbol't\\F'System'\\F'Arial')"
	Label bottom "\\Z14\\F'Symbol't\\F'Arial'(s)"	
	SetAxis left FCCSVmin*0.9999, FCCSVmax*1.0001;DelayUpdate // Scale both axes
	
	SetDataFolder dfSave
End
//*************************************************		
Function FCCSCreateGraph(Current)				
	Variable Current
	
	WAVE /T DataNameIndex=root:FCS:DataNameIndex
	String GraphName	= GetGraphName2(current)
	
	DoWindow/K $GraphName
	Display/W=(5,0,350,220)/K=2			// Create FCCS Graph window
	DoWindow/C $GraphName					// Name the graph
End

//******************************
Function FCCSUpdateGraph(Current)		//paint or repaint FCCS Graph windows
	Variable Current
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR XStart, XEnd
	WAVE DataNumIndex, FCCSGroupNum
	WAVE/T DataNameIndex
	NVAR DispCurrent, UseSameWindow
	SVAR SDataNameIndex
		
	if(UseSameWindow&&DispCurrent!=Current)
		SetDataFolder dfSave
		return -1
	endif
	
	String GraphName	=  GetGraphName2(Current)
	DoWindow/T $GraphName "FCCS Graph of "+SDataNameIndex
	
	Variable FCCSVmin=1000000						//starting values for proper function of y-axis scaling involving V_min and V_max
	Variable FCCSVmax=-1000000
	Variable i
	for(i=0;i<=3;i+=1)
		if(FCCSGroupNum[i]!=-1)																//check if that file is still in the listbox
			String DI=num2str(DataNumIndex[FCCSGroupNum[i]])
			WAVE   Xdat		=$("X_"    +DI)
			WAVE   Ydat	=$("Y_"    +DI)
			String FitY		=  "FitY_" +DI
			RemoveFromGraph /W=$GraphName /Z $("Y_"+DI)
			AppendtoGraph /W=$GraphName YDat vs XDat;DelayUpdate
			
			switch (i)
				case 0:																		//gives GA green, RA red, AB blue and BA violet
					ModifyGraph/W=$GraphName rgb($("Y_"+DI))=(0,65000,0);DelayUpdate
					break
				case 1:
					ModifyGraph/W=$GraphName rgb($("Y_"+DI))=(65000,0,0);DelayUpdate
					break
				case 2:
					ModifyGraph/W=$GraphName rgb($("Y_"+DI))=(0,0,65000);DelayUpdate
					break
				case 3:
					ModifyGraph/W=$GraphName rgb($("Y_"+DI))=(30000,0,30000);DelayUpdate
					break
			endswitch
			
			if(WaveExists($FitY))													// If is already fitted		
				RemoveFromGraph /W=$GraphName/Z $FitY
				AppendtoGraph /W=$GraphName $FitY vs XDat;DelayUpdate					// Display fitted curve
				ModifyGraph/W=$GraphName rgb($FitY)=(0,0,0);DelayUpdate
			endif
			WaveStats/Q/R=(XSTart,XEnd) YDat										//choose the correct y-axis scale for the 4 curves
			if(V_min<FCCSVmin)
				FCCSVmin = V_min
			endif
			if(V_max>FCCSVmax)
				FCCSVmax = V_max
			endif
			SetAxis /W=$GraphName bottom Xdat[XStart],Xdat[XEnd]
		endif
	endfor
	
	ModifyGraph /W=$GraphName log(bottom)=1;DelayUpdate
	SetAxis /W=$GraphName left FCCSVmin*0.999, FCCSVmax*1.001;DelayUpdate // Scale both axes

	SetDataFolder dfSave
End
//******************************
Function FCCSCreateTable(Current)
	Variable Current
	
	String TableName	=  GetTableName2(Current)
	DoWindow/K $TableName
	Edit/K=2/W=(360,385,735,595)	// Create table with parameters
	DoWindow /C $TableName
End
//*******************************************
Function FCCSUpdateTable(Current)		//Display and redraw fitting parameter table
	Variable Current
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	NVAR DispCurrent, UseSameWindow
	if(UseSameWindow&&DispCurrent!=Current)
		SetDataFolder dfSave
		return -1
	endif
	
	SVAR SDataNameIndex
	WAVE DataNumIndex, FCCSGroupNum
	WAVE/T DataNameIndex
	
	String TableName	=GetTableName2(Current)
	DoWindow/F $TableName
	DoWindow/T $TableName "Fitting "+SDataNameIndex
	Execute "ModifyTable width[0]=0"
	
	Variable i
	for(i=0;i<=3;i+=1)
		if(FCCSGroupNum[i]!=-1)
			String DI=num2str(DataNumIndex[FCCSGroupNum[i]])
			String PValue		=  "Value_"+DI
			String ParaName		="Param_"+DI
			AppendToTable $ParaName,$PValue
			Execute "ModifyTable width("+ParaName+")=30, title("+ParaName+")=\"Para\",size("+ParaName+")=8"
			
			switch (i)
				case 0:																		//name the column accordingly
					Execute "ModifyTable width("+PValue+")=60, title("+PValue+")=\"GA\""
					break
				case 1:
					Execute "ModifyTable width("+PValue+")=60, title("+PValue+")=\"RA\""
					break
				case 2:
					Execute "ModifyTable width("+PValue+")=60, title("+PValue+")=\"AB\""
					break
				case 3:
					Execute "ModifyTable width("+PValue+")=60, title("+PValue+")=\"BA\""
					break
			endswitch
		endif	
	endfor	
	
	SetDataFolder dfSave
End
//**************************************************************

Function GroupFCCSData(Current)							//Generate values for SDataNameIndex & FCCSGroupNum for the location of the 4 FCCS data	& give position of the ACF/CCF consistent with DataNumIndex
	Variable Current

	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS

	WAVE/T DataNameIndex
	NVAR DLast						
	
	String/G SDataNameIndex=DataNameIndex(Current)		//File Name without the prefix for FCCS graph and table title
	SDataNameIndex=RemoveFromList("GA",SDataNameIndex,"-")
	SDataNameIndex=RemoveFromList("RA",SDataNameIndex,"-")
	SDataNameIndex=RemoveFromList("AB",SDataNameIndex,"-")
	SDataNameIndex=RemoveFromList("BA",SDataNameIndex,"-")
	
	Make/O/N=4 FCCSGroupNum							//Return wave location in the ListBox (same as DCurrent) of all ACF & CCF 

	Variable i						
	for(i=0;i<=3;i+=1)										//Assign -1 to data without one of the CF eg. that if one data is deleted, only 3 other CF is displayed
		FCCSGroupNum[i]=-1
	endfor
	
	for(i=0;i<=DLast;i+=1)									//Look for the file name and store the arrangement it which was loaded, the number i, into FCCSGroupNum which then contains locations of GA, RA, AB and BA
		if(stringmatch("GA-"+SDataNameIndex,DataNameIndex[i]))
			FCCSGroupNum[0]=i
		else
			if(stringmatch("RA-"+SDataNameIndex,DataNameIndex[i]))
				FCCSGroupNum[1]=i
			else
				if(stringmatch("AB-"+SDataNameIndex,DataNameIndex[i]))
					FCCSGroupNum[2]=i
				else
					if(stringmatch("BA-"+SDataNameIndex,DataNameIndex[i]))
						FCCSGroupNum[3]=i
					endif
				endif
			endif
		endif
	endfor	
		
	SetDataFolder dfSave
End

//************************************************************************// by Yong Hwee Foo on 20071012
Function OnBrightnessClick(ctrlName) : ButtonControl
	String ctrlName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR DCurrent, FCCSMode
	WAVE DataNumIndex, Intensity1, Intensity2 
	WAVE/T DataNameIndex
	Variable i
	
	String DI=num2str(DataNumIndex[DCurrent])					
	String PValue="Value_"+DI
	WAVE ValueData=$PValue
	
	if(stringmatch(DataNameIndex(DCurrent),"SA*"))
		Print Intensity1[DCurrent]/(ValueData[0]*1000), "kcpm"			
	else
		if(stringmatch(DataNameIndex(DCurrent),"GA*"))
			Print Intensity1[DCurrent]/(ValueData[0]*1000), "kcpm"
		else			
			if(stringmatch(DataNameIndex(DCurrent),"RA*"))
				Print Intensity2[DCurrent]/(ValueData[0]*1000), "kcpm"			
			endif
		endif	
	endif
			
	SetDataFolder dfSave
End

//*****************************************************************************
Function FCCSKillData(KStart, KEnd)	//Kill all ACF & CCF related to the selected data to be killed
	Variable KStart, KEnd
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR   DLast, DCurrent, DispCurrent
	WAVE   DataNumIndex, FCCSGroupNum
	WAVE/T DataNameIndex
	WAVE/T FileNameIndex
	WAVE   Intensity1
	WAVE   Intensity2
	WAVE   IsValid
	WAVE   SelectionIndex
	WAVE   ModelIndex
	WAVE/T ModelNameIndex
	WAVE   FitResults

	if(KEnd>DLast||KEnd<KStart||KStart<0)		//Check parameter validaty
		Print "Parameter error when calling FCCSKillData(", KStart, "," , KEnd, ")"
		SetDataFolder dfSave
		return -1
	endif

	Variable i,j,k,KDiff
	String Y
	
	GroupFCCSData(KStart)
	KDiff=KEnd-KStart
	
	for(k=0;k<=3;k+=1)
		KStart=FCCSGroupNum[k]-k*(KDiff+1)
		KEnd=KStart+KDiff
		
		for(i=KStart;i<=KEnd;i+=1)		//Kill corresponding waves and windows
			Y=num2str(DataNumIndex[i])
			DoWindow /K $(GetGraphName(i))
			DoWindow /K $(GetTableName(i))

			DoWindow /K $(GetGraphName2(i))
			DoWindow /K $(GetTableName2(i))
		
			DoWindow /K $(GetResidName(i))
			DoWindow /K $(GetIntensityName(i))

			KillWaves   $("Param_" +Y)
			KillWaves   $("Hold_"  +Y)
			KillWaves   $("Value_" +Y)
			KillWaves   $("Error_" +Y)
			KillWaves   $("X_"     +Y)
			KillWaves   $("Y_"     +Y)
			KillWaves/Z $("FitY_"  +Y)
			KillWaves/Z $("Res_"   +Y)
			KillWaves/Z $("I1_"   +Y)
			KillWaves/Z $("I2_"   +Y)
			KillWaves/Z $("XI_"   +Y)
		endfor
		
		for(i=0;i<DLast-KEnd;i+=1)		//Delete data index entries
			FileNameIndex[KStart+i] =FileNameIndex[KEnd+i+1]
			DataNameIndex[KStart+i] =DataNameIndex[KEnd+i+1]
			DataNumIndex[KStart+i]  =DataNumIndex[KEnd+i+1]
			IsValid[KStart+i]       =IsValid[KEnd+i+1]
			SelectionIndex[KStart+i]=SelectionIndex[KStart+i+1]
			Intensity1[KStart+i]    =Intensity1[KEnd+i+1]
			Intensity2[KStart+i]    =Intensity2[KEnd+i+1]
			ModelIndex[KStart+i]    =ModelIndex[KEnd+i+1]
			ModelNameIndex[KStart+i]=ModelnameIndex[KEnd+i+1]
			for(j=0;j<20;j+=1)
				FitResults[KStart+i][j]=FitResults[KEnd+i+1][j]
			endfor
		endfor
	
		DLast-=(KEnd-KStart+1)				//Reset data index size
		FCSUpdateDLast()
		if(DLast>=0&&k==3)
			FCSShowData(DCurrent)
		else
			DispCurrent=-1		
		endif	
	endfor	

	SetDataFolder dfSave
End



//**********************************
Function OnCheckLeicaClick(ctrlName,checked) : CheckBoxControl					//mode: autocorrelation or cross-correlation
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
		
	NVAR NumOfLoads=root:FCS:NumOfLoads
	
	strswitch (ctrlName)
		case "LeiSAuto":
			NumOfLoads = 1
			Make/O/T/N=1 DataNameApp="SA-"
			break
		case "LeiTri":
			NumOfLoads = 3
			Make/O/T/N=3 DataNameApp={"GA-","RA-","AB-"}
			break
	endswitch
	
	CheckBox LeiSAuto,value= NumOfLoads==1
	CheckBox LeiTri,value= NumOfLoads==3
	
	SetDataFolder dfSave 
End

//**********************************									//YH
Function OnOpencsvFileClick(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	CsvOpenFilename()
	
End

//**********************************// For Leica FCS
Function OnLoadcsvClick(ctrlName) : ButtonControl
	String ctrlName

	NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	FCScsvLoadAll(PathName)	
	DoWindow/K FCSFileControl
	
	NVAR DLast=root:FCS:DLast
	FCSShowData(DLast)

	NVAR DCurrent=root:FCS:DCurrent
	FCSB2F(DCurrent)
End

//********************************************	//For Leica FCS					
Function CsvOpenFilename()							//Let the user chose the path and filename
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	SVAR PathName, FileName
	String tempName, FormatString=""
	
	Variable refNum
	PathInfo /S PathName			//Set the path used in open to PathName
	Open /D/R/M="Chose any of the files in the directory..."/T=".csv"/Z refNum as PathName+":*.csv"		//Show the open file dialog

	Variable 	Len=strlen(S_FileName)
	if(V_flag==0&&Len>0)						//If the dialog is not canceled
		Variable i=0,j=0,k=0
		for(i=0;i<Len;i+=1)				//Counting directory seperator ':'
			if(!cmpstr(S_FileName[i],":"))
				j=i
			endif
		endfor
		PathName=S_FileName[0,j-1]	//Get path name
		
		for(i=j;i<Len;i+=1)			//The extension name is the characters after the last '.'
			if(!cmpstr(S_FileName[i],"."))
				k=i
			endif
		endfor
		if(k==0)						//if no extension name
			k=Len
		endif
		FileName=S_FileName[j+1,k-1]	

	endif
	
	SetDataFolder dfSave
End


//**************************************
Function FCScsvLoadAll(PathName)							//Load all the .csv file in one directory
	String PathName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NewPath/O/Q DataFolder PathName
	variable i,j,k=0,LoadCount=0
	String FileList
	NVAR UseSameWindow, DLast,DCurrent
	NVAR NumOfLoads=root:FCS:NumOfLoads			
	NVAR NumOfRuns=root:FCS:NumOfRuns			
	
	FileList=IndexedFile(DataFolder,-1,".csv")			//Counting files
	for(i=0;i<strlen(FileList);i+=1)
		if(!cmpstr(FileList[i],";"))
			j+=1
		endif
	endfor
	if(j==0)
		Print "No file in the folder"
	else
		Make/O/T/N=(j) FolderFileList
		for(i=0;i<j;i+=1)									//Creat file list
			FolderFileList[i]=IndexedFile(DataFolder,i,".csv")
		endfor
		
		Sort FolderFileList, FolderFileList				//Sort filelist
		
		For(k=1;k<=NumOfLoads;k+=1)			
				NumOfRuns=k					
			for(i=0;i<j;i+=1)									//Load files
				if(LeicacsvLoad(PathName+":"+FolderFileList[i]))
					LoadCount+=1
					if(!UseSameWindow)
						FCSShowData(DLast)
					endif
				endif
			endfor
		endfor									
	endif			
	
	
	If(LoadCount==0)										//Print summary
		Print "No file loaded"
	elseif(LoadCount==1)
		Print "1 file loaded"
	else
		Print LoadCount, "files loaded"
	endif
	
	FCSShowData(DCurrent)

	KillWaves/Z FolderFileList
	SetDataFolder dfSave
End


//**************************************
Function LeicacsvLoad(FileName)								//Load a single .csv file
	String FileName
	
	String tmpfn
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR DModel
	NVAR DMax,DEnd, DLast, LoadedCount
	NVAR NumOfLoads=root:FCS:NumOfLoads 
	NVAR NumOfRuns=root:FCS:NumOfRuns
	WAVE/T DataNameIndex, FileNameIndex, ModelNameIndex, ModelList, DataNameApp
	WAVE   DataNumIndex,IsValid, ModelIndex, Intensity1, Intensity2, AcquisitionTime, ValidColumns
	
	If (DLast>=DMax-1)										//Data number control
		Print "Exceed maximum data number of", DMax
		SetDataFolder dfSave
		return 0
	Endif
	
	Variable i
	Open /R/Z i as FileName									//Test the existence of the file
	if(V_flag!=0)
		Print "Cannot open file", FileName
		SetDataFolder dfSave
		return 0
	endif
	Close i
	
	for(i=0;i<=7;i+=1)
		tmpfn="TempLoadedData"+num2str(i)
		KillWaves/Z $tmpfn
	endfor
	
	for(i=0;i<=2;i+=1)
		tmpfn="TempLoadedMissedData"+num2str(i)
		KillWaves/Z $tmpfn
	endfor
	
	if(NumOfLoads==1)
	//tmpfn="TempLoadedData"+num2str(ValidColumns[0]-1)
	tmpfn="TempLoadedData3"
	endif
	if(NumOfLoads==3)
	tmpfn="TempLoadedData7"
	endif
	
	LoadWave/Q/D/G/N=TempLoadedData FileName 			//Load data and intensity
	LoadWave/Q/D/J/L={0,4,1,0,2}/N=TempLoadedMissedData FileName
	if(!WaveExists($tmpfn))									//If file loaded incorrectly
		Print "Error loading file", FileName
		SetDataFolder dfSave
		return 0
	endif

	DLast+=1
	FCSUpdateDLast()
	
	LoadedCount+=1
	
	String ShortName=FCSGetShortName(FileName)
	
	WAVE/Z TempLoadedData0, TempLoadedData1, TempLoadedData2, TempLoadedData4, TempLoadedData6
	//WAVE/Z TempLoadedData7, TempLoadedData8, TempLoadedData10, TempLoadedData11, TempLoadedData12
	//WAVE/Z TempLoadedData13, TempLoadedData14, TempLoadedData15, TempLoadedData19, TempLoadedData20
	//WAVE/Z TempLoadedData21, TempLoadedData22, TempLoadedData23
	WAVE/Z TempLoadedMissedData0, TempLoadedMissedData1
	
	Make/O/N=(numpnts(TempLoadedData1)) taufile=TempLoadedData1
	
	NVAR XStart, XEnd
	
	if(NumOfLoads==1)		// which waves are necessary
		ShortName=DataNameApp[0]+Shortname
		Make/O/N=(numpnts(TempLoadedData2)) corfile=TempLoadedData2
		Make/O/N=1 timefile=0
		Make/O/N=(numpnts(TempLoadedMissedData0)) intfile1=TempLoadedMissedData0
		Make/O/N=(numpnts(TempLoadedMissedData0)) intfile2=intfile1

	endif
	
	if(NumOfLoads==3)
		Make/O/N=1 timefile=0
		Make/O/N=(numpnts(TempLoadedMissedData0)) intfile1=TempLoadedMissedData0
		Make/O/N=(numpnts(TempLoadedMissedData1)) intfile2=TempLoadedMissedData1
		if(NumOfRuns==1)
		ShortName=DataNameApp[0]+Shortname
		Make/O/N=(numpnts(TempLoadedData2)) corfile=TempLoadedData2
		endif
		if(NumOfRuns==2)
		ShortName=DataNameApp[1]+Shortname
		Make/O/N=(numpnts(TempLoadedData4)) corfile=TempLoadedData4
		endif
		if(NumOfRuns==3)
		ShortName=DataNameApp[2]+Shortname
		Make/O/N=(numpnts(TempLoadedData6)) corfile=TempLoadedData6
		endif
	endif

	XStart=1															//YH
	XEnd=150														//YH

	FileNameIndex[DLast] =FileName						//Set the data index
	DataNameIndex[DLast] =ShortName
	DataNumIndex[DLast]  =LoadedCount
	IsValid[DLast]       =1
	//WaveStats/Q intfile1							//Average intensity A
	//Intensity1[DLast]    =V_avg
	Intensity1[DLast] = intfile1
	//WaveStats/Q intfile2							//Average intensity B
	Intensity2[DLast] =intfile2
	//WaveStats/Q timefile
	//AcquisitionTime[DLast]=V_max
	AcquisitionTime[DLast] = 0
	ModelIndex[DLast]    =DModel
	ModelNameIndex[DLast]=ModelList[DModel]
		
	String XDat="X_"+num2str(LoadedCount)					//Create memory data set
	String YDat="Y_"+num2str(LoadedCount)
	
	Make/O/N=(numpnts(TempLoadedData1)) $XDat, $YDat
	WAVE XData=$XDat
	WAVE YData=$YDat
	XData=taufile
	YData=corfile
//Thorsten
	String i1dat="I1_"+num2str(LoadedCount)					//Create memory data set
	String i2dat="I2_"+num2str(LoadedCount)
	String xidat="XI_"+num2str(LoadedCount)
	
	Make/O/N=(numpnts(timefile)) $i1dat,$i2dat,$xidat
	WAVE I1Data=$i1dat
	WAVE I2Data=$i2dat
	WAVE XIData=$xidat
	I1Data=intfile1
	I2Data=intfile2
	XIData=timefile
//Thorsten End
	
	FCSCreatFittingParameters(DLast, LoadedCount, DModel)
//	FCSShowData(DLast)

	DEnd=DLast												//Expand the selected range
	UpdateDPointersDisplay()
	
//	printf "File loaded successfully \"%s \" as \"%s\", DataNumIndex = %d\r",FileName, ShortName, LoadedCount
	KillWaves/Z taufile,corfile,timefile,intfile1,intfile2
	SetDataFolder dfSave
	return 1
End










//**********************************
Function OnCheckPicoQuantClick(ctrlName,checked) : CheckBoxControl					//mode: autocorrelation or cross-correlation
	String ctrlName
	Variable checked			// 1 if checked, 0 if not
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
		
	NVAR NumOfLoads=root:FCS:NumOfLoads
	
	strswitch (ctrlName)
		case "PicoQuantSAuto":
			NumOfLoads = 1
			Make/O/T/N=1 DataNameApp="SA-"
			break
		case "PicoQuantTri":
			NumOfLoads = 3
			Make/O/T/N=3 DataNameApp={"GA-","RA-","AB-"}
			break
	endswitch
	
	CheckBox PicoQuantSAuto,value= NumOfLoads==1
	CheckBox PicoQuantTri,value= NumOfLoads==3
	
	SetDataFolder dfSave 
End

//**********************************									//Thorsten
Function OnOpendatFileClick(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	DatOpenFilename()
	
End

//**********************************// For PicoQuant FCS
Function OnLoaddatClick(ctrlName) : ButtonControl
	String ctrlName

	NVAR LoadFirst=root:FCS:LoadFirst, LoadLast=root:FCS:LoadLast
	SVAR PathName=root:FCS:PathName,   FileName=root:FCS:FileName
	
	FCSdatLoadAll(PathName)	
	DoWindow/K FCSFileControl
	
	NVAR DLast=root:FCS:DLast
	FCSShowData(DLast)

	NVAR DCurrent=root:FCS:DCurrent
	FCSB2F(DCurrent)
End

//********************************************	//For PicoQuant FCS					
Function DatOpenFilename()							//Let the user chose the path and filename
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	SVAR PathName, FileName
	String tempName, FormatString=""
	
	Variable refNum
	PathInfo /S PathName			//Set the path used in open to PathName
	Open /D/R/M="Chose any of the files in the directory..."/T=".dat"/Z refNum as PathName+":*.dat"		//Show the open file dialog

	Variable 	Len=strlen(S_FileName)
	if(V_flag==0&&Len>0)						//If the dialog is not canceled
		Variable i=0,j=0,k=0
		for(i=0;i<Len;i+=1)				//Counting directory seperator ':'
			if(!cmpstr(S_FileName[i],":"))
				j=i
			endif
		endfor
		PathName=S_FileName[0,j-1]	//Get path name
		
		for(i=j;i<Len;i+=1)			//The extension name is the characters after the last '.'
			if(!cmpstr(S_FileName[i],"."))
				k=i
			endif
		endfor
		if(k==0)						//if no extension name
			k=Len
		endif
		FileName=S_FileName[j+1,k-1]	

	endif
	
	SetDataFolder dfSave
End


//**************************************
Function FCSdatLoadAll(PathName)							//Load all the .dat file in one directory
	String PathName
	
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NewPath/O/Q DataFolder PathName
	variable i,j,k=0,LoadCount=0
	String FileList
	NVAR UseSameWindow, DLast,DCurrent
	NVAR NumOfLoads=root:FCS:NumOfLoads			
	NVAR NumOfRuns=root:FCS:NumOfRuns			
	
	FileList=IndexedFile(DataFolder,-1,".dat")			//Counting files
	for(i=0;i<strlen(FileList);i+=1)
		if(!cmpstr(FileList[i],";"))
			j+=1
		endif
	endfor
	if(j==0)
		Print "No file in the folder"
	else
		Make/O/T/N=(j) FolderFileList
		for(i=0;i<j;i+=1)									//Creat file list
			FolderFileList[i]=IndexedFile(DataFolder,i,".dat")
		endfor
		
		Sort FolderFileList, FolderFileList				//Sort filelist
		
		For(k=1;k<=NumOfLoads;k+=1)			
				NumOfRuns=k					
			for(i=0;i<j;i+=1)									//Load files
				if(PicoQuantdatLoad(PathName+":"+FolderFileList[i]))
					LoadCount+=1
					if(!UseSameWindow)
						FCSShowData(DLast)
					endif
				endif
			endfor
		endfor									
	endif			
	
	
	If(LoadCount==0)										//Print summary
		Print "No file loaded"
	elseif(LoadCount==1)
		Print "1 file loaded"
	else
		Print LoadCount, "files loaded"
	endif
	
	FCSShowData(DCurrent)

	KillWaves/Z FolderFileList
	SetDataFolder dfSave
End
//***********************************//************************************November 2 2017, ASHWINNVS
Function/S naming(str,a)			//Function to get the header name out of a header line stored as a string
	String str
	Variable a
	String name=""
	Make /O /N=200 k
	Variable b,m
	Variable adr=0,x=0
	Variable counter=0,i

 	for (i=0; i<strlen(str); i+=1)
 	if((char2num(str[i]) ==9 || char2num(str[i])==32)&&(char2num(str[i+1]) !=40))		//Modified to read fccs data names as well
			k[counter]=i
			counter=counter+1
		 else    
 			x=x+1   
  		endif
 	endfor
 
	 // storing the header name and returning individual .ptu names
 	b=a+1
 	if (b==1)
 		for (m=0;m<k[0];m+=1)
 			if(char2num(str[m]) !=32)
				 name[adr]=str[m]
			 	adr=adr+1
			 else
				 m=k[1]
			 endif
		 endfor
		 
	 else 
	 	for(m=(k[(5*(a))-1]+1);m<k[5*a];m+=1)
		 	if(char2num(str[m]) !=32)	
	 			name[adr]=str[m]
				 adr=adr+1
			 else
				 m=k[(5*a) +1]
			  endif
 		endfor 
 	endif
 
	return name

End
 
 

//**************************************Modified 2 November 2017 ASHWINNVS
Function PicoQuantdatLoad(FileName)								//Load a single .dat file

	String FileName
	String tmpfn,str
	String dfSave=GetDataFolder(1)
	SetDataFolder root:FCS
	
	NVAR DModel
	NVAR DMax,DEnd, DLast, LoadedCount
	NVAR NumOfLoads=root:FCS:NumOfLoads 
	NVAR NumOfRuns=root:FCS:NumOfRuns
	WAVE/T DataNameIndex, FileNameIndex, ModelNameIndex, ModelList, DataNameApp
	WAVE   DataNumIndex, IsValid, ModelIndex, Intensity1, Intensity2, AcquisitionTime, ValidColumns
	
	If (DLast>=DMax-1)										//Data number control
		Print "Exceed maximum data number of", DMax
		SetDataFolder dfSave
		return 0
	Endif
	
	Variable i,p
	Open /R/Z i as FileName	
	FReadLine i, str
								//Test the existence of the file
	if(V_flag!=0)
		Print "Cannot open file", FileName
		SetDataFolder dfSave
		return 0
	endif
	
	Close i
		
	for(i=0;i<73;i+=1)
	
		tmpfn="TempLoadedData"+num2str(p)
		KillWaves/Z $tmpfn
	endfor
			
	LoadWave/Q/D/G/N=TempLoadedData FileName 			//Load data and intensity
	String LoadedWaves=Wavelist("TempLoadedData*",";","")
	Variable LoadedNum=ItemsinList(LoadedWaves)
	
	if(!WaveExists($tmpfn))									//If file loaded incorrectly
		Print "Error loading file", FileName
		SetDataFolder dfSave
		return 0
	endif

	String ShortName=FCSGetShortName(FileName)
		
	NVAR XStart, XEnd
	variable size
	if(NumOfLoads==1)
	size=LoadedNum/3
	endif
	
	if(NumOfLoads==3)
	size=LoadedNum/9
	endif
	for ( i=0; i<size;i+=1)					// this loop finds and assigns the coloum data from each .ptu file into waves and loads them into the program for fitting 
		String xyz=naming(str,i)
			if (strlen(xyz)==0)				// this condition is to check and avoid empty repeated data 
				i=size+1
			else
			// which waves are necessary
				if(NumOfLoads==1)				//2017-12-07 new change for fccs	
					ShortName=DataNameApp[0]
					String bigx= "TempLoadedData"+num2str(3*i)
					wave bx=$bigx
					String bigy="TempLoadedData"+num2str((3*i)+1)
					wave by=$bigy
					String bigz="TempLoadedData"+num2str((3*i)+2)
					wave bz=$bigz
					Make/O/N=(numpnts(by)) taufile=(bx) * 0.001 // convert the time into s; the PicoQuant file uses ms
					Make/O/N=(numpnts(bz)) corfile=by
					Make/O/N=1 timefile=0
		
					Make/O/N=(numpnts(bx)) intfile1=0
					Make/O/N=(numpnts(by)) intfile2=0
				endif
				
			// Picoquant ascii data- Each data set contains, 9 coloumns, so the division has been made in the following manner
				if(NumOfLoads==3)			
					Make/O/N=1 timefile=0
					
					if(NumOfRuns==1)
						ShortName=DataNameApp[0]
						String abigx= "TempLoadedData"+num2str(9*i+3)			//GA values go from 4th-6th coloumns
						wave abx=$abigx
						String abigy="TempLoadedData"+num2str((9*i)+4)
						wave aby=$abigy
						String abigz="TempLoadedData"+num2str((9*i)+5)
						wave abz=$abigz
						String name1
						name1=naming(str,3*i+1)
						Make/O/N=(numpnts(aby)) taufile=(abx) * 0.001 // convert the time into s; the PicoQuant file uses ms
						Make/O/N=(numpnts(abz)) corfile=aby
				
						Make/O/N=(numpnts(abx)) intfile1=0
						Make/O/N=(numpnts(aby)) intfile2=0
					endif
					
					if(NumOfRuns==2)
					String name2
						ShortName=DataNameApp[1]
						String bbigx= "TempLoadedData"+num2str(9*i+6)		//RA values go from 7th-9th coloumns
						wave bbx=$bbigx
						String bbigy="TempLoadedData"+num2str((9*i)+7)
						wave bby=$bbigy
						String bbigz="TempLoadedData"+num2str((9*i)+8)
						wave bbz=$bbigz
						name2=naming(str,3*i+2)
					
						Make/O/N=(numpnts(bby)) taufile=(bbx) * 0.001 // convert the time into s; the PicoQuant file uses ms
						Make/O/N=(numpnts(bbz)) corfile=bby
						Make/O/N=(numpnts(bbx)) intfile1=0
						Make/O/N=(numpnts(bby)) intfile2=0
					endif
					
					if(NumOfRuns==3)
						ShortName=DataNameApp[2]
						String name3
						String cbigx= "TempLoadedData"+num2str(9*i)		//AB values go from 1st-3rd coloumns
						wave cbx=$cbigx
						String cbigy="TempLoadedData"+num2str((9*i)+1)
						wave cby=$cbigy
						String cbigz="TempLoadedData"+num2str((9*i)+2)
						wave cbz=$cbigz
						name3=naming(str,3*i)
				
						Make/O/N=(numpnts(cby)) taufile=(cbx) * 0.001 // convert the time into s; the PicoQuant file uses ms
						Make/O/N=(numpnts(cbz)) corfile=cby
						Make/O/N=(numpnts(cbx)) intfile1=0
						Make/O/N=(numpnts(cby)) intfile2=0
				
					endif
					endif
				XStart=1															//YH
				XEnd=250				
	
				DLast+=1
				FCSUpdateDLast()
	
				LoadedCount+=1										//YH

				FileNameIndex[DLast] =	Filename	
				//Set the data index
				if(NumOfLoads==1)	
					DataNameIndex[DLast] =ShortName+naming(str,i)			//Data name index is better put here
				endif
				
				if(NumOfLoads==3)	
					if(NumOfRuns==1)
						DataNameIndex[DLast] =ShortName+name1
					endif	
					
					if(NumOfRuns==2)
						DataNameIndex[DLast] =ShortName+name2
					endif
					
					if(NumOfRuns==3)
						DataNameIndex[DLast] =ShortName+name3	
					endif
					
				endif					//Shows the name of the file currently being used
				DataNumIndex[DLast]  =LoadedCount
				IsValid[DLast]       =1
				//WaveStats/Q intfile1							//Average intensity A
				//Intensity1[DLast]    =V_avg
				Intensity1[DLast] = intfile1
				//WaveStats/Q intfile2							//Average intensity B
				Intensity2[DLast] =intfile2
				//WaveStats/Q timefile
				//AcquisitionTime[DLast]=V_max
				AcquisitionTime[DLast] = 0
				ModelIndex[DLast]    =DModel
				ModelNameIndex[DLast]=ModelList[DModel]
				
				String XDat="X_"+num2str(LoadedCount)					//Create memory data set
				String YDat="Y_"+num2str(LoadedCount)
	
				Make/O/N=(numpnts(TempLoadedData0)) $XDat, $YDat
				WAVE XData=$XDat
				WAVE YData=$YDat
				XData=taufile
				YData=corfile

				String i1dat="I1_"+num2str(LoadedCount)					//Create memory data set
				String i2dat="I2_"+num2str(LoadedCount)
				String xidat="XI_"+num2str(LoadedCount)
	
				Make/O/N=(numpnts(timefile)) $i1dat,$i2dat,$xidat
				WAVE I1Data=$i1dat
				WAVE I2Data=$i2dat
				WAVE XIData=$xidat
				I1Data=intfile1
				I2Data=intfile2
				XIData=timefile
	
				FCSCreatFittingParameters(DLast, LoadedCount, DModel)
				FCSShowData(DLast)

				DEnd=DLast												//Expand the selected range
				UpdateDPointersDisplay()
	
			//		printf "File loaded successfully \"%s \" as \"%s\", DataNumIndex = %d\r",FileName, ShortName, LoadedCount
				KillWaves/Z taufile,corfile,timefile,intfile1,intfile2
			
				SetDataFolder dfSave
				
			endif
	endfor
	
End




//***********************************************************************************************
//*********************************************************





