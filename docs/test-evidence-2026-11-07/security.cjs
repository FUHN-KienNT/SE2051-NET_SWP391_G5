const {chromium}=require('C:/Users/admin/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs');const base='http://localhost:18080/Courson';const out='D:/LMHT/SWP/SE2051-NET_SWP391_G5/docs/test-evidence-2026-11-07';
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:'C:/Users/admin/AppData/Local/ms-playwright/chromium-1243/chrome-win64/chrome.exe'});const rows=[];
 try {
 const c=await browser.newContext();
 const login=await c.request.post(base+'/auth/login',{form:{loginId:'student1',password:'admin123'},maxRedirects:0});
 rows.push({check:'student login',status:login.status(),location:login.headers().location});
 const checkout=await c.request.post(base+'/registrations/checkout',{form:{courseId:'6',certificateName:'Audit Student',voucherCode:'INVALID_AUDIT_CODE',discountAmount:'350000'},maxRedirects:0});
 rows.push({check:'unrecognized voucher sets full discount',status:checkout.status(),location:checkout.headers().location});
 const learn=await c.request.get(base+'/courses/learn?courseId=6');rows.push({check:'paid course access after forged discount',status:learn.status(),url:learn.url(),containsLessons:(await learn.text()).includes('lessonId')});
 const guest=await browser.newContext();
 const forgot=await guest.request.post(base+'/auth/forgot-password',{form:{email:'student2@courson.edu.vn'}});
 const html=await forgot.text();const link=html.match(/href="([^"]*\/auth\/reset-password\?token=[^"]+)"/);
 rows.push({check:'guest receives password reset URL',status:forgot.status(),resetLinkExposed:!!link});
 if(link){
  const resetUrl=link[1].replaceAll('&amp;','&');const token=new URL(resetUrl,base).searchParams.get('token');
  const valid=await guest.request.get(new URL(resetUrl,base).href);rows.push({check:'exposed reset token opens reset form',status:valid.status(),hasPasswordForm:(await valid.text()).includes('name="confirmPassword"')});
  const reset=await guest.request.post(base+'/auth/reset-password',{form:{token,password:'AuditStable2026!',confirmPassword:'AuditStable2026!'},maxRedirects:0});rows.push({check:'guest resets password without email access',status:reset.status(),location:reset.headers().location});
  const signIn=await guest.request.post(base+'/auth/login',{form:{loginId:'student2',password:'AuditStable2026!'},maxRedirects:0});rows.push({check:'new password login',status:signIn.status(),location:signIn.headers().location});
 }
 await guest.close();await c.close();
 } finally {await browser.close(); fs.writeFileSync(out+'/security-results.json',JSON.stringify(rows,null,2));}
 console.log(JSON.stringify(rows,null,2));
})().catch(e=>{console.error(e);process.exitCode=1});
