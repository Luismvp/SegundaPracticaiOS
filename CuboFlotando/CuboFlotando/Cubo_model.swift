//
//  Cubo_model.swift
//  CuboFlotando
//
//  Created by Luis Martin de Vidales Palomero on 19/9/18.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

//Modelo del sistema, esta clase se encarga de almacenar las operaciones con las variables.

class Cubo_model {
    //Variables del sistema------------
    //Lado del cubo
    var l = 1.0{
        //Si lo cambio, actualizamos el valor de las constantes de operación
        didSet{
            actualiza()
        }
    }
    //velocidad angular del sistema
    private var ø = 1.0
    
    init(){
        actualiza()
    }
    
    //Constantes de operación----------
    //Constante de gravedad
    let g = 9.8
    
    //Actualizamos la velocidad angular cada vez que cambiemos algo
    private func actualiza(){
        ø = sqrt(2*g/l)
    }
    //Posición en función de t
    func posicionT (_ t:Double)-> Double{
        return (1/2)*l*cos(ø*t)
    }
    //Velocidad en función de t
    func velocidadT (_ t:Double)-> Double{
        return (-1/2)*l*ø*sin(ø*t)
    }
    //Aceleración en función de t
    func aceleracionT (_ t:Double)-> Double{
        return (-g)*cos(ø*t)
    }
}
