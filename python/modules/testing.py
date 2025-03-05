from selenium import webdriver
from selenium.webdriver.common.by import By
import pandas as pd
import time
from bs4 import BeautifulSoup

is_debugging = 1

wtb_1_any_ds_url   = "https://finance.yahoo.com/quote/"
wtb_2_any_ds_path  = "NVDA/history/?period1=1709544776&period2=1741080767&filter=history" 
wtb_3_any_ni_index = 0


# Initialize the WebDriver (e.g., Chrome)
driver = webdriver.Chrome()

# Open the webpage
driver.get(wtb_1_any_ds_url + wtb_2_any_ds_path)

# Wait for the page to load (you might need to adjust the sleep time)
time.sleep(5)

# Find and click the "Accept Cookies" button (adjust the selector as needed)
accept_button = driver.find_element(By.XPATH, '//button[text()="Alles accepteren"]')
accept_button.click()

# Wait for the page to load after accepting cookies
time.sleep(5)

# Get the page source after accepting cookies
page_source = driver.page_source

# Parse the page source with BeautifulSoup
soup = BeautifulSoup(page_source, 'html.parser')

# Find the table in the webpage (you might need to adjust the selector based on the webpage structure)
table = soup.find('table')

# Read the table into a pandas DataFrame
df = pd.read_html(str(table))[wtb_3_any_ni_index]

# Display the DataFrame
print(df)

# Close the browser
driver.quit()