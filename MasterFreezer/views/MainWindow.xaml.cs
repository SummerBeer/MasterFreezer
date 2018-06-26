using MasterFreezer.db;
using MasterFreezer.views;
using SqlSugar;
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
using System.Windows.Threading;

namespace MasterFreezer
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        private int time = 6;
        
        public MainWindow()
        {
            this.Loaded += Window_Loaded;
            InitializeComponent();
            Console.WriteLine("init..");
            
            //SqlSugarClient db = new DbContext().db;
        }

        //show timer 
        public void ShowCurTimer(object sender, EventArgs e)
        {
            //"星期"+DateTime.Now.DayOfWeek.ToString(("d"))

            //获得星期几
            this.Tt.Text = DateTime.Now.ToString("dddd", new System.Globalization.CultureInfo("zh-cn"));
            this.Tt.Text += " ";
            //获得年月日
            this.Tt.Text += DateTime.Now.ToString("yyyy年MM月dd日");   //yyyy年MM月dd日
            this.Tt.Text += " ";
            //获得时分秒
            this.Tt.Text += DateTime.Now.ToString("HH:mm");
            //System.Diagnostics.Debug.Print("this.ShowCurrentTime {0}", this.ShowCurrentTime);
        }
        private void Btnjijian_Click(object sender, RoutedEventArgs e)
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
        private void btnqujian_Click(object sender, RoutedEventArgs e)
        {
            if (true)//里面掉验证函数
            {
                // 打开子窗体
                QujianWindow aChild = new QujianWindow();
                aChild.Show();
                // 隐藏自己(父窗体)
                this.Visibility = System.Windows.Visibility.Hidden;
            }
        }
        private void btnadministor_Click(object sender, RoutedEventArgs e)
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

        
        private void timerHandler(object source, EventArgs e)
        {

            Console.WriteLine("current Time: " +time); 
            if (time == 0)
            {
                ScreenWindow mw = new ScreenWindow();
                mw.Show();
                this.Visibility = System.Windows.Visibility.Hidden;
            }
            time--;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = new TimeSpan(0, 0, 1);
            //timer.Tick += new EventHandler(timerHandler);
            timer.Tick += new EventHandler(ShowCurTimer);//起个Timer一直获取当前时间
            timer.Start();
        }
    }
}
