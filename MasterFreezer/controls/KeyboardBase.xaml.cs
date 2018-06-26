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

namespace MasterFreezer.controls
{
    /// <summary>
    /// KeyboardBase.xaml 的交互逻辑
    /// </summary>
    public partial class KeyboardBase : UserControl
    {
        public TextBox input;
        public KeyboardBase()
        {
            InitializeComponent();
        }
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
