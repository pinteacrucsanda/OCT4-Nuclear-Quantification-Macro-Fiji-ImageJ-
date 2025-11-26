// ===== OPEN CZI =====
inputPath = File.openDialog("Choose CZI file");
run("Bio-Formats Importer",
    "open=[" + inputPath + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");

// Guarda el título
origTitle = getTitle();

// Trabaja directamente con la imagen original (no hay Z-stack)
projTitle = origTitle;

// ===== SPLIT CHANNELS DIRECTAMENTE =====
selectWindow(projTitle);
run("Split Channels");

// C1 = OCT4 (488), C2 = DAPI SIEMPRE porque lo has verificado manualmente
selectWindow("C1-" + projTitle);
rename("OCT4");

selectWindow("C2-" + projTitle);
rename("DAPI");


// ===== SEGMENTACIÓN DAPI =====
selectWindow("DAPI");
run("Duplicate...", "title=DAPI_work");
selectWindow("DAPI_work");
run("8-bit");
run("Enhance Local Contrast (CLAHE)", "blocksize=50 histogram=256 maximum=3");
run("Gaussian Blur...", "sigma=1.5");
run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 white");
run("Fill Holes");
run("Watershed");

// First pass: estimate mean area
roiManager("Reset");
run("Clear Results");
run("Set Measurements...", "area redirect=None decimal=3");

// measure nuclei (first pass)
run("Analyze Particles...", "size=20-200 show=Nothing display clear");

n = nResults;
totalArea = 0;
for (i=0; i<n; i++) totalArea += getResult("Area", i);
meanArea = totalArea / n;
print("Mean area = "+meanArea);

// Second pass with adaptive thresholds
minArea = 0.20 * meanArea;
maxArea = 2.00 * meanArea;

run("Clear Results");
roiManager("Reset");

run("Analyze Particles...",
    "size="+minArea+"-"+maxArea+" circularity=0-1.0 show=Masks display clear add exclude");

dapiMaskTitle = getTitle();
rename("DAPI_nuclei_mask");
dapiMaskTitle = "DAPI_nuclei_mask";

// ===== MIDE OCT4 DENTRO DE LAS ROI =====
selectWindow("OCT4");
run("Clear Results");
run("Set Measurements...", "area mean redirect=None decimal=3");
roiManager("Measure");

nCells = nResults;

// arrays
areaArray   = newArray(nCells);
meanOCT4Arr = newArray(nCells);

for (i=0; i<nCells; i++) {
    areaArray[i]   = getResult("Area", i);
    meanOCT4Arr[i] = getResult("Mean", i);
}

// ===== GENERAR MÁSCARA DE NÚCLEOS PARA OCT4 =====
selectWindow("OCT4");
getDimensions(w,h,c,z,t);

newImage("OCT4_nuclei_mask", "8-bit black", w, h, 1);
selectWindow("OCT4_nuclei_mask");
setForegroundColor(255,255,255);

nROIs = roiManager("count");
for (i=0; i<nROIs; i++) {
    roiManager("Select", i);
    run("Fill");
}

OCT4MaskTitle = "OCT4_nuclei_mask";

// ===== OUTPUT =====
outDir = getDirectory("Choose output folder");

base = origTitle;
dot = lastIndexOf(base, ".");
if (dot != -1) base = substring(base, 0, dot);

selectWindow("DAPI_nuclei_mask");
saveAs("Tiff", outDir + base + "_DAPI_nuclei_mask.tif");

selectWindow("OCT4_nuclei_mask");
saveAs("Tiff", outDir + base + "_OCT4_nuclei_mask.tif");

// overlays
selectWindow("DAPI");
roiManager("Show All");
run("Flatten");
rename("DAPI_overlay");
saveAs("Tiff", outDir + base + "_DAPI_overlay.tif");
close();

selectWindow("OCT4");
roiManager("Show All");
run("Flatten");
rename("OCT4_overlay");
saveAs("Tiff", outDir + base + "_OCT4_overlay.tif");
close();

// table
run("Clear Results");
for (i=0; i<nCells; i++) {
    setResult("Cell", i, i+1);
    setResult("Area", i, areaArray[i]);
    setResult("Mean_OCT4", i, meanOCT4Arr[i]);
}
updateResults();

saveAs("Results", outDir + base + "_per_cell_results.csv");

run("Close All");
showMessage("FIN", "Análisis completado.");
