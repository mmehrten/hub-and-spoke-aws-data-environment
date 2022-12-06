import requests
import zipfile
import io
import os

cookie_str = os.environ.get("KAGGLE_COOKIE")
if not cookie_str:
    raise RuntimeError(
        "Please set Kaggke cookie in KAGGLE_COOKIE environment variable to authenticate download."
    )
cookie = cookie_str.encode()


def get(url: str, name: str):
    resp = requests.get(url, headers={"Cookie": cookie})
    with io.BytesIO(resp.content) as bio:
        zf = zipfile.ZipFile(bio)
        zf.extractall(f"extract/{name}")
        return zf.namelist()


urls = [
    {
        "url": "https://www.kaggle.com/datasets/abhishek14398/stock-prediction-dataset-adp/download?datasetVersionNumber=1",
        "name": "adp-stock-price",
    },
    {
        "url": "https://www.kaggle.com/datasets/thedevastator/product-prices-and-sizes-from-walmart-grocery/download?datasetVersionNumber=1",
        "name": "walmart-commodity",
    },
    {
        "url": "https://www.kaggle.com/datasets/tunguz/clickstream-data-for-online-shopping/download?datasetVersionNumber=1",
        "name": "retail-clickstream",
    },
    {
        "url": "https://www.kaggle.com/datasets/colearninglounge/used-cars-price-prediction/download?datasetVersionNumber=1",
        "name": "used-cars",
    },
    {
        "url": "https://www.kaggle.com/datasets/prakharrathi25/google-play-store-reviews/download?datasetVersionNumber=1",
        "name": "play-store-reviews",
    },
    {
        "url": "https://www.kaggle.com/datasets/mvieira101/global-cost-of-living/download?datasetVersionNumber=2",
        "name": "cost-of-living",
    },
    {
        "url": "https://www.kaggle.com/datasets/thedevastator/jobs-dataset-from-glassdoor/download?datasetVersionNumber=2",
        "name": "salaries",
    },
    {
        "url": "https://www.kaggle.com/datasets/fuarresvij/gdp-growth-around-the-globe/download?datasetVersionNumber=1",
        "name": "global-gdp",
    },
    {
        "url": "https://www.kaggle.com/datasets/zvr842/global-pollution-by-counties/download?datasetVersionNumber=1",
        "name": "global-pollution",
    },
    {
        "url": "https://www.kaggle.com/datasets/thedevastator/empowering-the-next-wave-of-entrepreneurs/download?datasetVersionNumber=2",
        "name": "startup-stats",
    },
    {
        "url": "https://www.kaggle.com/datasets/whenamancodes/credit-card-customers-prediction/download?datasetVersionNumber=1",
        "name": "credit-card-pci",
    },
    {
        "url": "https://www.kaggle.com/datasets/elmoallistair/commodity-prices-19602021/download?datasetVersionNumber=3",
        "name": "commodity-prices",
    },
    {
        "url": "https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud/download?datasetVersionNumber=3",
        "name": "credit-card-fraud",
    },
    {
        "url": "https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand/download?datasetVersionNumber=1",
        "name": "hotel-booking",
    },
    {
        "url": "https://www.kaggle.com/datasets/sakshigoyal7/credit-card-customers/download?datasetVersionNumber=1",
        "name": "credit-card-customers",
    },
    {
        "url": "https://www.kaggle.com/datasets/borismarjanovic/price-volume-data-for-all-us-stocks-etfs/download?datasetVersionNumber=3",
        "name": "stock-prices",
    },
]
names = {}
for url in urls:
    names[url["name"]] = get(**url)
    print(url["name"], names[url["name"]])
