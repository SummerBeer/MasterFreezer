using System;
using System.Linq;
using System.Text;

namespace Models
{
    ///<summary>
    ///
    ///</summary>
    public partial class tb_terminal
    {
           public tb_terminal(){


           }
           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public int CityID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0.0
           /// Nullable:True
           /// </summary>           
           public decimal? ColdstorageSettingTemperature {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public int CountyID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public int CupboardNumber {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0.0
           /// Nullable:True
           /// </summary>           
           public decimal? FreezingSettingTemperature {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public long ID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0.000000
           /// Nullable:True
           /// </summary>           
           public decimal? Latitude {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0.000000
           /// Nullable:True
           /// </summary>           
           public decimal? Longitude {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public int ProvinceID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public string Region {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string ServerIP {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public int? ServerPort {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string SoftVer {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0
           /// Nullable:False
           /// </summary>           
           public int State {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0.0
           /// Nullable:True
           /// </summary>           
           public decimal? TemperatureControlDeviation {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string TerminalName {get;set;}

    }
}
