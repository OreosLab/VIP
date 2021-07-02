const $=new Env('elecv2pCk')
const v2purl=$.getval('v2purl');const v2ptoken=$.getval('v2token');$.KEY_usercfgs='chavy_boxjs_userCfgs'
$.KEY_sessions='chavy_boxjs_sessions'
$.KEY_web_cache='chavy_boxjs_web_cache'
$.KEY_app_subCaches='chavy_boxjs_app_subCaches'
$.KEY_globalBaks='chavy_boxjs_globalBaks'
$.KEY_backups='chavy_boxjs_backups'
$.KEY_cursessions='chavy_boxjs_cur_sessions'
!(async()=>{console.log("\n* Author:CenBoMin\n* Github:github.com/CenBoMin/GithubSync\n* Telegram:https://t.me/CbScript\n* Updatetime:2021.05.12\n");console.log(`Now login(UTC+8):${new Date(new Date().getTime() + 8 * 60 * 60 * 1000).toLocaleString()}`)
$.log(`\n🤖[${$.name}]:开始加载BOXJS资讯...`)
const datas={}
const usercfgs=getUserCfgs()
const sessions=getAppSessions()
const curSessions=getCurSessions()
const sysapps=getSystemApps()
const syscfgs=getSystemCfgs()
const appSubCaches=getAppSubCaches()
const globalbaks=getGlobalBaks()
sysapps.forEach((app)=>Object.assign(datas,getAppDatas(app)))
usercfgs.appsubs.forEach((sub)=>{const subcache=appSubCaches[sub.url]
if(subcache&&subcache.apps&&Array.isArray(subcache.apps)){subcache.apps.forEach((app)=>Object.assign(datas,getAppDatas(app)))}})
const box={datas,usercfgs,sessions,curSessions,sysapps,syscfgs,appSubCaches,globalbaks}
var ckobj=box.datas
$.log(`▪️检测到BOXJS共有${Object.keys(ckobj).length}个cookie`)
console.log(`\n🤖[${$.name}]:~ System💲/删除 Cookie空值的Key`)
Object.keys(ckobj).forEach((key)=>(ckobj[key]===null||ckobj[key]===undefined||ckobj[key]==='null'||ckobj[key]==='undefined'||ckobj[key]===''||JSON.stringify(ckobj[key])=="{}")&&delete ckobj[key]);var cklist=Object.keys(ckobj);$.log(`▪️处理过后,BOXJS共有${cklist.length}个cookie`)
console.log(`\n🤖[${$.name}]:~ System💲/p上传 Cookie到elecv2p服务器`)
for(let i=0;i<cklist.length;i++){ckkey=cklist[i];ckvalue=$.getval(ckkey);console.log(`\n💡开始上传cookie:[${ckkey}]`);await pushcookie(ckkey,ckvalue);}})().catch((e)=>{$.log('',`❌ ${$.name}, 失败! 原因: ${e}!`,'')}).finally(()=>{$.done();})
async function pushcookie(ckkey,ckvalue){return new Promise((resolve)=>{let url={url:`${v2purl}/webhook`,body:JSON.stringify({token:`${v2ptoken}`,type:'store',op:'put',key:ckkey,value:ckvalue}),headers:{'Content-Type':'application/json'},method:'put'};$.post(url,async(err,resp,data)=>{try{if(err){console.log("⛔️API查询请求失败❌ ‼️‼️");console.log(JSON.stringify(err));$.logErr(err);}else{$.log(data)}}catch(e){$.logErr(e,resp);}finally{resolve();}});});}
function getSystemCfgs(){return{env:$.isShadowrocket()?'Shadowrocket':$.isLoon()?'Loon':$.isQuanX()?'QuanX':$.isSurge()?'Surge':'Node',version:$.version,versionType:$.versionType,envs:[{id:'Surge',icons:['https://raw.githubusercontent.com/Orz-3/mini/none/surge.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/surge.png']},{id:'QuanX',icons:['https://raw.githubusercontent.com/Orz-3/mini/none/quanX.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/quantumultx.png']},{id:'Loon',icons:['https://raw.githubusercontent.com/Orz-3/mini/none/loon.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/loon.png']},{id:'Shadowrocket',icons:['https://raw.githubusercontent.com/Orz-3/mini/master/Alpha/shadowrocket.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/shadowrocket.png']}],chavy:{id:'ChavyLeung',icon:'https://avatars3.githubusercontent.com/u/29748519',repo:'https://github.com/chavyleung/scripts'},senku:{id:'GideonSenku',icon:'https://avatars1.githubusercontent.com/u/39037656',repo:'https://github.com/GideonSenku'},id77:{id:'id77',icon:'https://avatars0.githubusercontent.com/u/9592236',repo:'https://github.com/id77'},orz3:{id:'Orz-3',icon:'https://raw.githubusercontent.com/Orz-3/mini/master/Color/Orz-3.png',repo:'https://github.com/Orz-3/'},boxjs:{id:'BoxJs',show:false,icon:'https://raw.githubusercontent.com/Orz-3/mini/master/Color/box.png',icons:['https://raw.githubusercontent.com/Orz-3/mini/master/Alpha/box.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/box.png'],repo:'https://github.com/chavyleung/scripts'},defaultIcons:['https://raw.githubusercontent.com/Orz-3/mini/master/Alpha/appstore.png','https://raw.githubusercontent.com/Orz-3/mini/master/Color/appstore.png']}}
function getSystemApps(){const sysapps=[{id:'BoxSetting',name:'偏好设置',descs:['可手动执行一些抹掉数据的脚本','可设置明暗两种主题下的主色调','可设置壁纸清单'],keys:['@chavy_boxjs_userCfgs.httpapi','@chavy_boxjs_userCfgs.bgimg','@chavy_boxjs_userCfgs.http_backend','@chavy_boxjs_userCfgs.color_dark_primary','@chavy_boxjs_userCfgs.color_light_primary'],settings:[{id:'@chavy_boxjs_userCfgs.httpapis',name:'HTTP-API (Surge)',val:'',type:'textarea',placeholder:',examplekey@127.0.0.1:6166',autoGrow:true,rows:2,persistentHint:true,desc:'示例: ,examplekey@127.0.0.1:6166! 注意: 以逗号开头, 逗号分隔多个地址, 可加回车'},{id:'@chavy_boxjs_userCfgs.httpapi_timeout',name:'HTTP-API Timeout (Surge)',val:20,type:'number',persistentHint:true,desc:'如果脚本作者指定了超时时间, 会优先使用脚本指定的超时时间.'},{id:'@chavy_boxjs_userCfgs.http_backend',name:'HTTP Backend (Quantumult X)',val:'',type:'text',placeholder:'http://127.0.0.1:9999',persistentHint:true,desc:'示例: http://127.0.0.1:9999 ! 注意: 必须是以 http 开头的完整路径, 不能是 / 结尾'},{id:'@chavy_boxjs_userCfgs.bgimgs',name:'背景图片清单',val:'无,\n跟随系统,跟随系统\nlight,http://api.btstu.cn/sjbz/zsy.php\ndark,https://uploadbeta.com/api/pictures/random\n妹子,http://api.btstu.cn/sjbz/zsy.php',type:'textarea',placeholder:'无,{回车} 跟随系统,跟随系统{回车} light,图片地址{回车} dark,图片地址{回车} 妹子,图片地址',persistentHint:true,autoGrow:true,rows:2,desc:'逗号分隔名字和链接, 回车分隔多个地址'},{id:'@chavy_boxjs_userCfgs.bgimg',name:'背景图片',val:'',type:'text',placeholder:'http://api.btstu.cn/sjbz/zsy.php',persistentHint:true,desc:'输入背景图标的在线链接'},{id:'@chavy_boxjs_userCfgs.changeBgImgEnterDefault',name:'手势进入壁纸模式默认背景图片',val:'',type:'text',placeholder:'填写上面背景图片清单的值',persistentHint:true,desc:''},{id:'@chavy_boxjs_userCfgs.changeBgImgOutDefault',name:'手势退出壁纸模式默认背景图片',val:'',type:'text',placeholder:'填写上面背景图片清单的值',persistentHint:true,desc:''},{id:'@chavy_boxjs_userCfgs.color_light_primary',name:'明亮色调',canvas:true,val:'#F7BB0E',type:'colorpicker',desc:''},{id:'@chavy_boxjs_userCfgs.color_dark_primary',name:'暗黑色调',canvas:true,val:'#2196F3',type:'colorpicker',desc:''}],scripts:[{name:"抹掉：所有缓存",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.caches.js"},{name:"抹掉：收藏应用",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.usercfgs.favapps.js"},{name:"抹掉：用户偏好",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.usercfgs.js"},{name:"抹掉：所有会话",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.usercfgs.sessions.js"},{name:"抹掉：所有备份",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.baks.js"},{name:"抹掉：BoxJs (注意备份)",script:"https://raw.githubusercontent.com/chavyleung/scripts/master/box/scripts/boxjs.revert.boxjs.js"}],author:'@chavyleung',repo:'https://github.com/chavyleung/scripts/blob/master/box/switcher/box.switcher.js',icons:['https://raw.githubusercontent.com/chavyleung/scripts/master/box/icons/BoxSetting.mini.png','https://raw.githubusercontent.com/chavyleung/scripts/master/box/icons/BoxSetting.png']},{id:'BoxSwitcher',name:'会话切换',desc:'打开静默运行后, 切换会话将不再发出系统通知 \n注: 不影响日志记录',keys:[],settings:[{id:'CFG_BoxSwitcher_isSilent',name:'静默运行',val:false,type:'boolean',desc:'切换会话时不发出系统通知!'}],author:'@chavyleung',repo:'https://github.com/chavyleung/scripts/blob/master/box/switcher/box.switcher.js',icons:['https://raw.githubusercontent.com/chavyleung/scripts/master/box/icons/BoxSwitcher.mini.png','https://raw.githubusercontent.com/chavyleung/scripts/master/box/icons/BoxSwitcher.png'],script:'https://raw.githubusercontent.com/chavyleung/scripts/master/box/switcher/box.switcher.js'}]
return sysapps}
function getUserCfgs(){const defcfgs={favapps:[],appsubs:[],viewkeys:[],isPinedSearchBar:true,httpapi:'examplekey@127.0.0.1:6166',http_backend:''}
const usercfgs=Object.assign(defcfgs,$.getjson($.KEY_usercfgs,{}))
if(usercfgs.appsubs.includes(null)){usercfgs.appsubs=usercfgs.appsubs.filter((sub)=>sub)
$.setjson(usercfgs,$.KEY_usercfgs)}
return usercfgs}
function getAppSubCaches(){return $.getjson($.KEY_app_subCaches,{})}
function getGlobalBaks(){let backups=$.getjson($.KEY_backups,[])
if(backups.includes(null)){backups=backups.filter((bak)=>bak)
$.setjson(backups,$.KEY_backups)}
return backups}
function getVersions(){return $.http.get($.ver).then((resp)=>{try{$.json=$.toObj(resp.body)}catch{$.json={}}},()=>($.json={}))}
function getUserApps(){return[]}
function getAppSessions(){return $.getjson($.KEY_sessions,[])}
function getCurSessions(){return $.getjson($.KEY_cursessions,{})}
function getAppDatas(app){const datas={}
const nulls=[null,undefined,'null','undefined']
if(app.keys&&Array.isArray(app.keys)){app.keys.forEach((key)=>{const val=$.getdata(key)
datas[key]=nulls.includes(val)?null:val})}
if(app.settings&&Array.isArray(app.settings)){app.settings.forEach((setting)=>{const key=setting.id
const val=$.getdata(key)
datas[key]=nulls.includes(val)?null:val})}
return datas}
async function apiSave(){const data=$.toObj($request.body)
if(Array.isArray(data)){data.forEach((dat)=>$.setdata(dat.val,dat.key))}else{$.setdata(data.val,data.key)}
$.json=getBoxData()}
async function apiAddAppSub(){const sub=$.toObj($request.body)
const usercfgs=getUserCfgs()
usercfgs.appsubs.push(sub)
$.setjson(usercfgs,$.KEY_usercfgs)
await reloadAppSubCache(sub.url)
$.json=getBoxData()}
async function apiReloadAppSub(){const sub=$.toObj($request.body)
if(sub){await reloadAppSubCache(sub.url)}else{await reloadAppSubCaches()}
$.json=getBoxData()}
async function apiDelGlobalBak(){const backup=$.toObj($request.body)
const backups=$.getjson($.KEY_backups,[])
const bakIdx=backups.findIndex((b)=>b.id===backup.id)
if(bakIdx>-1){backups.splice(bakIdx,1)
$.setdata('',backup.id)
$.setjson(backups,$.KEY_backups)}
$.json=getBoxData()}
async function apiUpdateGlobalBak(){const{id:backupId,name:backupName}=$.toObj($request.body)
const backups=$.getjson($.KEY_backups,[])
const backup=backups.find((b)=>b.id===backupId)
if(backup){backup.name=backupName
$.setjson(backups,$.KEY_backups)}
$.json=getBoxData()}
async function apiRevertGlobalBak(){const{id:bakcupId}=$.toObj($request.body)
const backup=$.getjson(bakcupId)
if(backup){const{chavy_boxjs_sysCfgs,chavy_boxjs_sysApps,chavy_boxjs_sessions,chavy_boxjs_userCfgs,chavy_boxjs_cur_sessions,chavy_boxjs_app_subCaches,...datas}=backup
$.setdata(JSON.stringify(chavy_boxjs_sessions),$.KEY_sessions)
$.setdata(JSON.stringify(chavy_boxjs_userCfgs),$.KEY_usercfgs)
$.setdata(JSON.stringify(chavy_boxjs_cur_sessions),$.KEY_cursessions)
$.setdata(JSON.stringify(chavy_boxjs_app_subCaches),$.KEY_app_subCaches)
const isNull=(val)=>[undefined,null,'null','undefined',''].includes(val)
Object.keys(datas).forEach((datkey)=>$.setdata(isNull(datas[datkey])?'':`${datas[datkey]}`,datkey))}
const boxdata=getBoxData()
$.json=boxdata}
async function apiSaveGlobalBak(){const backups=$.getjson($.KEY_backups,[])
const boxdata=getBoxData()
const backup=$.toObj($request.body)
const backupData={}
backupData['chavy_boxjs_userCfgs']=boxdata.usercfgs
backupData['chavy_boxjs_sessions']=boxdata.sessions
backupData['chavy_boxjs_cur_sessions']=boxdata.curSessions
backupData['chavy_boxjs_app_subCaches']=boxdata.appSubCaches
Object.assign(backupData,boxdata.datas)
backups.push(backup)
$.setjson(backups,$.KEY_backups)
$.setjson(backupData,backup.id)
$.json=getBoxData()}
async function apiImpGlobalBak(){const backups=$.getjson($.KEY_backups,[])
const backup=$.toObj($request.body)
const backupData=backup.bak
delete backup.bak
backups.push(backup)
$.setjson(backups,$.KEY_backups)
$.setjson(backupData,backup.id)
$.json=getBoxData()}
function safeGet(data){try{if(typeof JSON.parse(data)=="object"){return true;}}catch(e){console.log(e);console.log(`⛔️服务器访问数据为空，请检查自身设备网络情况`);return false;}}
function Env(t,e){class s{constructor(t){this.env=t}
send(t,e="GET"){t="string"==typeof t?{url:t}:t;let s=this.get;return"POST"===e&&(s=this.post),new Promise((e,i)=>{s.call(this,t,(t,s,r)=>{t?i(t):e(s)})})}
get(t){return this.send.call(this.env,t)}
post(t){return this.send.call(this.env,t,"POST")}}
return new class{constructor(t,e){this.name=t,this.http=new s(this),this.data=null,this.dataFile="box.dat",this.logs=[],this.isMute=!1,this.isNeedRewrite=!1,this.logSeparator="\n",this.startTime=(new Date).getTime(),Object.assign(this,e),this.log("",`\ud83d\udd14${this.name}, \u5f00\u59cb!`)}
isNode(){return"undefined"!=typeof module&&!!module.exports}
isQuanX(){return"undefined"!=typeof $task}
isSurge(){return"undefined"!=typeof $httpClient&&"undefined"==typeof $loon}
isLoon(){return"undefined"!=typeof $loon}
isShadowrocket(){return"undefined"!=typeof $rocket}
toObj(t,e=null){try{return JSON.parse(t)}catch{return e}}
toStr(t,e=null){try{return JSON.stringify(t)}catch{return e}}
getjson(t,e){let s=e;const i=this.getdata(t);if(i)try{s=JSON.parse(this.getdata(t))}catch{}
return s}
setjson(t,e){try{return this.setdata(JSON.stringify(t),e)}catch{return!1}}
getScript(t){return new Promise(e=>{this.get({url:t},(t,s,i)=>e(i))})}
runScript(t,e){return new Promise(s=>{let i=this.getdata("@chavy_boxjs_userCfgs.httpapi");i=i?i.replace(/\n/g,"").trim():i;let r=this.getdata("@chavy_boxjs_userCfgs.httpapi_timeout");r=r?1*r:20,r=e&&e.timeout?e.timeout:r;const[o,h]=i.split("@"),a={url:`http://${h}/v1/scripting/evaluate`,body:{script_text:t,mock_type:"cron",timeout:r},headers:{"X-Key":o,Accept:"*/*"}};this.post(a,(t,e,i)=>s(i))}).catch(t=>this.logErr(t))}
loaddata(){if(!this.isNode())return{};{this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e);if(!s&&!i)return{};{const i=s?t:e;try{return JSON.parse(this.fs.readFileSync(i))}catch(t){return{}}}}}
writedata(){if(this.isNode()){this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e),r=JSON.stringify(this.data);s?this.fs.writeFileSync(t,r):i?this.fs.writeFileSync(e,r):this.fs.writeFileSync(t,r)}}
lodash_get(t,e,s){const i=e.replace(/\[(\d+)\]/g,".$1").split(".");let r=t;for(const t of i)
if(r=Object(r)[t],void 0===r)return s;return r}
lodash_set(t,e,s){return Object(t)!==t?t:(Array.isArray(e)||(e=e.toString().match(/[^.[\]]+/g)||[]),e.slice(0,-1).reduce((t,s,i)=>Object(t[s])===t[s]?t[s]:t[s]=Math.abs(e[i+1])>>0==+e[i+1]?[]:{},t)[e[e.length-1]]=s,t)}
getdata(t){let e=this.getval(t);if(/^@/.test(t)){const[,s,i]=/^@(.*?)\.(.*?)$/.exec(t),r=s?this.getval(s):"";if(r)try{const t=JSON.parse(r);e=t?this.lodash_get(t,i,""):e}catch(t){e=""}}
return e}
setdata(t,e){let s=!1;if(/^@/.test(e)){const[,i,r]=/^@(.*?)\.(.*?)$/.exec(e),o=this.getval(i),h=i?"null"===o?null:o||"{}":"{}";try{const e=JSON.parse(h);this.lodash_set(e,r,t),s=this.setval(JSON.stringify(e),i)}catch(e){const o={};this.lodash_set(o,r,t),s=this.setval(JSON.stringify(o),i)}}else s=this.setval(t,e);return s}
getval(t){return this.isSurge()||this.isLoon()?$persistentStore.read(t):this.isQuanX()?$prefs.valueForKey(t):this.isNode()?(this.data=this.loaddata(),this.data[t]):this.data&&this.data[t]||null}
setval(t,e){return this.isSurge()||this.isLoon()?$persistentStore.write(t,e):this.isQuanX()?$prefs.setValueForKey(t,e):this.isNode()?(this.data=this.loaddata(),this.data[e]=t,this.writedata(),!0):this.data&&this.data[e]||null}
initGotEnv(t){this.got=this.got?this.got:require("got"),this.cktough=this.cktough?this.cktough:require("tough-cookie"),this.ckjar=this.ckjar?this.ckjar:new this.cktough.CookieJar,t&&(t.headers=t.headers?t.headers:{},void 0===t.headers.Cookie&&void 0===t.cookieJar&&(t.cookieJar=this.ckjar))}
get(t,e=(()=>{})){t.headers&&(delete t.headers["Content-Type"],delete t.headers["Content-Length"]),this.isSurge()||this.isLoon()?(this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.get(t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)})):this.isQuanX()?(this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t))):this.isNode()&&(this.initGotEnv(t),this.got(t).on("redirect",(t,e)=>{try{if(t.headers["set-cookie"]){const s=t.headers["set-cookie"].map(this.cktough.Cookie.parse).toString();s&&this.ckjar.setCookieSync(s,null),e.cookieJar=this.ckjar}}catch(t){this.logErr(t)}}).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)}))}
post(t,e=(()=>{})){const s=t.method?t.method.toLocaleLowerCase():"post";if(t.body&&t.headers&&!t.headers["Content-Type"]&&(t.headers["Content-Type"]="application/x-www-form-urlencoded"),t.headers&&delete t.headers["Content-Length"],this.isSurge()||this.isLoon())this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient[s](t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)});else if(this.isQuanX())t.method=s,this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t));else if(this.isNode()){this.initGotEnv(t);const{url:i,...r}=t;this.got[s](i,r).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)})}}
time(t,e=null){const s=e?new Date(e):new Date;let i={"M+":s.getMonth()+1,"d+":s.getDate(),"H+":s.getHours(),"m+":s.getMinutes(),"s+":s.getSeconds(),"q+":Math.floor((s.getMonth()+3)/3),S:s.getMilliseconds()};/(y+)/.test(t)&&(t=t.replace(RegExp.$1,(s.getFullYear()+"").substr(4-RegExp.$1.length)));for(let e in i)new RegExp("("+e+")").test(t)&&(t=t.replace(RegExp.$1,1==RegExp.$1.length?i[e]:("00"+i[e]).substr((""+i[e]).length)));return t}
msg(e=t,s="",i="",r){const o=t=>{if(!t)return t;if("string"==typeof t)return this.isLoon()?t:this.isQuanX()?{"open-url":t}:this.isSurge()?{url:t}:void 0;if("object"==typeof t){if(this.isLoon()){let e=t.openUrl||t.url||t["open-url"],s=t.mediaUrl||t["media-url"];return{openUrl:e,mediaUrl:s}}
if(this.isQuanX()){let e=t["open-url"]||t.url||t.openUrl,s=t["media-url"]||t.mediaUrl;return{"open-url":e,"media-url":s}}
if(this.isSurge()){let e=t.url||t.openUrl||t["open-url"];return{url:e}}}};if(this.isMute||(this.isSurge()||this.isLoon()?$notification.post(e,s,i,o(r)):this.isQuanX()&&$notify(e,s,i,o(r))),!this.isMuteLog){let t=["","==============\ud83d\udce3\u7cfb\u7edf\u901a\u77e5\ud83d\udce3=============="];t.push(e),s&&t.push(s),i&&t.push(i),console.log(t.join("\n")),this.logs=this.logs.concat(t)}}
log(...t){t.length>0&&(this.logs=[...this.logs,...t]),console.log(t.join(this.logSeparator))}
logErr(t,e){const s=!this.isSurge()&&!this.isQuanX()&&!this.isLoon();s?this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t.stack):this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t)}
wait(t){return new Promise(e=>setTimeout(e,t))}
done(t={}){const e=(new Date).getTime(),s=(e-this.startTime)/1e3;this.log("",`\ud83d\udd14${this.name}, \u7ed3\u675f! \ud83d\udd5b ${s} \u79d2`),this.log(),(this.isSurge()||this.isQuanX()||this.isLoon())&&$done(t)}}(t,e)}
