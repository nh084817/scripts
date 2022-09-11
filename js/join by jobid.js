(function() {
    const placeId = Number(window.location.pathname.split('/')[2]) || Number(prompt('placeId:', ''));
    const jobId = String(prompt('jobId:', ''));
 
    try {
        if (jobId.length != 36) throw "Invalid jobId"
        eval(Roblox.GameLauncher.joinGameInstance(placeId, jobId));
    } catch(err) {
        console.log('Error:', err);
    }
 })();