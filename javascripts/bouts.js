!function(){function t(){for(var t=document.querySelectorAll("[data-map]"),e=0;e<t.length;e++){var a=t[e],o=parseFloat(a.getAttribute("data-lat")),r=parseFloat(a.getAttribute("data-lon")),l=document.createElement("div");l.className="map";{var n=new google.maps.Map(l,{center:{lat:o,lng:r},zoom:17});new google.maps.Marker({position:{lat:o,lng:r},map:n})}a.appendChild(l)}}function e(){for(var t=document.querySelectorAll(".bouts li"),e=0;e<t.length;e++){var a=t[e];a.style.cursor="pointer",a.onclick=function(){window.location.href=this.querySelector("a").getAttribute("href")}}}t(),e()}();