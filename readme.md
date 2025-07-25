# SuREVizHeart: A Web-Based SuRE MPRA Data Exploration Tool

An R shiny platform designed for exploring the functional impact of genetic variants assessed by the SuRE (Survey of Regulatory Elements) massively parallel reporter assay. SuREVizHeart empowers researchers and data enthusiasts with interactive tools to visualize the interplay between genomic variants and gene regulation to predict genetic consequences variants.

---

## 🌟 Key Features

✨ **Interactive Visualization**: Explore over 4.7 million variants categorized into raQTLs and non-raQTLs.  
✨ **Genomic Data Integration**: Combines functional, genomic, and clinical datasets for enriched insights.  
✨ **Custom Data Upload**: Easily compare user-provided MPRA data, BigWig, and BED files.  
✨ **Flexible Querying**: Search by variants (`chr:pos`) or gene name.  
✨ **Downloadable Results**: Export your analyzed data in user-friendly formats.  

---

## 🔬 Data Sources

- **Processed Data**: Available on OSF at [pyh83](https://osf.io/pyh83/).  

---

## 🔬 What is SuRE?

SuRE (Survey of Regulatory Elements) is a high-throughput assay used to study gene regulation. It maps allele-specific expression back to the genome, allowing researchers to assess changes in regulatory activity upon the introduction of SNPs and InDels. The current SuREVizHeart application showcases data from heart-related studies, including six complex plasmid libraries representing 4.7 million variants.  

### 🧬 What are raQTLs?  
**Reporter Assay Quantitative Trait Loci (raQTLs)** are variants showing significant differences in expression between reference and alternate alleles, highlighting the regulatory impact of variants. Refer to [High-throughput identification of human SNPs affecting regulatory element activity](https://doi.org/10.1038/s41588-019-0455-2) for a detailed explanation.

---

## 🚀 Getting Started

To begin your journey with SuREVizHeart:  
1. Access the platform here: **[SuREVizHeart](http://195.114.233.102:3838/)**  
2. Liftover your queries to hg38 genome assembly before using the application. 

---


## 🎓 Tutorial

Get started quickly with our detailed step-by-step tutorial:  
👉 **[SuREVizHeart Tutorial](https://vartikabisht6197.github.io/SuREVizHeart/SuREVizHeartTutorial.html)** 👈  


## 📝 MIT License

Copyright (c) 2025 annogen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
