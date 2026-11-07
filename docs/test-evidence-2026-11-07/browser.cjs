const {chromium}=require('C:/Users/admin/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs');
const base='http://localhost:18080/Courson';
const out='D:/LMHT/SWP/SE2051-NET_SWP391_G5/docs/test-evidence-2026-11-07';
const results=[]; const errors=[];
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:"C:/Users/admin/AppData/Local/ms-playwright/chromium-1243/chrome-win64/chrome.exe"});
 try {
 for(const role of ['guest','student1','expert1','manager1','admin']){
  const context=await browser.newContext();
  await context.route('**/*',r=>new URL(r.request().url()).hostname==='localhost'?r.continue():r.abort());
  const page=await context.newPage(); page.on('pageerror',e=>errors.push({role,message:e.message}));
  if(role!=='guest'){
   await page.goto(base+'/auth/login');
   await page.locator('[name=loginId]').fill(role); await page.locator('[name=password]').fill('admin123');
   await Promise.all([page.waitForURL(u=>!u.pathname.endsWith('/auth/login'),{timeout:15000,waitUntil:"domcontentloaded"}),page.locator('#loginForm button[type=submit]').click()]);
   results.push({role,check:'login',url:page.url(),pass:!page.url().includes('/auth/login')});
  }
  const routes=role==='guest'?['/','/courses/catalog','/courses/detail?id=1','/courses/detail?id=abc','/courses/detail?id=999999','/courses/detail?id=3','/profile','/registrations/my']:
    role==='student1'?['/registrations/my','/courses/learn?registrationId=1','/courses/learn?registrationId=5','/profile','/registrations/checkout?courseId=6','/registrations/payment?courseId=5','/users/list','/admin/courses','/expert/dashboard','/quizzes/detail?id=1','/registrations/list']:
    role==='expert1'?['/expert/dashboard','/expert/lessons?courseId=1','/expert/course-detail?id=1','/quizzes/list?courseId=1','/users/list']:
    role==='manager1'?['/manager/dashboard','/admin/courses','/registrations/list','/users/list']:
    ['/admin/dashboard','/admin/courses','/users/list','/settings/list','/registrations/list'];
  for(const path of routes){
   try{const response=await page.goto(base+path,{waitUntil:'domcontentloaded',timeout:30000});
   const body=await page.locator('body').innerText();
   const row={role,path,status:response.status(),url:page.url(),stackTrace:/Exception|Stacktrace:|java\.lang\./.test(body),textLength:body.length}; results.push(row);
   if(response.status()>=500 || path.includes('/learn?') || (role==='admin'&&path==='/users/list')) await page.screenshot({path:out+'/'+role+'-'+results.length+'.png',fullPage:true});
   }catch(e){results.push({role,path,error:e.message});}
  }
  if(role==='student1'){
   for(const [path,method,form] of [
    ['/quizzes/save','POST',{id:'1',moduleId:'1',title:'AUDIT_UNAUTHORIZED',orderIndex:'1',passScore:'50',courseId:'1'}],
    ['/registrations/confirm-payment?courseId=5&paymentCode=AUDIT-FAKE','GET'],
    ['/courses/update-progress','POST',{registrationId:'abc',lessonId:'1',status:'COMPLETED'}],
    ['/courses/save-lesson-note','POST',{registrationId:'1',lessonId:'1',note:'AUDIT_STABILITY_NOTE'}],
    ['/courses/save-lesson-note','POST',{registrationId:'999999',lessonId:'1',note:'FORBIDDEN'}]
   ]){
    const res=await context.request.fetch(base+path,{method,form,maxRedirects:0}); results.push({role,path,method,status:res.status(),location:res.headers().location,body:(await res.text()).slice(0,1200)});
   }
  }
  await context.close();
 }
 }finally{await browser.close();fs.writeFileSync(out+'/browser-results.json',JSON.stringify({results,errors},null,2));}
 console.log(JSON.stringify({visits:results.length,errors,serverFailures:results.filter(x=>x.status>=500),login:results.filter(x=>x.check==='login'),security:results.filter(x=>x.method)},null,2));
})().catch(e=>{console.error(e);process.exitCode=1});


