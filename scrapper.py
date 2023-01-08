import requests
from bs4 import BeautifulSoup as bs
#scrapes data from web using the link given by user
def scrape(link):
    page=requests.get(link)
    soup= bs(page.content,"html.parser")
    img=[] #stores the image of the product
    if soup.find_all("div",class_="imgTagWrapper")!=None:
        for item in soup.find_all("img",class_="_2r_T1I _396QI4"):
            img.append(item.get('src'))
        names=soup.find("span",class_="B_NuCI") #stores the title of product
        return names.text, img, suggestions(soup)
    elif soup.find_all("img",class_="hCL kVc L4E MIw")!=None:
        for item in soup.find_all("img",class_="hCL kVc L4E MIw"):
            img.append(item.get('src'))
        names=soup.find("span",class_="B_NuCI")
        return img[0],names.text
#these are suggestions of products which are given by the web according to the user
def suggestions(soup):
    suggestions_images=[]  #stores the product images of the suggestions
    suggestions_names=[]   #stores the names of the product suggestions
    if soup.find_all("img",class_="_2r_T1I")!=None:
        for i in soup.find_all("img",class_="_2r_T1I"):
            suggestions_images.append(i.get('src'))
        for i in soup.find_all("a",class_="s1Q9rs _2zdixn"):
            suggestions_names.append(i.text)
    return suggestions_images, suggestions_names