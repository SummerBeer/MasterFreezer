using MasterFreezer.views;
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

namespace MasterFreezer
{
    /// <summary>
    /// AdministorsettingWindow.xaml 的交互逻辑
    /// </summary>
    public partial class AdministorsettingWindow : Window
    {
        
        public AdministorsettingWindow()
        {
            InitializeComponent();
            
        }

        private void btnfinish_Click(object sender, RoutedEventArgs e)
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

        private void btnfanhuiadministor_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                AdministorWindow aChild = new AdministorWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }

        private void btnIPsetting_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                IPSetting aChild = new IPSetting();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }

        private void btnTempSetting_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                TempSetting aChild = new TempSetting();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }
    }
    
}
