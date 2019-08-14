import sys
import requests
from bs4 import BeautifulSoup
url = sys.argv[1]
#html = request.urlopen(url).read().decode('utf8')
page = requests.get(url)

soup = BeautifulSoup(page.text, 'html.parser')

title = soup.title

print(title.string)
#print(soup.text)

#print(title)
#html = request.urlopen(url).read().decode('utf8')
#html[:60]

#from bs4 import BeautifulSoup
#soup = BeautifulSoup(html, 'html.parser')
#title = soup.title
#print(title)
