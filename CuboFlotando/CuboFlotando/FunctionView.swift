//
//  FunctionView.swift
//  CuboFlotando
//
//  Created by Luis Martin de Vidales Palomero on 19/9/18.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

//Vistas del sistema, con los datos que les suministra el controlador pintan la pantalla.

struct Point {
    var x = 0.0
    var y = 0.0
}
//DataSource de la functionView, que el view controller utilizará para comunicar la view con el modelo
protocol FunctionViewDataSource: class{
    //Función para recibir el instante inicial
    func startTimeOfFunctionView(_ functionView: FunctionView) -> Double
    //Función para recibir el instante final
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double
    //Función para recibir el punto en un instante determinado
    func functionView (_ functionView: FunctionView, pointAt index:Double) -> Point
    //Función para recibir el array con los puntos de interés de la función.
    func pointsOfFunctionView(_ functionView: FunctionView) -> [Point]
    
}
//Clase FunctionView
@IBDesignable
class FunctionView: UIView {
    //Variables de pintado de las gráficas, definimos anchos, colores, textos, escalas, resoluciones etc.
    @IBInspectable
    var lineWidth:Double = 3.0
    @IBInspectable
    var trayectoryColor:UIColor = UIColor.red
    @IBInspectable
    var textX:String = "x"
    @IBInspectable
    var textY:String = "y"
    @IBInspectable
    var scaleX:Double = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scaleY:Double = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var resolution:Double = 500{
        didSet{
            setNeedsDisplay()
        }
    }
    //Constructor del datasource
    //Si llamamos desde el interface builder
    #if TARGET_INTERFACE_BUILDER
    var dataSource: FunctionViewDataSource!
    //Si no
    #else
    weak var dataSource: FunctionViewDataSource!
    
