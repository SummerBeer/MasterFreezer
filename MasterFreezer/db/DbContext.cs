using SqlSugar;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Configuration;

namespace MasterFreezer.db
{
    class DbContext
    {
        private string connStr = ConfigurationManager.AppSettings["ConnectionString"];

        public SqlSugarClient db;

        public DbContext()
        {
            db = new SqlSugarClient(new ConnectionConfig()
            {
                ConnectionString = connStr,
                DbType = DbType.MySql,//数据库类型
                IsAutoCloseConnection = true, //是否自动释放数据库
                InitKeyType = InitKeyType.Attribute /*(默认SystemTable)初始化主键和自增列信息的方式(注意：如果是数据库权限受管理限制一定要设成attribute)
InitKeyType.SystemTable表示自动从数据库读取主键自增列的信息
InitKeyType.Attribute 表示从属性中读取 主键和自增列的信息*/
            });
            
        }
    }
}
