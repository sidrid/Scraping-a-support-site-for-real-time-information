# -*- coding: utf-8 -*-
"""
Created on Wed Jan 11 22:48:13 2017

@author: ebiw
"""

import requests
import csv
import pandas as pd
page = requests.get("https://discussions.apple.com/community/iphone/using_iphone?page=1")
from bs4 import BeautifulSoup
soup = BeautifulSoup(page.content, 'html.parser')
html = list(soup.children)[2]
body = list(html.children)[3]
list(body.children)
#############################################
soup = BeautifulSoup(page.content, 'html.parser')
soup.find_all('p')
soup.find_all('p')[0]
userinf = soup.find_all('a', class_='jiveTT-hover-user jive-username-link')
links = [l for l in userinf if '/people/' in l['href']]
######################################################################################
hrefs = [a['href'].strip() for a in links]
## print(hrefs)

dav = [a['data-avatarid'].strip() for a in links]
## print(dav)
dan = [a['data-username'].strip() for a in links]
## print(dan)
soup.find_all('span', class_='discussion-description-inner')
usercom = soup.find_all('span', class_='discussion-description-inner')
comments = [l.get_text().strip() for l in usercom]
## print(comments)
views = soup.find_all('div', class_='discussion-views')
numvs = [l.get_text().strip() for l in views]
## print(numvs)

Avatarname = soup.find_all('a', class_='jiveTT-hover-user jive-username-link')
fname = [l.get_text() for l in Avatarname]
## print(fname)

posts = pd.DataFrame({
        "UserName": dan[:15], 
        "Avatar": dav[:15], 
        "UserURL": hrefs[:15], 
        "Comments":comments[:15],
        "NumViews":numvs[:15],
        "AvatarName":fname[:15]
    })
posts.to_csv('apple_.csv',sep=',',mode='a',index=False,header=False,quoting=csv.QUOTE_ALL)
print("Test done")