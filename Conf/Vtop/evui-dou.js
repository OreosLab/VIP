// (!!测试脚本)该脚本用于在前端网页显示近几天的京豆变化。适用环境： elecV2P
// 参考修改自：https://github.com/dompling/Scriptable/blob/master/Scripts/JDDouK.js
// 首次运行时耗时较长，请耐心等待
// 脚本地址：https://raw.githubusercontent.com/elecV2/elecV2P-dei/master/examples/JSTEST/evui-dou.js

class Widget {
  constructor() {
    this.name = "京东豆收支";
    this.JDCookie = {
      cookie: $store.get('CookieJD'),
      userName: '',  // 设置显示的用户名，如果为空将使用京东默认昵称代替  
    };   
    this.rangeDay = 5;   // 天数范围配置
    this.cache = true;   // true: 只在每天首次运行时请求新的数据。 false: 每次运行都获取最新数据
    this.notify = true;  // 是否发送通知
  }

  rangeTimer = {};
  timerKeys = [];
  beanCount = 0;
  beanChange = [];

  chartConfig = (labels = [], datas = [], datas2 = []) => {
    const color = `#003153`;
    let template = `
{
  'type': 'bar',
  'data': {
    'labels': __LABELS__,
    'datasets': [
      {
        type: 'line',
        backgroundColor: '#fff',
        borderColor: getGradientFillHelper('vertical', ['#c8e3fa', '#e62490']),
        'borderWidth': 2,
        pointRadius: 5,
        'fill': false,
        'data': __DATAS__,
      },
      {
        type: 'line',
        backgroundColor: '#88f',
        borderColor: getGradientFillHelper('vertical', ['#c8e3fa', '#0624e9']),
        'borderWidth': 2,
        pointRadius: 5,
        'fill': false,
        'data': __DATAS2__,
      },
    ],
  },
  'options': {
      plugins: {
        datalabels: {
          display: true,
          align: 'top',
          color: __COLOR__,
          font: {
             size: '16'
          }
        },
      },
      layout: {
          padding: {
              left: 0,
              right: 0,
              top: 30,
              bottom: 5
          }
      },
      responsive: true,
      maintainAspectRatio: true,
      'legend': {
        'display': false,
      },
      'title': {
        'display': false,
      },
      scales: {
        xAxes: [
          {
            gridLines: {
              display: false,
              color: __COLOR__,
            },
            ticks: {
              display: true, 
              fontColor: __COLOR__,
              fontSize: '16',
            },
          },
        ],
        yAxes: [
          {
            ticks: {
              display: false,
              beginAtZero: true,
              fontColor: __COLOR__,
            },
            gridLines: {
              borderDash: [7, 5],
              display: false,
              color: __COLOR__,
            },
          },
        ],
      },
    },
 }`;

    template = template.replaceAll("__COLOR__", `'${color}'`);
    template = template.replace("__LABELS__", `${JSON.stringify(labels)}`);
    template = template.replace("__DATAS__", `${JSON.stringify(datas)}`);
    template = template.replace("__DATAS2__", `${JSON.stringify(datas2)}`);
    return template;
  };

  init = async () => {
    try {
      if (!this.JDCookie.cookie) return;
      this.rangeTimer = this.getDay(this.rangeDay);
      this.rangeTimerd = this.getDay(this.rangeDay);
      this.timerKeys = Object.keys(this.rangeTimer);
      await this.getAmountData();
      await this.TotalBean();
    } catch (e) {
      console.log(e);
    }
  };

  getAmountData = async () => {
    let i = 0,
      page = 1;
    do {
      let response = await this.getJingBeanBalanceDetail(page);
      // console.debug(response.data)
      response = response.data
      const result = response.code === "0";
      console.log(`正在获取京豆收支明细，第${page}页：${result ? "请求成功" : "请求失败"}`);
      if (response.code === "3") {
        i = 1;
        console.log(response);
      }
      if (response && result) {
        page++;
        let detailList = response.jingDetailList;
        if (detailList && detailList.length > 0) {
          for (let item of detailList) {
            const dates = item.date.split(" ");
            if (this.timerKeys.indexOf(dates[0]) > -1) {
              const amount = Number(item.amount);
              if (amount > 0) this.rangeTimer[dates[0]] += amount;
              else this.rangeTimerd[dates[0]] += amount
            } else {
              i = 1;
              break;
            }
          }
        }
      }
    } while (i === 0);
  };

