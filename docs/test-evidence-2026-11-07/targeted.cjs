const {chromium}=require('C:/Users/admin/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');const fs=require('fs');const base='http://localhost:18080/Courson';const out='D:/LMHT/SWP/SE2051-NET_SWP391_G5/docs/test-evidence-2026-11-07';
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:'C:/Users/admin/AppData/Local/ms-playwright/chromium-1243/chrome-win64/chrome.exe'});const data={errors:[],failed:[]};
 try{
 const c=await browser.newContext();await c.request.post(base+'/auth/login',{form:{loginId:'student1',password:'admin123'}});const p=await c.newPage();
 p.on('pageerror',e=>data.errors.push(e.message));p.on('requestfailed',r=>data.failed.push({url:r.url(),failure:r.failure()}));
 let res=await p.goto(base+'/courses/learn?registrationId=15',{waitUntil:'domcontentloaded'});
 data.forgedDiscountAccess={status:res.status(),url:p.url(),hasNoteEditor:await p.locator('#note-editor,.ql-container').count()};
 await p.screenshot({path:out+'/forged-discount-course.png',fullPage:true,timeout:15000}).catch(e=>data.screenshotError=e.message);
 data.quillLoaded=await p.evaluate(()=>typeof window.Quill==='function');
 await p.goto(base+'/courses/learn?courseId=1',{waitUntil:'domcontentloaded'});data.courseIdLinkRedirect=p.url();
 const guest=await browser.newContext();const reset=await guest.request.get(base+'/api/dev/reset-seed',{maxRedirects:0});data.unauthenticatedReset={status:reset.status(),body:await reset.text()};
 await guest.close();await c.close();
 }finally{await browser.close();fs.writeFileSync(out+'/targeted-results.json',JSON.stringify(data,null,2));}console.log(JSON.stringify(data,null,2));
})().catch(e=>{console.error(e);process.exitCode=1});
