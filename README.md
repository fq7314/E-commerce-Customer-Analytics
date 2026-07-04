E-Commerce Customer Analytics Project (Hack Your Summer Program)
Start Date: 6/15/2026
End Date: 7/10/2026

Project Overview:

The project is meant to analyze e-commerce data from the Kaggle Online Retail UCI dataset. The project aims to understand customer behavior, revenue trends, product performance, and customer retention. I aim to answer 5 questions:

- Which customers are the most valuable, and what makes them different from regular buyers? 

- Which products bring in most the most revenue? 

- Which customers bought once and never returned, and why might that be? 

- Which customers are at risk of churning (the rate at which customers may stop doing business)? 

- What strategy could realistically improve repeat purchase rates, and how would we measure if it worked? 



In this project, I use SQL, Python, Pandas, Jupyter Notebook, and Tableau 



The Problem/Goal:

My goal is to turn raw e-commerce data into actual business insights that can help small and mid-sized companies. E-commerce businesses tend to collect a lot of data, but many smaller to mid-sized businesses collect data but are not sure how to understand it. The project shows how SQL, Python, and Tableau can clean data, analyze revenue, show top products, and segment users using RFM analysis. This helps business understand their customers, products, and marketing better.



Dataset:

https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci/data

The dataset contains:

- Invoice number
- Stock code
- Product Description
- Quantity
- Invoice date
- Price
- Customer ID
- Country



NOTE: THE SQLITE DATABASE IS NOT IN THE REPO AS IT IS TOO LARGE. To recreate the project, download the dataset, import it into SQLite as 'retail_raw', and run in SQLite (I used /sql as a note keeper for the code I inputted into SQLite) 



Tools Used:

DBrowser/SQL/SQLite: Data cleaning and revenue analysis, running sql queries

Python: Customer segmenetation/RFM and data analysis

Pandas: Data manipulation 

Jupyter Notebook:  Step by step analysis

matplotlib: Visualizations 

Tableau: final dashboard

Github: Presentation of project/documentation



Project Components:

E-commerce-Customer-Analytics
 data/online_retail_II.csv
 sql/01_clean.sql
     02_revenue_analysis.sql
 notebooks/01_rfm_segmentation.ipynb
 dashboards/rfm_segments.png
            rfm_revenue_by_segment.png
            rfm_customer_segments.csv
            rfm_segment_summary.csv
 docs/sql-findings.txt
      rfm-findings.txt
README.md
