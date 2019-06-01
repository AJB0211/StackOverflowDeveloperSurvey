
years <- c("2019","2018","2017")
url2019 <- "https://drive.google.com/uc?authuser=0&id=1QOmVDpd8hcVYqqUXDXf68UMDWQZP0wQV&export=download"
url2018 <- "https://drive.google.com/uc?export=download&id=1_9On2-nsBQIw3JiY43sWbrF8EjrqrR4U"
url2017 <- "https://drive.google.com/uc?export=download&id=0B6ZlG_Eygdj-c1kzcmUxN05VUXM"
urls <- c(url2019,url2018,url2017)


## Make directory for data and zip files
## Do nothing if directory already exists
dir.create(file.path("data","zips"),recursive=TRUE,showWarnings = FALSE)

## Check if file has been downloaded already
## If it hasn't download it and unzip

download.data <- function(year, url){
  zip.path = file.path(getwd(),"data","zips",paste0(year,".zip"))
  if (!file.exists(zip.path)){
    print(paste0("Now downloading data for ",year))
    download.file(url,destfile=zip.path)
    unzip(zip.path, exdir = file.path(getwd(),"data",year))
  }
}

mapply(download.data,years,urls)

rm(url2017,url2018,url2019)
rm(download.data,years,urls)