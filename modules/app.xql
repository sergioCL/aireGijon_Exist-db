xquery version "3.0";

module namespace app="http://ri.org/aire_de_calidad/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://ri.org/aire_de_calidad/config" at "config.xqm";


declare function app:test($node as node(), $model as map(*)) {
    <p>lo que de que ? tamos en esta fecha: {current-dateTime()}. y ahí 
    va un code mi arma<code>class="app:test"</code>. <br/> <marquee>toy en una function de app.xql</marquee></p>
    
};

declare function app:averageCurrentValues($node as node(), $model as map(*)){

    
    <ul>
        <marquee><p>la información se actualiza cada 60 minutos aprox</p></marquee>
        {
            
        let $estaciones :=
        (
            for $b in distinct-values(doc("http://opendata.gijon.es/descargar.php?id=1&#38;tipo=XML")//estacion)
            let $c := doc("http://opendata.gijon.es/descargar.php?id=1&#38;tipo=XML")//calidadairemediatemporal[estacion = $b][1]
            return $c
        )

        for $a in doc("http://opendata.gijon.es/descargar.php?id=5&#38;tipo=XML")//parametroestacion
        let $f := <values>{ ($estaciones/*[string(node-name(.))= lower-case($a/tag)]) }</values>
        return
            <li>
                {
                    data($a/descripcionparametro), ":",app:avg-empty-is-zero($f/*,$f), data($a/unidad)
        
                }
    
            </li>
            
        }
    </ul>
};

declare function app:combo-estaciones($node as node(), $model as map(*)){
    <select name="stations">
    {
        for $a in doc("http://opendata.gijon.es/descargar.php?id=4&#38;tipo=xml")//estacion/direccion
        return <option>{$a}</option>
        
    }
    </select>
};

declare function app:consulta-estacion($node as node(), $model as map(*),$stationDir as xs:string?){
    if($stationDir) then(
    <ul id="mresultLis">{ 
    let $stationId := doc("http://opendata.gijon.es/descargar.php?id=4&#38;tipo=xml")//estacion[direccion = $stationDir]/id 
    
    let $station := doc("http://opendata.gijon.es/descargar.php?id=1&#38;tipo=XML")//calidadairemediatemporal[estacion = $stationId][1]
    
    for $a in doc("http://opendata.gijon.es/descargar.php?id=5&#38;tipo=XML")//parametroestacion
        let $f :=  ($station/*[string(node-name(.))= lower-case($a/tag)])
        return
            if(empty($f) or data($f = " ") or (data($f)=""))then
                ()
            else(
                <li>{
                    (data($a/descripcionparametro), ":",data($f), data($a/unidad))  
                }</li>)
    }</ul>
)
    else("error al recibir la estación a mostrars")
};

(:Función obtenida de la siguiente fuente http://www.xqueryfunctions.com/xq/functx_avg-empty-is-zero.html :)
declare function app:avg-empty-is-zero( $values as xs:anyAtomicType* ,$allNodes as node()* )  as xs:double 
{
   if (empty($allNodes))
   then 0
   else sum($values[string(.) != '']) div count($allNodes)
 } ;