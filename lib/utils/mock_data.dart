class MockData {
  static const Map<String, dynamic> portfolioApiResponse = {
    "result": {"message": "success", "code": 0},
    "data": {
      "asset_list": [
        {
          "security_symbol": "EWA",
          "type": "stock",
          "security_description": "커먼웰스은행, 알루미나, 시드니공항 등 호주를 대표하는 70여개 기업을 포함하는 MSCI 지수 종목에 투자하는 ETF",
          "quantity": 1,
          "ratio": 10.05,
          "security_name": "MSCI Australia ETF",
        },
        {
          "security_symbol": "EWG",
          "type": "stock",
          "security_description": "SAP, 지멘스, 아디다스 등 독일을 대표하는 59개 기업에 투자하는 ETF",
          "quantity": 1,
          "ratio": 8.03,
          "security_name": "MSCI Germany ETF",
        },
        {
          "security_name": "MSCI HONG KONG ETF",
          "type": "stock",
          "security_symbol": "EWH",
          "quantity": 1,
          "ratio": 6.5,
          "security_description": "AIA생명 등 홍콩거래소에 상장된 상위 우량기업 45개로 구성된 대표지수 구성 종목에 투자하는 ETF",
        },
        {
          "quantity": 1,
          "type": "stock",
          "security_name": "MSCI United Kingdom ETF",
          "ratio": 8.5,
          "security_description": "HSBC, 보다폰, 유니레버 등 영국을 대표하는 런던증시 상장 109개 기업에 투자하는 ETF",
          "security_symbol": "EWU",
        },
        {
          "security_description": "미국 국채 7-10년물에 투자하는 ETF",
          "security_name": "iShares 7-10 Year Treasury Bond ETF",
          "type": "bond",
          "ratio": 9.5,
          "security_symbol": "IEF",
          "quantity": 3,
        },
        {
          "security_symbol": "TLT",
          "type": "bond",
          "quantity": 1,
          "ratio": 8.5,
          "security_name": "iShares 20+ Year Treasury Bond ETF",
          "security_description": "미국 장기 국채 20년 이상물에 투자하는 ETF",
        },
        {
          "security_symbol": "AGG",
          "type": "bond",
          "quantity": 1,
          "ratio": 13.42,
          "security_name": "iShares Core U.S. Aggregate Bond ETF",
          "security_description": "미국 투자등급 채권 전체에 분산 투자하는 ETF",
        },
        {
          "security_symbol": "USD_CASH",
          "type": "etc",
          "quantity": 1,
          "security_name": "미화 현금",
          "ratio": 35.5,
          "security_description": "달러 현금 보유",
        },
      ],
    },
  };
}
