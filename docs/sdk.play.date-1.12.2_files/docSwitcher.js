var versions = "";
var versionsPath = "/js/versions.json";
var cacheBuster = "?" + Date.now().toString();
var latest;
var thisVersion;
var docSwitcher = document.querySelector("#docSwitcher");

var deprecationWarning = document.createElement("div");
deprecationWarning.id = "deprecationWarning";
deprecationWarning.innerText = "This version is old.";


fetch((versionsPath + cacheBuster))
	.then(function (response) {
		return response.json();
	})
	.then(function (data) {
		buildSwitcher(data);
	})
	.catch(function (err) {
		console.log(err);
	});

function buildSwitcher(versionData){

	latest = versionData.versions[0];

	if (versionData.versions.length > 1)
	{
		for(var key in versionData.versions) {

			if (document.location.pathname.indexOf(versionData.versions[key]) > 0)
			{
				thisVersion = versionData.versions[key];
				selected = "selected";
			} else {
				selected = "";
			}
			versions += "<option value=\"" + versionData.versions[key] + "\" " + selected + ">Version " + versionData.versions[key] + "</option>"
		}

		document.querySelector("select#versions").innerHTML = versions;

		if (document.location.pathname.indexOf(latest) < 0)
		{
			docSwitcher.appendChild(deprecationWarning);
			docSwitcher.classList.add("deprecated");
		}
	} else {
		docSwitcher.style.display = "none";
	}
}

function switchVersions(v){
	window.location.href = window.location.protocol + "//" + window.location.host + window.location.pathname.replaceAll(thisVersion, v) + window.location.hash;
}

var navbarHeight = document.querySelector('#navbar').offsetHeight;

var activeMarker = "";
var visibleMarkers = [];

window.addEventListener('DOMContentLoaded', () => {

	function addVisible(id) {
		if ( visibleMarkers.indexOf(id) < 0 )
		{
			// Add this id to the list of visible markers
			visibleMarkers.push(id);
		}
		updateMarkers();
	}

	function removeVisible(id) {
		if ( visibleMarkers.length === 1 ) {
			// Remove this id and return an empty array
			visibleMarkers = [];
		}
		else {
			// Remove this id from the list of visible markers
			visibleMarkers.splice(visibleMarkers.indexOf(id),1);
		}
		updateMarkers();
	}

	function updateMarkers(){
		if ( visibleMarkers.length > 0 ) {
			var firstVisible = visibleMarkers[0];
			if ( activeMarker !== firstVisible ) {
				makeActive(firstVisible);
			}
		}
	}

	function makeActive(id){
		activeMarker = id;
		// Clear the current active TOC entry
		var oldMarker = document.querySelector("#toc li a.active");
		if ( oldMarker ) {
			oldMarker.classList.remove('active');
		}
		// Mark the TOC entry as active, and scroll to it.
		document.querySelector(`#toc li a[href="#${activeMarker}"]`).classList.add('active');
		document.querySelector('#toc').scrollTo({
			left: 0,
			top: (document.querySelector(`#toc li a[href="#${activeMarker}"]`).parentElement.offsetTop - navbarHeight),
			behavior: 'smooth'
		});
	}

	const observer = new IntersectionObserver(entries => {
		entries.forEach(entry => {
			const id = entry.target.getAttribute('id');
			if ( entry.intersectionRatio === 0 && visibleMarkers.indexOf(id) > -1 ) {
				removeVisible(id);
			}
			if ( entry.intersectionRatio > 0 ) {
				addVisible(id);
			}
		});
	});
	document.querySelectorAll('h2[id],h3[id],h4[id],h5[id]').forEach((section) => {
	  observer.observe(section);
	});
});
