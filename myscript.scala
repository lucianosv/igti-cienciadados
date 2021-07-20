package IGTI

import org.apache.spark.{SparkContext, SparkConf}

case class DadosCovidObj (data:String, siglaPais:String, pais:String, novosCasos:Int, totalCasos:Int, novasMortes:Int, totalMortes:Int);

object MPRApp {
   def main(args: Array[String]) {   
      var conf = new SparkConf().setAppName("IGTI EngDados");
      var sc = new SparkContext(conf);

      var rddCovid = sc.textFile("/usr/local/hadoop/Dados/covidData.txt");
      var rddCovidLines = rddCovid.map(linha => linha.split(","));
      var rddCovidListaObj = rddCovidLines.map(l => DadosCovidObj( l(0),l(1),l(2),l(4).toInt,l(5).toInt, l(6).toInt,l(7).toInt ) );
      println("Lista de Objetos");
      rddCovidListaObj.collect().foreach(println);

      var rddCovidFiltrado = rddCovidListaObj.filter(l => l.pais == "Brazil" );

      println("Total de registros do país filtrado"+rddCovidFiltrado.count);
      rddCovidFiltrado.collect().foreach(println);

      var rddChaveValor = rddCovidListaObj.map(l => (l.data, l.novasMortes) );

      var resultado = rddChaveValor.reduceByKey( (x,y) => x + y).sortByKey() ;

      println("Soma total de Mortes");

      resultado.collect().foreach(println);
    
   }
}
