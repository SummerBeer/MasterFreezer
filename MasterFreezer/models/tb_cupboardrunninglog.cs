using System;
using System.Linq;
using System.Text;

namespace Models
{
    ///<summary>
    ///
    ///</summary>
    public partial class tb_cupboardrunninglog
    {
           public tb_cupboardrunninglog(){


           }
           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public long CupboardID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0000-00-00 00:00:00
           /// Nullable:False
           /// </summary>           
           public DateTime Endtime {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string Memo {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0000-00-00 00:00:00
           /// Nullable:False
           /// </summary>           
           public DateTime Starttime {get;set;}

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
           public decimal? Temperature {get;set;}

    }
}
