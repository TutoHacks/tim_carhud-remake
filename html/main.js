$(function(){
	window.addEventListener('message', function(event) {
		if(event.data.showhud == true){
			$('.huds').fadeIn();
			setProgressSpeed(event.data.speed,'.progress-speed');
		}
		if(event.data.showstandort == true){
			$('#textLokalisierung').text(event.data.standort);
		}
		if(event.data.showDni == true){
			$('#textDni').text(event.data.dni);
		}
		if (event.data.action == "setTalking"){

			setTalking(event.data.value)
		}else if (event.data.action == "setProximity"){
			setProximity(event.data.value)
		} else if (event.data.action == "toggleCar"){
			if (event.data.show){
				$('.carStats').fadeIn();
				$('.other').fadeIn();
				
			} else{
				$('.carStats').fadeOut();
				$('.other').fadeOut();
			}
		} else if (event.data.action == "toggleAllHud"){
			if (event.data.show){
				$('.playerStats2').css('left','45.5%');
				$('.playerStats2').css('bottom','1.85%');
			} else{
				$('.playerStats2').css('left','45.5%');
				$('.playerStats2').css('bottom','1.85%');
			}
		} else if (event.data.action == "animateMap"){
			if (event.data.show){
				$('#standort2').css('left', '25%');
			} else{
				$('#standort2').css('left', '1.5%');
			}
		} else if (event.data.action == "animateHud"){
			if (event.data.show){
				$('#standort2').css('left', '17%');
			} else{
				$('#standort2').css('left', '1.5%');
			}
		} else if (event.data.action == "engineSwitch"){
            if(event.data.status){
                $('#engine').css('background-image','url(img/vehicle/on.png)');
            }else{
                $('#engine').css('background-image','url(img/vehicle/off.png)');
            }
		} else if (event.data.action == "lockSwitch"){
            if(event.data.status){
                $('#lock').css('background-image','url(img/vehicle/unlocked.png)');
            }else{
                $('#lock').css('background-image','url(img/vehicle/locked.png)');
            }
		}else if (event.data.action == "toggleAllHud"){
			toggleAllHud(event.data.status)
		}else if (event.data.action == "updateGas"){
            setProgressFuel(event.data.value,'.progress-fuel');
		}else if (event.data.action == "updateKM"){
            setProgressKM(event.data.value,'.progress-km');
		}
	});

});

function setProximity(value){
	var color;
	var speaker;
	if (value == "whisper"){
		speaker = "url(img/speaker1.png)";
	}else if (value == "normal"){
		speaker = "url(img/speaker2.png)";
	}else if (value == "shout"){
		speaker = "url(img/speaker3.png)";

	}
	$('#voicestandort').css('background-image', speaker);
}

function setTalking(value){
	if (value){
		//#64B5F6
		$('.kolkoVoice').css('background-size', '40% 40%')
	}else{
		//#81C784
		$('.kolkoVoice').css('background-size', '45% 45%')
	}
}

function setProgressSpeed(value, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value*100/220;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;
	
    var predkosc = Math.floor(value * 1.8)
    if (predkosc == 81 || predkosc == 131) {
      predkosc = predkosc - 1
    }

    html.text(predkosc + " KM/H");
  }

  function setProgressFuel(percent, element){

    document.getElementById('fueltext').innerHTML = percent + ".0 L";
  }
  
    function setProgressKM(km, element){

    document.getElementById('kmtext').innerHTML = km + " KM";
  }
