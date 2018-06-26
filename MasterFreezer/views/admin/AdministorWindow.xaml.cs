using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using SqlSugar;
using MasterFreezer.db;
using Models;

namespace MasterFreezer
{
    /// <summary>
    /// AdministorWindow.xaml 的交互逻辑
    /// </summary>
    public partial class AdministorWindow : Window
    {
        public TextBox input;
        //private int selectPos;

        public AdministorWindow()
        {
            InitializeComponent();
            this.input = this.txtUserId;
        }

        private void btnlogin2_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                SqlSugarClient db = new DbContext().db;
                tb_administrator r = db.Queryable<tb_administrator>().Where(it => it.PhoneNumber == txtUserId.Text).Single();

                if (r != null)
                {
                    if (r.MyPassword == txtPassword.Text)
                    {
                        AdministorsettingWindow child = new AdministorsettingWindow();
                        child.Show();
                        this.Visibility = System.Windows.Visibility.Hidden;
                    }
                    else
                    {
                        Console.WriteLine("密码错误");
                    }
                }
                else
                {
                    Console.WriteLine("用户名错误");
                }
            }
        }

        private void btnfanhui2_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                MainWindow aChild = new MainWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }

        private void txtUserId_Focus(object sender, RoutedEventArgs e)
        {
            this.input = this.txtUserId;
        }

        private void txtPassword_Focus(object sender, RoutedEventArgs e)
        {
            this.input = this.txtPassword;
        }

        /// <summary>
        /// 点击按钮输入
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LayoutRoot_Click(object sender, RoutedEventArgs e)
        {
            Button bt = e.OriginalSource as Button;
            if (bt != null)
            {
                string intext = bt.Content.ToString();
                if (intext == "退格")
                {
                    if (!string.IsNullOrEmpty(input.Text))
                    {
                        int selectPos = this.input.SelectionStart;
                        if (selectPos != 0)
                        {
                            input.Text = input.Text.Substring(0, selectPos - 1) + input.Text.Substring(selectPos);

                            selectPos -= 1;
                            input.Focus();
                            input.Select(selectPos, 0);
                        }
                    }
                }
                else if (intext == "清除")
                {
                    input.Clear();
                }
                else if (intext == "确定")
                {
                    SqlSugarClient db = new DbContext().db;
                    tb_administrator r = db.Queryable<tb_administrator>().Where(it => it.PhoneNumber == txtUserId.Text).Single();

                    if(r != null)
                    {
                        if(r.MyPassword == txtPassword.Text)
                        {
                            AdministorsettingWindow child = new AdministorsettingWindow();
                            child.Show();
                            this.Visibility = System.Windows.Visibility.Hidden;
                        }
                        else
                        {
                            Console.WriteLine("密码错误");
                        }
                    }
                    else
                    {
                        Console.WriteLine("用户名错误");
                    }
                }
                else
                {
                    int selectPos = this.input.SelectionStart;

                    input.Text = input.Text.Substring(0, selectPos) + intext + input.Text.Substring(selectPos);
                    selectPos += 1;
                    input.Focus();
                    input.Select(selectPos, 0);

                }
            }
        }
    }
}
