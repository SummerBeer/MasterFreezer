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
    /// StoreState.xaml 的交互逻辑
    /// </summary>
    public partial class StoreState : Window
    {
        public StoreState()
        {
            InitializeComponent();
        }

        private void btnfinish_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                PostercunfangWindow aChild = new PostercunfangWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Button bt = e.OriginalSource as Button;
            //button选中
            if (bt != null)
            {
                //string num = bt.Content.ToString();
                bt.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#FF8AEC5C"));

            }
            //达到只选中一个按钮的效果
            switch (bt.Name.ToString())
            {
                case "key1": key2.IsEnabled = false; break;
                case "key2": key1.IsEnabled = false; break;  
            }
        }

        private void btnfanhuicunfang_Click(object sender, RoutedEventArgs e)
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

        private void btnback_Click(object sender, RoutedEventArgs e)
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
    }
}
