﻿using System;
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
    /// PostercunfangWindow.xaml 的交互逻辑
    /// </summary>
    public partial class PostercunfangWindow : Window
    {
        public TextBox input;

        public PostercunfangWindow()
        {
            InitializeComponent();
            this.input = this.txtDingdanID;
        }

        private void btnfanhuicunfang_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                CunfangWindow aChild = new CunfangWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }
        private void btncunfang_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                CupboardNum aChild = new CupboardNum();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
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

        private void txtDingdanID_Focus(object sender, RoutedEventArgs e)
        {
            this.input = this.txtDingdanID;
        }
    }  
}
