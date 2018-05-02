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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WPFKeyboard
{
    /// <summary>
    /// UserControl1.xaml 的交互逻辑
    /// </summary>
    public partial class UserControl1 : UserControl
    {
        public UserControl1()
        {
            InitializeComponent();
        }

        private int selectPos;
        

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
                        selectPos = this.input.SelectionStart;
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
                    selectPos = this.input.SelectionStart;
                    if (input.Text.Length < 20)
                    {
                        input.Text = input.Text.Substring(0, selectPos) + intext + input.Text.Substring(selectPos);
                        selectPos += 1;
                        input.Focus();
                    }
                    input.Select(selectPos, 0);
                }
            }
        }

    }
}
