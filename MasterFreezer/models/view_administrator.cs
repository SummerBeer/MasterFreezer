using System;
using System.Linq;
using System.Text;

namespace Models
{
    ///<summary>
    ///VIEW
    ///</summary>
    public partial class view_administrator
    {
           public view_administrator(){


           }
           /// <summary>
           /// Desc:
           /// Default:0
           /// Nullable:False
           /// </summary>           
           public long ID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public string PhoneNumber {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public string RealName {get;set;}

    }
}
