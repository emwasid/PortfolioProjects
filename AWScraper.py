#import libraries

from bs4 import BeautifulSoup
import requests
import time
import datetime
import csv
import pandas as pd

#import smtplib for sending emails to yourself 

#Connect to Website
url = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_2?crid=4ONG3VDMNFLQ&keywords=got+data&qid=1655310275&sprefix=%2Caps%2C243&sr=8-2'

# Go to http://httpbin.org/get to get header specific to my computer
headers = { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36", "Accept-Encoding": "gzip, deflate", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9", "DNT":"1", "Connection":"close", "Upgrade-Insecure-Requests": "1"}

page = requests.get(url, headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='productTitle').get_text()
#print(title)

price = soup2.find("span", attrs={"class":"a-offscreen"}).get_text()
#print(price)

title = title.strip()
price = price.strip()[1:]

#print(title)
#print(price)
today = datetime.date.today()


header = ['Title', 'Price', 'Date']
data = [title, price, today]

# with open('AWScraperDataset.csv', 'a+', newline='', encoding='UTF8') as file:
#     writer = csv.writer(file)
#     writer.writerow(data)

df = pd.read_csv('AWScraperDataset.csv')

print(df)


def check_price():
    #Connect To Website
    url = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_2?crid=4ONG3VDMNFLQ&keywords=got+data&qid=1655310275&sprefix=%2Caps%2C243&sr=8-2'

    # Go to http://httpbin.org/get to get header specific to my computer
    headers = { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36", "Accept-Encoding": "gzip, deflate", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9", "DNT":"1", "Connection":"close", "Upgrade-Insecure-Requests": "1"}

    page = requests.get(url, headers=headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id='productTitle').get_text()
    #print(title)

    price = soup2.find("span", attrs={"class":"a-offscreen"}).get_text()
    #print(price)
    title = title.strip()
    price = price.strip()[1:]
    today = datetime.date.today()
    header = ['Title', 'Price', 'Date']
    data = [title, price, today]

    with open('AWScraperDataset.csv', 'a+', newline='', encoding='UTF8') as file:
        writer = csv.writer(file)
        writer.writerow(data)

while(True):
    check_price()
    time.sleep(86400)


df = pd.read_csv('AWScraperDataset.csv')

print(df)