  getDay(dayNumber) {
    let data = {};
    let i = dayNumber;
    do {
      const today = new Date();
      const year = today.getFullYear();
      const targetday_milliseconds = today.getTime() - 1000 * 60 * 60 * 24 * i;
      today.setTime(targetday_milliseconds); //注意，这行是关键代码
      let month = today.getMonth() + 1;
      month = month >= 10 ? month : `0${month}`;
      let day = today.getDate();
      day = day >= 10 ? day : `0${day}`;
      data[`${year}-${month}-${day}`] = 0;
      i--;
    } while (i >= 0);
    return data;
  }

  getJingBeanBalanceDetail = async (page) => {
    try {
      const options = {
        url: `https://bean.m.jd.com/beanDetail/detail.json`,
        body: `page=${page}`,
        headers: {
          Accept: "application/json,text/plain, */*",
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "zh-cn",
          Connection: "keep-alive",
          Cookie: this.JDCookie.cookie,
          Referer: "https://wqs.jd.com/my/jingdou/my.shtml?sceneval=2",
          "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
        },
        method: 'post'
      };
      return await $axios(options);
    } catch (e) {
      console.log(e);
    }
  };

  TotalBean = async () => {
    const options = {
      "url": `https://wq.jd.com/user/info/QueryJDUserInfo?sceneval=2`,
      "headers": {
        "Accept": "application/json,text/plain, */*",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "zh-cn",
        "Connection": "keep-alive",
        "Cookie": this.JDCookie.cookie,
        "Referer": "https://wqs.jd.com/my/jingdou/my.shtml?sceneval=2",
        "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"
      }
    }
    let res = await $axios(options)
    if (res && res.data) {
      let data = res.data
      if (data.retcode === 0 && data.base) {
        this.JDCookie.userName = this.JDCookie.userName || data.base.nickname
        this.beanCount = data.base.jdNum
      }
    }
  }

  createChart = async () => {
    let labels = [],
        data = [], data2 = [];
    Object.keys(this.rangeTimer).forEach((month) => {
      const value = this.rangeTimer[month];
      const arrMonth = month.split("-");
      labels.push(`${arrMonth[1]}.${arrMonth[2]}`);
      data.push(value);
      data2.push(this.rangeTimerd[month])
    });
    this.beanChange.push(data)
    this.beanChange.push(data2)
    const chartStr = this.chartConfig(labels, data, data2);
    console.debug(chartStr);

    return await this.chartUrl(chartStr)
  };

  chartUrl = async (data) => {
    const req = {
      url: 'https://quickchart.io/chart/create',
      headers: {
        'Content-Type': 'application/json'
      },
      method: 'post',
      data: { 
        "backgroundColor": "transparent",
        "width": 580,
        "height": 320,
        "format": "png", 
        "chart": data
      }
    }
    return await $axios(req)
  }
}

!(async ()=>{
  let evdou = $store.get('evdou'),
      today = new Date().getDay()
  const eDou = new Widget()
  if (eDou.cache && evdou && evdou.day === today && evdou.imgurl) {
    console.log('使用 cache 数据显示', eDou.name)
  } else {
    await eDou.init()
    let res = await eDou.createChart()
    let data = res.data
    if (data && data.success) {
      evdou = {
        day: today,
        userName: eDou.JDCookie.userName,
        total: eDou.beanCount,
        change: eDou.beanChange,
        imgurl: data.url,
      }
      $store.put(evdou, 'evdou')
    } else {
      console.log(data)
    }
  }

  if (evdou.imgurl) {
    showChart(evdou.imgurl, evdou.userName, evdou.total, eDou.name)
    if (eDou.notify) {
      let body = evdou.userName + ': ' + evdou.total
      if (evdou.change) {
        body += '\n' + '近期收入：' + evdou.change[0].join(', ')
        body += '\n' + '近期支出：' + evdou.change[1].join(', ')
      }
      $feed.push(eDou.name, evdou.userName + ': ' + evdou.total, evdou.imgurl)
    }
  }
})().catch(e=>console.log(e))

function showChart(imgurl, userName, total, title) {
  $evui({
    title,
    width: 640,
    height: 389,
    content: `<div style="filter: blur(3px);-webkit-filter: blur(3px);background: url(https://bing.ioliu.cn/v1/rand);height: 100%;"></div><div style="position: absolute;right: 12px;top: 46px;padding: 8px;border: 1px solid #003153;border-radius: 20px;">${userName}: ${total}</div><img style="background: #ffffff88;position: absolute;top: 36px;left: 0;" src="${imgurl}">`,
    style: {
      title: "background: #6B8E23;",
      content: "text-align: center"
    },
    resizable: true,
  }).then(data=>console.log(data)).catch(e=>console.log(e))
}