const fs=require('fs');
const base='http://localhost:18080/Courson';
(async()=>{
 const rows=[]; const start=Date.now(); let next=0;
 const paths=['/courses/catalog','/courses/detail?id=1','/auth/login','/home'];
 await Promise.all(Array.from({length:10},async()=>{while(next<300){const i=next++;const t=performance.now();try{const r=await fetch(base+paths[i%paths.length],{signal:AbortSignal.timeout(20000)});const s=await r.text();rows.push({i,path:paths[i%paths.length],status:r.status,ms:Math.round(performance.now()-t),bytes:s.length});}catch(e){rows.push({i,error:e.message,ms:Math.round(performance.now()-t)});}}}));
 const times=rows.map(x=>x.ms).sort((a,b)=>a-b); const summary={requests:rows.length,concurrency:10,elapsedMs:Date.now()-start,p50:times[Math.floor(times.length*.5)],p95:times[Math.floor(times.length*.95)],max:times.at(-1),failures:rows.filter(x=>x.status!==200),statusCounts:rows.reduce((a,x)=>(a[x.status??'error']=(a[x.status??'error']??0)+1,a),{})};
 fs.writeFileSync('D:/LMHT/SWP/SE2051-NET_SWP391_G5/docs/test-evidence-2026-11-07/load-results.json',JSON.stringify({summary,rows},null,2)); console.log(JSON.stringify(summary,null,2));
})();
