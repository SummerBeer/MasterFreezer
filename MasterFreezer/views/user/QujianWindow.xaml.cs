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

namespace MasterFreezer
{
    /// <summary>
    /// QujianWindow.xaml 的交互逻辑
    /// </summary>
    public partial class QujianWindow : Window
    {
        public TextBox input;
        public QujianWindow()
        {
            InitializeComponent();
            this.input= this.txtUserID;
        }

        private void btnfanhuiyonghu_Click(object sender, RoutedEventArgs e)
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

        private void btnqujian_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                OpenWindow aChild = new OpenWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }

        private void txtUserID_Focus(object sender, RoutedEventArgs e)
        {
            this.input = this.txtUserID;
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
                    //不处理
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
