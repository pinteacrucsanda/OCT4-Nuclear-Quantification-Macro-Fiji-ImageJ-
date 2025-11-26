# OCT4-Nuclear-Quantification-Macro-Fiji-ImageJ-
A Fiji/ImageJ macro for nuclear segmentation using DAPI and per-cell quantification of OCT4 (488 nm). Designed for NPC and iPSC characterization workflows where confirming OCT4 negativity is essential.
This macro imports .czi files via Bio-Formats, segments nuclei from DAPI, measures OCT4 intensity inside each nucleus, and outputs masks, overlays, and per-cell quantitative tables.

✨ Features

Direct .czi import using Bio-Formats.

Automatic channel separation:

C1 = OCT4 (488 nm)

C2 = DAPI

Robust nuclear segmentation using:

CLAHE

Gaussian blur

Auto Local Threshold (Bernsen)

Hole filling + Watershed

Adaptive nuclear size filtering (two-pass estimation).

Per-cell measurements:

Nuclear area

Mean OCT4 intensity

Automatic export of:

Nuclear masks (DAPI & OCT4)

Overlays

Per-cell CSV file

Compatible with images without Z-stacks.

🧬 Requirements

Fiji/ImageJ

Bio-Formats plugin (bundled in Fiji)

.czi files with the channel order:

Channel 1: OCT4 (488 nm)

Channel 2: DAPI

▶️ How to Use

Open Fiji/ImageJ.

Go to Plugins → Macros → Run… and load the macro file.

Choose a .czi image when prompted.

Select an output folder.

The macro will automatically generate:

sample_DAPI_nuclei_mask.tif
sample_OCT4_nuclei_mask.tif
sample_DAPI_overlay.tif
sample_OCT4_overlay.tif
sample_per_cell_results.csv

📂 Output Files

_DAPI_nuclei_mask.tif — binary nuclear mask

_OCT4_nuclei_mask.tif — nuclear ROIs projected on OCT4 channel

_DAPI_overlay.tif — DAPI with nuclei ROIs overlay

_OCT4_overlay.tif — OCT4 with nuclei ROIs overlay

_per_cell_results.csv — cell-by-cell area and OCT4 intensity

This project is distributed under the MIT License.

See the full text below.

MIT License

Copyright (c) 2025 Rucsanda Pinteac

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
