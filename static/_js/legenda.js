var flagLeg = 0;
 
function gerarLegenda(n, total){

       var range = [];
       var porcentagem;

       if(flagLeg !== 0){
           $('#legenda').html("");
       }

       $('#legenda').html("<div id='legendaLang'>Legenda</div>");

       // caso específico se tiver somente uma classe
       if(n === 1){

           var legLinha = document.createElement('div');
           legLinha.setAttribute("id", "linha"+i);
           legLinha.style.clear = "both";
           legenda.appendChild(legLinha);

           var legCor = document.createElement('div');
           legCor.setAttribute("id", "cor");

           var legDesc = document.createElement('div');
           legDesc.setAttribute("id", "desc");

           legCor.style.background = "#"+cores[0];
           legCor.style.width = "15px";
           legCor.style.height = "15px";
           legCor.style.margin = "0 5 5 5";
           legCor.style.float = "left";
           //legDesc.style.position = "absolute";
           legDesc.style.padding = "0 0 0 25";
           legDesc.innerHTML = 0.01 +" - "+"100" ;           
           $('#linha'+i).append(legCor);
           $('#linha'+i).append(legDesc);
       } else {
           porcentagem = 100/n;
           for(var i = 0; i < n; i++){
               range[i] = porcentagem*(i+1);
           }
           
           for(var i = n-1; i >= 0;i--){
           var legLinha = document.createElement('div');
           legLinha.setAttribute("id", "linha"+i);
           legLinha.style.clear = "both";
           legenda.appendChild(legLinha);

           var legCor = document.createElement('div');
           legCor.setAttribute("id", "cor");

           var legDesc = document.createElement('div');
           legDesc.setAttribute("id", "desc");

           legCor.style.background = "#"+cores[i];
           legCor.style.width = "15px";
           legCor.style.height = "15px";
           legCor.style.margin = "0 5 5 5";
           legCor.style.float = "left";
           //legDesc.style.position = "absolute";
           legDesc.style.padding = "0 0 0 25";
           if(i === 0){
           } else {
               legDesc.innerHTML = 0.01 +" - "+range[i].toFixed(1);
               legDesc.innerHTML = range[i-1].toFixed(1)+" - "+ range[i].toFixed(1);
           }

           $('#linha'+i).append(legCor);
           $('#linha'+i).append(legDesc);
       }
    }
    $('#legenda').append("<br><hr><div id='total'><b>Nº de Respostas: "+total+"</b></div>");
     
}

function gerarLegendaNaturalBreaks(n, total, range){

       var porcentagem;
       
       if(flagLeg !== 0){
           $('#legenda').html("");
       }
       
       
       $('#legenda').html("<div id='legendaLang'>Legenda</div>");

       // caso específico se tiver somente uma classe
       if(n === 1){
            min = 0;
            max = range[range.length-1];
            
            //porcentagem = 100*range/n;
            for(var i = 0; i <= n; i++){

                    range[i] = 100*range[i]/max;
            }
           // range[0] = ((0.1*100)/max);
           var legLinha = document.createElement('div');
           legLinha.setAttribute("id", "linha"+i);
           legLinha.style.clear = "both";
           legenda.appendChild(legLinha);

           var legCor = document.createElement('div');
           legCor.setAttribute("id", "cor");

           var legDesc = document.createElement('div');
           legDesc.setAttribute("id", "desc");

           legCor.style.background = "#"+cores[0];
           legCor.style.width = "15px";
           legCor.style.height = "15px";
           legCor.style.margin = "0 5 5 5";
           legCor.style.float = "left";
           //legDesc.style.position = "absolute";
           legDesc.style.padding = "0 0 0 25";
           legDesc.innerHTML = range[0].toFixed(2)+" - "+range[1].toFixed(1) ;           
           $('#linha'+i).append(legCor);
           $('#linha'+i).append(legDesc);
       } else {
            min = 0;
            max = range[range.length-1];
             // console.log(range);
            //porcentagem = 100*range/n;
            for(var i = 0; i <= n; i++){

                    range[i] = 100*range[i]/max;
            }
            //range[0] = ((0.1*100)/max);
            
        for(var i = n; i >= 0;i--){
           var legLinha = document.createElement('div');
           legLinha.setAttribute("id", "linha"+i);
           legLinha.style.clear = "both";
           legenda.appendChild(legLinha);

           var legCor = document.createElement('div');
           legCor.setAttribute("id", "cor");

           var legDesc = document.createElement('div');
           legDesc.setAttribute("id", "desc");

           
           legCor.style.background = "#"+cores[i-1];
           legCor.style.width = "15px";
           legCor.style.height = "15px";
           legCor.style.margin = "0 5 5 5";
           legCor.style.float = "left";
           //legDesc.style.position = "absolute";
           legDesc.style.padding = "0 0 0 25";
           
           if( i == 0) {
               //legDesc.innerHTML = range[]" - "+ range[i].toFixed(1)+"";
            } else {
                    legDesc.innerHTML = range[i-1].toFixed(2)+" - "+ range[i].toFixed(1)+""; 
           }
           
           

           $('#linha'+i).append(legCor);
           $('#linha'+i).append(legDesc);
       }
    }
    $('#legenda').append("<br><hr><div id='total'><b>Nº de Respostas: "+total+"</b></div>");
     
}