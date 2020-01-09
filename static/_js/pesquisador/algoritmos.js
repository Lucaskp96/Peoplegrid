/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var max = 0;
var min = Number.MAX_VALUE;

/**
 * fonte do algoritmo
 * http://bl.ocks.org/tmcw/4969184
 * 
 * @param {type} respostas
 * @param {type} rectArr
 * @param {type} numClasses
 * @param {type} colorClasses
 * @returns {unresolved}
 */

function naturalBreaks( respostas, rectArr, numClasses, colorClasses ){
    var celulas;
    var temp = new Array();
    var range;
    celulas = somatorioCelular(respostas);
    
    for (var i = 0; i < celulas.length; i++){
        if(celulas[i] > 0){
            temp.push(celulas[i]);
        }        
    }
    
    range = ss.jenks(temp,numClasses);
    
    for (var i = 0; i < celulas.length; i++){
        // percorre todas as classes dentro de uma celula
        for(var j = 0; j < numClasses; j++){    
            if((celulas[i] > range[j]) && (celulas[i] <= range[j+1])){
                var opt = {
                    fillColor: '#'+colorClasses[j],
                    fillOpacity: 0.5
                };
                rectArr[i].setOptions(opt);
            }
        }
    }
    var ret = {};
    ret['rectArr'] = rectArr;
    ret['range'] = range;
    return ret;
}

function classes( respostas, rectArr, numClasses, colorClasses ){
    var celulas;
    var range;
    var temp = new Array();
    
    celulas = somatorioCelular(respostas);
        
    for (var i = 0; i < celulas.length; i++){
        if(celulas[i] > 0){
            temp.push([i, celulas[i]]);
        }        
    }
    
    // ordena os valores    
    temp.sort(function(a,b) {return parseFloat(a[1]) - parseFloat(b[1]) });
   
    range = parseInt(temp.length/numClasses);
    var count = 0;
    for (var i = 0; i < numClasses; i++){
        for(var j = 0; j < range; j++){
            temp[count].push("#"+colorClasses[i]);
            count++;
        }
    }
    
    var aux = (range*numClasses);
    for (var i = aux; i < temp.length; i++){
        
        temp[i].push("#"+colorClasses[colorClasses.length-1]);
    }
    temp.sort(function(a,b) {return parseFloat(a[0]) - parseFloat(b[0]) });

    for(var i = 0; i < temp.length; i++){
            var opt = {
                fillColor: temp[i][2],
                fillOpacity: 0.5
            };
            
            rectArr[temp[i][0]].setOptions(opt);        
    }
    return rectArr;
}



function intervalar( respostas, rectArr, numClasses, colorClasses ){
    var celulas;
    var range;
    celulas = somatorioCelular(respostas);
    range = calculaClasses(celulas, numClasses, colorClasses);
    //console.log(range);
    
    //console.log(min +" "+max);
    for (var i = 0; i < celulas.length; i++){
        celulas[i] = celulas[i]*100/max;
    }
    
    
    //percorre todas as celulas
    for (var i = 0; i < rectArr.length; i++) {
        // percorre todas as classes dentro de uma celula
        if(numClasses === 1){
            
                for(var j = 0; j < numClasses; j++){
                    if(celulas[i] > 0) {
                    var opt = {
                        fillColor: '#'+colorClasses[j],
                        fillOpacity: 0.5
                    };
                    rectArr[i].setOptions(opt);
                    }
                }
        } else {
            for(var j = 0; j < numClasses-1; j++){
                if(j === 0){
                    if((celulas[i] > 0) && (celulas[i] <= range[j])) {
                        var opt = {
                            fillColor: '#'+colorClasses[j],
                            fillOpacity: 0.5
                        };
                        rectArr[i].setOptions(opt);
                    }
                    if((celulas[i] > range[j]) && (celulas[i] <= range[j+1])) {
                        var opt = {
                            fillColor: '#'+colorClasses[j+1],
                            fillOpacity: 0.5
                        };
                        rectArr[i].setOptions(opt);
                    }
                } else {

                    if((celulas[i] > range[j]) && (celulas[i] <= range[j+1])){
                        var opt = {
                            fillColor: '#'+colorClasses[j+1],
                            fillOpacity: 0.5
                        };
                        rectArr[i].setOptions(opt);
                    }
                }
            }
        }

    }
    return rectArr;
}


function somatorioCelular(respostas){
        var celulasResposta;
        var somatorioCelulas = [];
        limparGrid();
        
        for(var i = 0; i < rectArr.length; i++){
                somatorioCelulas[i] = 0; 
        }

        // percorre todas as repsostas da pergunta
        for (var i = 0; i < respostas.length; i++) {
                celulasResposta = $.parseJSON(respostas[i].grid); // recebe respostas do JSON

                // percorre todas as celulas de uma resposta
                for (var j = 0; j < celulasResposta.length; j++){
                        // vermelho
                        if(celulasResposta[j].cor === '#ff0000'){
                                somatorioCelulas[celulasResposta[j].idCelula] = somatorioCelulas[celulasResposta[j].idCelula] + 9; 
                        }
                        // laranja
                        if(celulasResposta[j].cor === '#ffa500'){
                                somatorioCelulas[celulasResposta[j].idCelula] = somatorioCelulas[celulasResposta[j].idCelula] + 3;
                        }
                        // amarelo
                        if(celulasResposta[j].cor === '#ffff00'){
                                somatorioCelulas[celulasResposta[j].idCelula] = somatorioCelulas[celulasResposta[j].idCelula] + 1;

                        }
                }
            }
            // console.log(somatorioCelulas);
    return somatorioCelulas;
}



function calculaClasses(celulas, numClasses, colorClasses){
    //console.log("aqui nas classes");
    var range = [];
    var porcentagem;
      
        // computa valores minimo e maximo
        for(var i = 0; i < celulas.length; i++){
                if(celulas[i] > max){
                        max = celulas[i];
                }
                if(celulas[i] < min && celulas[i] != 0){
                        min = celulas[i];
                }
        }
         // caso específico se tiver somente uma classe
        if(numClasses === 1){
            range[numClasses] = colorClasses[0];
            
        } else {
            porcentagem = 100/numClasses;
            
            for(var i = 0; i < numClasses; i++){
                range[i] = porcentagem*(i+1);
            }
        }
    return range;
}
