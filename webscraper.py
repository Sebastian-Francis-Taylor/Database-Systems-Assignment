from bs4 import BeautifulSoup
import requests

url = "https://www.bricklink.com/catalogTree.asp?itemType=S"

headers = {"User-Agent": "Mozilla/5.0"}

page = requests.get(url, headers=headers)
soup = BeautifulSoup(page.text, "html.parser")

years = {}
yearLinks = []

for a in soup.find_all("a", href=True):
    if "itemYear=" in a["href"]:
        year = a.text.strip()
        link = "https://www.bricklink.com/" + a["href"]
        years[year] = link

for year, link in years.items():
    yearLinks.append(link)


for link in yearLinks:
    page = requests.get(link, headers=headers)
    soup = BeautifulSoup(page.text, "html.parser")
    print(page.text)
