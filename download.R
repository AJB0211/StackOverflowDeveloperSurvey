





# check if file has been downloaded already
# if it hasn't download it again and unzip it
if (!exists("./data/2018.zip")){
  download.file("https://drive.google.com/uc?export=download&id=1_9On2-nsBQIw3JiY43sWbrF8EjrqrR4U",destfile = "./data/2018.zip")
  unzip("./data/2018.zip",exdir = "./data/2018")
}


if (!exists("./data/2017.zip")){
  download.file("https://drive.google.com/uc?export=download&id=1_9On2-nsBQIw3JiY43sWbrF8EjrqrR4U",destfile = "./data/2017.zip")
  unzip("./data/2017.zip",exdir = "./data/2017")
}