    #endif
    //Inicializamos los valores, cuando pasamos cosas desde el viewController(Interface Builder)
    //se sustituyen los valores por los que pasamos cada vez que utilicemos una de las funciones.
    override func prepareForInterfaceBuilder() {
        class FakeDataSource : FunctionViewDataSource{
            func pointsOfFunctionView(_ functionView: FunctionView) -> [Point] {
              return []
            }
            func functionView(_ functionView: FunctionView, pointAt index: Double) -> Point {
               return Point(x: index, y: index)
            }
            func startTimeOfFunctionView(_ functionView: FunctionView) -> Double {return 0.0}
            
            func endTimeOfFunctionView(_ functionView: FunctionView) -> Double {return 1.0}
        }
        dataSource = FakeDataSource()
    }
    //Función draw, en ella llamamos a las funciones que pintan el contenido de cada vista
    //estas funciones pintarán los ejes, los textos, las trayectorias y los puntos de interés
    //en función de que gráfica sea la que corresponda a cada FunctionView
    override func draw(_ rect : CGRect){
        drawAxis()
        drawTicks()
        drawText()
        drawTrayectory()
        drawPOI()
    }
    //Dibuja los ejes
    private func drawAxis(){
        let width = bounds.size.width
        let height = bounds.size.height
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0.0))
        path1.addLine(to: CGPoint(x: width/2, y: height))
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: height/2))
        path2.addLine(to: CGPoint(x: width, y: height/2))
        UIColor.black.setStroke()
        path1.stroke()
        path2.stroke()
        path2.lineWidth = 1
        path1.lineWidth = 1
        
    }
    //Dibuja ticks en los ejes
    private func drawTicks(){
        let nTicks = 10.0
        
        UIColor.black.set()
        //Primero los ticks del eje X, ajustamos resolución en función de las gráficas
        let ptsYByTick = Double(bounds.size.height) / nTicks
        let unitsYByTick = (ptsYByTick / scaleY).roundedOneDigit
        for i in stride(from: -nTicks*unitsYByTick, to: nTicks*unitsYByTick, by: unitsYByTick){
            let px = pointForX(0.0)
            let py = pointForY(i)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px-2, y: py))
            path.addLine(to: CGPoint(x: px+2, y: py))
            path.stroke()
        }
        //Después los ticks del eje X, ajustamos resolución en función de las gráficas
        let ptsXByTick = Double(bounds.size.width) / nTicks
        let unitsXByTick = (ptsXByTick / scaleX).roundedOneDigit
        for i in stride(from: -nTicks*unitsXByTick, to: nTicks*unitsXByTick, by: unitsXByTick){
            let px = pointForX(i)
            let py = pointForY(0.0)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px, y: py-2))
            path.addLine(to: CGPoint(x: px, y: py+2))
            path.stroke()
        }
        
    }
    //Dibuja los textos con el formato adecuado y los situa donde renta de la vista
    private func drawText(){
        let width = bounds.size.width
        let height = bounds.size.height
        let attrs = [NSAttributedString.Key.font: UIFont.init(name: "Charter", size: 12.0)]
        let offset: CGFloat = 2
        let asX = NSAttributedString(string: textX, attributes: attrs as Any as? [NSAttributedString.Key : Any])
        let sizeX = asX.size()
        //situamos el texto x al final del eje x
        let posX = CGPoint(x: width - sizeX.width - offset, y: height/2 + 10*offset)
        asX.draw(at: posX)
        
        let asY = NSAttributedString(string: textY, attributes: attrs as Any as? [NSAttributedString.Key : Any])
        //situamos el texto y arriba del eje y
        let posY = CGPoint(x: width/2 - (30*offset+3), y: offset)
        asY.draw(at: posY)
    }
    //Dibuja la trayectoria de la función introducida a través del dataSource
    private func drawTrayectory(){
        //Si no hay dataSource, no sabemos que vista hay que dibujar
        if dataSource == nil{
            //Pues no lo hacemos
            return
        }
        //En el caso de que si que haya datasource, sacamos los instantes iniciales y finales
        let startTime = dataSource.startTimeOfFunctionView(self)
        let endTime = dataSource.endTimeOfFunctionView(self)
        //El ajuste de la resolución nos dará curvas más suaves o más bruscas
        let path = UIBezierPath()
        //Sacamos el punto en el instante inicial
        var point = dataSource.functionView(self, pointAt: startTime)
        
        var px = pointForX(point.x)
        var py = pointForY(point.y)
        //Movemos el inicio del dibujo al punto en el instante inicial
        path.move(to: CGPoint(x:px,y:py))
        //Pintamos la linea punto a punto, el stride llega hasta el endTime sin contenerlo, por eso
        //hay que pintarlo aparte
        for t in stride(from: startTime, to: endTime, by: 0.01){
            //Sacamos el punto en el instante t
            
            point = dataSource.functionView(self, pointAt: t)
            px = pointForX(point.x)
            py = pointForY(point.y)
            //Pintamos el punto
            path.addLine(to: CGPoint(x:px,y:py))
            //path.move(to: CGPoint(x:px,y:py))
        }
        //Pintamos aparte el último punto
        point = dataSource.functionView(self, pointAt: endTime)
        px = pointForX(point.x)
        py = pointForY(point.y)
        path.move(to: CGPoint(x: px, y: py))
        //Anchos de línea y colorines
        path.lineWidth = CGFloat(lineWidth)
        trayectoryColor.set()
        path.stroke()
    }
    //Pintamos los puntos de interes que serán los puntos gordos que se mueven con las gráficas
    private func drawPOI(){
        for p in dataSource.pointsOfFunctionView(self){
            let px = pointForX(p.x)
            let py = pointForY(p.y)
            let path = UIBezierPath(ovalIn: CGRect(x: px-4, y: py-4, width: 8, height: 8))
            UIColor.brown.set()
            path.stroke()
            path.fill()
        }
    }
    
    //Calcula el punto de x en función de una x que se le pasa, partiendo de la mitad del eje x
    private func pointForX(_ x: Double) -> CGFloat {
        
        let width = bounds.size.width
        return width/2 + CGFloat(x*scaleX)
    }
    //Calcula el punto de y en función de una y que se le pasa a partir de la mitad del eje y
    private func pointForY(_ y: Double) -> CGFloat {
        
        let height = bounds.size.height
        return height/2 - CGFloat(y*scaleY)
    }
}
//Añadimos el atributo roundedOneDigit a la clase Double. Con él hacemos el redondeo a un solo dígito
//de un valor Double.
extension Double {
    var roundedOneDigit:Double {
        get {
            var d = self
            var by = 1.0
            
            while d > 10 {
                d /= 10
                by = by * 10
            }
            while d < 1 {
                d *= 10
                by = by / 10
            }
            return d.rounded() * by
        }
    }
    
}
