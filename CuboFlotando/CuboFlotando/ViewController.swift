//
//  ViewController.swift
//  CuboFlotando
//
//  Created by Luis Martin de Vidales Palomero on 13/9/18.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

//Controlador del sistema, esta clase se ocupa de emplear los modelos para crear las vistas.

class ViewController: UIViewController, FunctionViewDataSource {
 
    //Declaración de variables del interfaz gráfico
    let cuboModel = Cubo_model()
    
    //Gráficas del programa
    
    @IBOutlet weak var positionTView: FunctionView!
    @IBOutlet weak var speedTView: FunctionView!
    @IBOutlet weak var accelerationTView: FunctionView!
    @IBOutlet weak var speedPosView: FunctionView!
    //Label y slider del lado
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var sideSlider: UISlider!
    //Label y slider del tiempo
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    //Lado en metros
    @IBOutlet weak var ladoEnMetros: UILabel!
    //Tiempo en segundos
    @IBOutlet weak var tiempoEnSegundos: UILabel!
    @IBOutlet weak var posicionEnT: UILabel!
    @IBOutlet weak var velocidadEnT: UILabel!
    @IBOutlet weak var aceleracionEnT: UILabel!
    //Variable que dice el instante de tiempo en el que pintamos cada vista
    
    var trayectoryTime: Double=0.0{
        //Cada vez que la cambiamos actualizamos todas las vistas.
        didSet{
            positionTView.setNeedsDisplay()
            speedTView.setNeedsDisplay()
            accelerationTView.setNeedsDisplay()
            speedPosView.setNeedsDisplay()
        }
    }
    //Variable que nos dice el lado del cuadrado que influye en el pintado de la vista
    var trayectorySide: Double=10{
        //Si lo cambiamos, repintamos
        didSet{
            positionTView.setNeedsDisplay()
            speedTView.setNeedsDisplay()
            accelerationTView.setNeedsDisplay()
            speedPosView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //inicialización de los dataSources de cada vista
        positionTView.dataSource = self
        speedTView.dataSource = self
        accelerationTView.dataSource = self
        speedPosView.dataSource = self
        ladoEnMetros.text = String(round(sideSlider.value*10)/10)+"m"
        tiempoEnSegundos.text = String(round(timeSlider.value*10)/10)+"s"
        posicionEnT.text = String(round(cuboModel.posicionT(Double(timeSlider!.value))*10)/10)+"m"
        velocidadEnT.text = String(round(cuboModel.velocidadT(Double(timeSlider!.value))*10)/10)+"m/s"
        aceleracionEnT.text = String(round(cuboModel.aceleracionT(Double(timeSlider!.value))*10)/10)+"m/s^2"
        positionTView.scaleX = 14
        positionTView.scaleY = 20
        speedTView.scaleX = 14
        speedTView.scaleY = 6
        accelerationTView.scaleX = 14
        accelerationTView.scaleY = 2
        speedPosView.scaleX = 35
        speedPosView.scaleY = 10
        //lado inicial
        cuboModel.l = Double(sideSlider.value)
        //Cada vez que cambia el valor del slider ejecuta la IBAction correspondiente
        sideSlider.sendActions(for: .valueChanged)
        timeSlider.sendActions(for: .valueChanged)
        
    }
    
    //--> Acciones
    
    //Función que repinta la pantalla al cambiar de orientación
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait{
            positionTView.setNeedsDisplay()
            speedTView.setNeedsDisplay()
            accelerationTView.setNeedsDisplay()
            speedPosView.setNeedsDisplay()
        } else if UIDevice.current.orientation.isLandscape{
            positionTView.setNeedsDisplay()
            speedTView.setNeedsDisplay()
            accelerationTView.setNeedsDisplay()
            speedPosView.setNeedsDisplay()
        }
    }
    //Función que actualiza el lado del cuadrado a tener en la ecuación en
    //función del slider.
    @IBAction func updateSide(_ sender: UISlider) {
        
        trayectorySide = Double(sender.value)
        cuboModel.l = trayectorySide
        ladoEnMetros.text = String(round(sender.value*10)/10)+"m"
        posicionEnT.text = String(round(cuboModel.posicionT(Double(timeSlider.value))*10)/10)+"m"
        velocidadEnT.text = String(round(cuboModel.velocidadT(Double(timeSlider.value))*10)/10)+"m/s"
        aceleracionEnT.text = String(round(cuboModel.aceleracionT(Double(timeSlider.value))*10)/10)+"m/s^2"
        positionTView.setNeedsDisplay()
        speedTView.setNeedsDisplay()
        accelerationTView.setNeedsDisplay()
        speedPosView.setNeedsDisplay()
        
    }
    //Función que actualiza el valor del tiempo en las funciones que pintan las gráficas.
    @IBAction func updateTime(_ sender: UISlider) {
        tiempoEnSegundos.text = String(round(sender.value*10)/10)+"s"
        posicionEnT.text = String(round(cuboModel.posicionT(Double(sender.value))*10)/10)+"m"
        velocidadEnT.text = String(round(cuboModel.velocidadT(Double(sender.value))*10)/10)+"m/s"
        aceleracionEnT.text = String(round(cuboModel.aceleracionT(Double(sender.value))*10)/10)+"m/s^2"
        
        positionTView.setNeedsDisplay()
        speedTView.setNeedsDisplay()
        accelerationTView.setNeedsDisplay()
        speedPosView.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Reconocedores de gestos
    
    @IBAction func escaladoTocho(_ sender: UIPinchGestureRecognizer) {
        
        let f  = sender.scale
        
        positionTView.scaleX *= Double(f)
        positionTView.scaleY *= Double(f)
        
        speedTView.scaleX *= Double(f)
        speedTView.scaleY *= Double(f)
        
        accelerationTView.scaleX *= Double(f)
        accelerationTView.scaleY *= Double(f)
        
        speedPosView.scaleX *= Double(f)
        speedPosView.scaleY *= Double(f)
        
        positionTView.setNeedsDisplay()
        speedTView.setNeedsDisplay()
        accelerationTView.setNeedsDisplay()
        speedPosView.setNeedsDisplay()
        sender.scale = 1
    }
    
    @IBAction func escaladoFinoMenor(_ sender: UISwipeGestureRecognizer) {
        positionTView.scaleX *= Double(0.9)
        positionTView.scaleY *= Double(0.9)
        
        speedTView.scaleX *= Double(0.9)
        speedTView.scaleY *= Double(0.9)
        
        accelerationTView.scaleX *= Double(0.9)
        accelerationTView.scaleY *= Double(0.9)
        
        speedPosView.scaleX *= Double(0.9)
        speedPosView.scaleY *= Double(0.9)
        
        positionTView.setNeedsDisplay()
        speedTView.setNeedsDisplay()
        accelerationTView.setNeedsDisplay()
        speedPosView.setNeedsDisplay()
    }
    @IBAction func escaladoFinoMayor(_ sender: UISwipeGestureRecognizer) {
        positionTView.scaleX *= Double(1.1)
        positionTView.scaleY *= Double(1.1)
        
        speedTView.scaleX *= Double(1.1)
        speedTView.scaleY *= Double(1.1)
        
        accelerationTView.scaleX *= Double(1.1)
        accelerationTView.scaleY *= Double(1.1)
        
        speedPosView.scaleX *= Double(1.1)
        speedPosView.scaleY *= Double(1.1)
        
        positionTView.setNeedsDisplay()
        speedTView.setNeedsDisplay()
        accelerationTView.setNeedsDisplay()
        speedPosView.setNeedsDisplay()
    }
    
   //-->llamadas al datasource
    
    //Instante inicial (siempre 0.0)
    func startTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        switch functionView {
        case positionTView:
            return 0.0
        case speedTView:
            return 0.0
        case accelerationTView:
            return 0.0
        case speedPosView:
            return 0.0
        default:
            return 0.0
        }
    }
    //Instante final
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        switch functionView {
        case positionTView:
            return 4*Double.pi
        case speedTView:
            return 4*Double.pi
        case accelerationTView:
            return 4*Double.pi
        case speedPosView:
            return 4*Double.pi
        default:
            return 4*Double.pi
        }
    }
    
    func functionView(_ functionView: FunctionView, pointAt index: Double) -> Point {
        switch functionView {
        case positionTView:
            let time = index
            let p = cuboModel.posicionT(time)
            return Point(x:time,y:p)
        case speedTView:
            let time = index
            let s = cuboModel.velocidadT(time)
            return Point(x:time,y:s)
        case accelerationTView:
            let time = index
            let a = cuboModel.aceleracionT(time)
            return Point(x:time,y:a)
        case speedPosView:
            let time = index
            let p = cuboModel.posicionT(time)
            let s = cuboModel.velocidadT(time)
            return Point(x:p,y:s)
        default:
            return Point(x:0.0,y:0.0)
        }
    }
    
    func pointsOfFunctionView(_ functionView: FunctionView) -> [Point] {
        switch functionView {
        case positionTView:
            let p = cuboModel.posicionT(Double(timeSlider.value))
            return [Point(x:Double(timeSlider.value) , y: p)]
        case speedTView:
            let s = cuboModel.velocidadT(Double(timeSlider.value))
            return [Point(x: Double(timeSlider.value), y: s)]
        case accelerationTView:
            let a = cuboModel.aceleracionT(Double(timeSlider.value))
            return [Point(x: Double(timeSlider.value), y: a)]
        case speedPosView:
            let p = cuboModel.posicionT(Double(timeSlider.value))
            let s = cuboModel.velocidadT(Double(timeSlider.value))
            return [Point(x: p, y: s)]
        default:
            return [Point(x: 0.0, y: 0.0)]
        }
        
    }
}

