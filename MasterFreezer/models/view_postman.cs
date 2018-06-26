using System;
using System.Linq;
using System.Text;

namespace Models
{
    ///<summary>
    ///VIEW
    ///</summary>
    public partial class view_postman
    {
           public view_postman(){


           }
           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string ExpressCompanyName {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0
           /// Nullable:False
           /// </summary>           
           public long ID {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string Memo {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public string Name {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:False
           /// </summary>           
           public string PhoneNumber {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string PostmanCode {get;set;}

           /// <summary>
           /// Desc:
           /// Default:0000-00-00 00:00:00
           /// Nullable:False
           /// </summary>           
           public DateTime Registertime {get;set;}

           /// <summary>
           /// Desc:
           /// Default:
           /// Nullable:True
           /// </summary>           
           public string State {get;set;}

    }
}
