function setSessionIDCookie(sessionid) {
  console.log("Setting sessionid in cookie");
  document.cookie = "sessionid=" + sessionid;
}

// Set handler for when the server will provide the sessionid (after connection)
Shiny.addCustomMessageHandler("sessionid", setSessionIDCookie);


function getSessionIDCookie() {
  console.log("Looking for sessionid in cookie");
  sessionid = (res = new RegExp('(?:^|; )sessionid=([^;]*)').exec(
    document.cookie)) ? (res[1]) : null;
  if (sessionid !== null) {
    Shiny.onInputChange("sessionid", sessionid);
  }
}

// Check for sessionid in cookie when Shiny is idle (after load)
$(document).on("shiny:sessioninitialized", getSessionIDCookie);
