#!/usr/bin/env python
# coding: utf-8

# In[17]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# In[18]:


# Loading data and concatenating datagrames into single dataframe
df_loans2018Q3 = pd.read_csv('C:/Users/ramie/Desktop/dv01 Loan Data/csv/LoanStats_securev1_2018Q3.csv', dtype={'0': int})
df_loans2018Q4 = pd.read_csv('C:/Users/ramie/Desktop/dv01 Loan Data/csv/LoanStats_securev1_2018Q4.csv', dtype={'0': int})
df_loans2019Q1 = pd.read_csv('C:/Users/ramie/Desktop/dv01 Loan Data/csv/LoanStats_securev1_2019Q1.csv', dtype={'0': int}, low_memory=False)

df_loans = pd.concat([df_loans2018Q3, df_loans2018Q4, df_loans2019Q1])
df_loans.head()


# In[19]:


# Checking null values

pd.isnull(df_loans).sum()


# In[4]:


# Checking for total number of rows and columns in dataset, datatypes, and memory usage
df_loans.info()


# In[5]:


# Adding Loan_Status_Category as a column to determine Status of Loans
conditions = [
    (df_loans['loan_status'].isin(['Fully Paid', 'Current', 'In Grace Period'])),
    (df_loans['loan_status'].isin(['Late (16-30 days)', 'Late (31-120 days)'])),
    (df_loans['loan_status'].isin(['Charged Off', 'Default']))
]
values = ['Good Standing', 'Late', 'Not in Good Standing']

df_loans['loan_status_category'] = np.select(conditions, values, default='Unknown')

print(df_loans['loan_status_category'].head())


# In[21]:


#Distribution of Loan Amounts
plt.figure(figsize=(12, 8))
sns.histplot(df_loans['loan_amnt'], kde=False)
plt.xlabel('Loan Amount')
plt.ylabel('Frequency')
plt.title('Distribution of Loan Amounts')
plt.show()


# In[16]:


# Displaying Average Interest Rate by Loan Grades
df_loans['int_rate'] = df_loans['int_rate'].round(decimals=0).astype(int)

df_loans.sort_values("grade", inplace=True)
df_loans['grade'] = df_loans['grade'].astype(str)

plt.figure(figsize=(12, 8))
sns.barplot(x='grade', y='int_rate', data=df_loans, estimator=np.mean)
plt.xlabel('Loan Grade')
plt.ylabel('Average Interest Rate')
plt.title('Average Interest Rate by Loan Grade')
plt.show()


# In[26]:


# Counting the occurrences of each loan status category
status_counts = df_loans['loan_status_category'].value_counts()

plt.bar(status_counts.index, status_counts.values)
plt.xlabel('Loan Status Category')
plt.ylabel('Number of Loans')
plt.title('Loan Status Distribution')
plt.show()


# In[23]:


# Categorizing loan status by good standing, late, or not in good standing
good_standing = ['Fully Paid', 'Current', 'In Grace Period']
late = ['Late (16-30 days)', 'Late (31-120 days)']
not_good_standing = ['Charged Off', 'Default']
df_loans['loan_status_category'] = df_loans['loan_status'].apply(lambda x: 'Good Standing' if x in good_standing else ('Late' if x in late else 'Not in Good Standing'))

status_counts = df_loans.groupby(['loan_status_category', 'grade']).size().reset_index(name='counts')
status_counts_pivot = status_counts.pivot(index='loan_status_category', columns='grade', values='counts')
status_counts_pivot.plot(kind='bar', stacked=True)

plt.xlabel('Loan Status Category')
plt.ylabel('Number of Loans')
plt.title('Loan Status Distribution by Loan Grade')
plt.show()


# In[22]:


# A better view of Late/Good Standing
good_standing = ['Fully Paid', 'Current', 'In Grace Period']
late = ['Late (16-30 days)', 'Late (31-120 days)']
not_good_standing = ['Charged Off', 'Default']
df_loans['loan_status_category'] = df_loans['loan_status'].apply(lambda x: 'Good Standing' if x in good_standing else ('Late' if x in late else 'Not in Good Standing'))

status_counts = df_loans.groupby(['loan_status_category', 'grade']).size().reset_index(name='counts')
status_counts = status_counts[status_counts['loan_status_category'] != 'Good Standing']
status_counts_pivot = status_counts.pivot(index='loan_status_category', columns='grade', values='counts')
status_counts_pivot.plot(kind='bar', stacked=True)

plt.xlabel('Loan Status Category')
plt.ylabel('Number of Loans')
plt.title('Loan Status Distribution by Loan Grade (Late vs Not in Good Standing)')
plt.show()

