import requests
from bs4 import BeautifulSoup
import csv
import random
import unicodedata
from faker import Faker

faker = Faker()

amountAnime = 1




class AnimeTitle:
    def __init__(self, name, genre, amountEp, rate, studio, drawStudio):
        self.name = name
        self.genre = genre
        self.amountEp = amountEp
        self.rate = rate
        self.studio = studio
        self.mangakaId = random.randint(1, 800)
        self.drawStudio = drawStudio

    def printInfo(self):
        print('{' + self.name + ', ' + self.genre + ', ' + str(self.amountEp) + ', ' + str(self.rate) + ', ' + self.studio + ', ' + str(self.mangakaId) + ', ' + self.drawStudio + '}')

    def getName(self):
        return self.name

    def getGenre(self):
        return self.genre

    def getAmountEp(self):
        return self.amountEp

    def getRate(self):
        return self.rate

    def getStudio(self):
        return self.studio

    def getMangakaId(self):
        return self.mangakaId

    def getDrawStudio(self):
        return self.drawStudio


def getAnimeFromPage(urlPage):
    global faker
    response = requests.get(urlPage)
    soup = BeautifulSoup(response.text, 'lxml')

    animeName = soup.find('h1', class_='title-name').find('strong').text
    genre =  soup.find("span", itemprop='genre').text
    amountEp = soup.find('span', id='curEps').text
    rate = soup.find('div', class_='score-label').text

    studio = 'Not Found'
    spans = soup.find_all('span', class_='dark_text')
    for span in spans:
        if (span.text == 'Studios:'):
            studio = span.find_next_sibling('a').text
            break

    studioDraw = faker.word() + ' ' + faker.word() + ' ' + faker.word()

    animeName = '"' + str(unicodedata.normalize('NFKD', animeName).encode('ascii', 'ignore'))[2:-1] + '"'
    studio = str(unicodedata.normalize('NFKD', studio).encode('ascii', 'ignore'))[2:-1]
    return AnimeTitle(animeName, genre, amountEp, rate, studio, studioDraw)

def getAnimeTitels(soup):
    global amountAnime

    animeCards = soup.find_all('tr', class_='ranking-list')
    arrAnimeTitels = list()

    for animeCard in animeCards:
        urlAnimePage = animeCard.find('h3', class_='anime_ranking_h3').find('a').get('href')
        anime = getAnimeFromPage(urlAnimePage)
        arrAnimeTitels.append(anime)
        print('Getted ' + str(amountAnime) + ' title (' + anime.getName() +')...')
        amountAnime += 1

    return arrAnimeTitels

def getAnimesInfoFromPage(urlPage):
    response = requests.get(urlPage)
    soup = BeautifulSoup(response.text, 'lxml')

    animeArr = getAnimeTitels(soup)
    for anime in animeArr:
        anime.printInfo()

    return animeArr

