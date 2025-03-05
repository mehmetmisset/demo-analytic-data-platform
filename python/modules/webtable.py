# Import required libraries
import pandas as pd
import time

# from ... Import
from selenium.webdriver.common.by import By
from selenium                     import webdriver
from bs4                          import BeautifulSoup
from io                           import StringIO

def webtable(# Source Parameters":
             wtb_1_any_ds_url, wtb_2_any_ds_path, wtb_3_any_ni_index,

             # Debugging
             is_debugging):

    # If is Debugging then show imput parameters
    if (is_debugging == 1):
        print("wtb_1_any_ds_url   : '" + wtb_1_any_ds_url + "'")
        print("wtb_2_any_ds_path  : '" + wtb_2_any_ds_path + "'")
        print("wtb_3_any_ni_index : '" + wtb_3_any_ni_index + "'")

    # Initialize the WebDriver (e.g., Chrome)
    driver = webdriver.Chrome()

    # Open the webpage
    driver.get(wtb_1_any_ds_url + wtb_2_any_ds_path)

    # Wait for the page to load (you might need to adjust the sleep time)
    time.sleep(2)

    try:
        # Find and click the "Accept Cookies" button (adjust the selector as needed)
        accept_button = driver.find_element(By.XPATH, '//button[text()="Alles accepteren"]')
        accept_button.click()
    except Exception as e:
        # Code to handle any other exceptions
        print(f"An unexpected error occurred: {e}")        

    # Wait for the page to load after accepting cookies
    time.sleep(2)

    # Get the page source after accepting cookies
    page_source = driver.page_source

    # Close the browser
    driver.quit()
    
    # Parse the page source with BeautifulSoup
    soup = BeautifulSoup(page_source, 'html.parser')
    
    # Create a StringIO object
    table = StringIO()

    # Find the table in the webpage (you might need to adjust the selector based on the webpage structure)
    table.write(str(soup.find('table')))

    # Read the table into a pandas DataFrame
    df = pd.read_html(table.getvalue())[int(wtb_3_any_ni_index)]

    # Display the DataFrame if in dubug-mode
    if (is_debugging == 1):
        print(df)

    return df