def main_parser_anime():
    baseUrl = 'https://myanimelist.net/topanime.php?limit='
    curLimit = 0
    incrementLimit = 50
    maxLimit = 1000
    amountPages = maxLimit / incrementLimit

    listDataCSV = list()

    for i in range (0, int(amountPages)):
        currentUrl = baseUrl + str(curLimit)

        arrayAnime = getAnimesInfoFromPage(currentUrl)

        for anime in arrayAnime:
            flagExist = False
            for data in listDataCSV:
                if (data[0] == anime.getName()):
                    flagExist = True
                    break
            if flagExist:
                continue
            dataAboutAnime = list()
            dataAboutAnime.append(anime.getName())
            dataAboutAnime.append(anime.getGenre())
            dataAboutAnime.append(anime.getAmountEp())
            dataAboutAnime.append(anime.getRate())
            dataAboutAnime.append(anime.getStudio())
            dataAboutAnime.append(anime.getMangakaId())
            dataAboutAnime.append(anime.getDrawStudio())
            listDataCSV.append(dataAboutAnime)

        curLimit += incrementLimit

    with open('anime_titles.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in listDataCSV:
            writer.writerow(data)

def main_reader_csv_transform():
    arrRows = list()
    with open("./anime_titles.csv", 'r') as file:
        csvreader = csv.reader(file)
        for row in csvreader:
            row[0] = row[0][1:-1]
            arrRows.append(row)

        for row in arrRows:
            print(row[0])

    with open('anime_titles_transformed.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in arrRows:
            writer.writerow(data)

def main_generator_studios():
    studiosNames = list()
    with open("./anime_titles_transformed.csv", 'r') as file:
        csvreader = csv.reader(file)

        for row in csvreader:
            flagExist = False
            for studio in studiosNames:
                if (row[4] == studio):
                    flagExist = True
                    break
            if (flagExist):
                continue

            studiosNames.append(row[4])

    print('Exist in csv anime: ' + str(len(studiosNames)))

    while len(studiosNames) != 1000:
        studiosNames.append(faker.word() + '-' + faker.word() + '_' + faker.word() + '_' + str(faker.random_int(0, 100)))

    dataCSV = list()

    for name in studiosNames:
        newStudio = list()
        newStudio.append(name)
        newStudio.append(faker.random_int(10000, 50000))
        newStudio.append(faker.country())
        newStudio.append(round(random.uniform(1, 10), 2))
        print(newStudio)
        dataCSV.append(newStudio)

    with open('studios.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)


def main_generator_mangaca():
    dataCSV = list()
    id = 1

    for i in range(0, 1000):
        mangaca = list()
        mangaca.append(id)
        id += 1
        randNum  = random.randint(0,1)
        if randNum % 2 == 0:
            mangaca.append(faker.name_male().split(" ")[0])
            mangaca.append(faker.name_male().split(" ")[1])
            mangaca.append(faker.name_male().split(" ")[0])
            mangaca.append('m')
        else:
            mangaca.append(faker.name_female().split(" ")[0])
            mangaca.append(faker.name_female().split(" ")[1])
            mangaca.append(faker.name_male().split(" ")[0])
            mangaca.append('f')
        mangaca.append(round(random.uniform(1, 10), 2))
        mangaca.append(faker.random_int(1, 20))
        dataCSV.append(mangaca)
        print(mangaca)

    with open('mangacas.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)

def main_sounder_generator():
    dataCSV = list()
    id = 1

    for i in range(0, 1000):
        sounder = list()
        sounder.append(id)
        id += 1
        randNum = random.randint(0, 1)
        if randNum % 2 == 0:
            sounder.append(faker.name_male().split(" ")[0])
            sounder.append(faker.name_male().split(" ")[1])
            sounder.append(faker.name_male().split(" ")[0])
            sounder.append('m')
        else:
            sounder.append(faker.name_female().split(" ")[0])
            sounder.append(faker.name_female().split(" ")[1])
            sounder.append(faker.name_male().split(" ")[0])
            sounder.append('f')
        sounder.append(faker.country())
        sounder.append(round(random.uniform(1, 10), 2))
        sounder.append(faker.random_int(50, 500))
        dataCSV.append(sounder)
        print(sounder)

    with open('sounders.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)

def draw_studio_generator():
    studiosDrawNames = list()
    with open("./anime_titles_transformed.csv", 'r') as file:
        csvreader = csv.reader(file)

        for row in csvreader:
            flagExist = False
            for studioDraw in studiosDrawNames:
                if (row[6] == studioDraw):
                    flagExist = True
                    break
            if (flagExist):
                continue

            studiosDrawNames.append(row[6])

    print('Exist in csv anime: ' + str(len(studiosDrawNames)))

    while len(studiosDrawNames) != 1000:
        studiosDrawNames.append(
            faker.word() + '-' + faker.word() + '_' + faker.word() + '_' + str(faker.random_int(0, 100)))

    dataCSV = list()

    styleDraw = ['Chibi', 'Moe', 'Sedze', 'Seinen', 'Dzesei', 'Komodo', 'Senen', 'Realistic', 'Multiplication']

    for name in studiosDrawNames:
        newDrawStudio = list()
        newDrawStudio.append(name)
        newDrawStudio.append(styleDraw[random.randint(0, len(styleDraw) - 1)])
        newDrawStudio.append(faker.random_int(50, 500))
        newDrawStudio.append(round(random.uniform(1, 10), 2))
        print(newDrawStudio)
        dataCSV.append(newDrawStudio)

    with open('drawStudios.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)

def main_n_m_anime_sounder():
    animes = list()
    with open("./anime_titles_transformed.csv", 'r') as file:
        animesData = csv.reader(file)
        for row in animesData:
            animes.append(row)

    sounders = list()
    with open("./sounders.csv", 'r') as file:
        soundersData = csv.reader(file)
        for row in soundersData:
            sounders.append(row)


    dataCSV = list()
    for i in range(0, 350):
        souderId = sounders[random.randint(0, len(sounders) - 1)][0]
        titleSounded = random.randint(1, 3)
        for i in range(0, titleSounded):
            animeName = animes[random.randint(0, len(animes) - 1)][0]
            flagExist = False
            for data in dataCSV:
                if data[0] == animeName and data[1] == souderId:
                    flagExist = True
            if flagExist:
                continue
            newRow = list([souderId, animeName])
            print(newRow)
            dataCSV.append(newRow)

    with open('link_table_sounder_anime.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)

def main_n_m_studios_sounders():
    studios = list()
    with open("./studios.csv", 'r') as file:
        studioData = csv.reader(file)
        for row in studioData:
            studios.append(row)

    sounders = list()
    with open("./sounders.csv", 'r') as file:
        soundersData = csv.reader(file)
        for row in soundersData:
            sounders.append(row)


    dataCSV = list()
    for i in range(0, 350):
        souderId = sounders[random.randint(0, len(sounders) - 1)][0]
        titleSounded = random.randint(1, 3)
        for i in range(0, titleSounded):
            animeName = animes[random.randint(0, len(animes) - 1)][0]
            flagExist = False
            for data in dataCSV:
                if data[0] == animeName and data[1] == souderId:
                    flagExist = True
            if flagExist:
                continue
            newRow = list([souderId, animeName])
            print(newRow)
            dataCSV.append(newRow)

    with open('link_table_sounder_anime.csv', 'w', newline='') as file:
        writer = csv.writer(file)

        for data in dataCSV:
            writer.writerow(data)


print('Enter to main')
main_n_m_studios_sounders()
print('Exit from main')