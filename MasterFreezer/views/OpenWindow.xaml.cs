using System;
using System.Collections.Generic;
using System.Linq;
using System.Media;
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
using System.Windows.Threading;

namespace MasterFreezer
{
    // OpenWindow.xaml 的交互逻辑
    public partial class OpenWindow : Window
    {
        // after 3000ms performance closeHandler
        private int time = 6;

        public OpenWindow()
        {
            this.Loaded += Window_Loaded;
            InitializeComponent();
            Console.WriteLine("init..");
        }

        
        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            Console.WriteLine("Window Loaded...");
            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = new TimeSpan(0, 0, 1);
            timer.Tick += new EventHandler(timerHandler);
            timer.Start();
            //语音提示
            SoundPlayer simpleSound = new SoundPlayer();
            string rootpath = System.Windows.Forms.Application.StartupPath.Substring(0, System.Windows.Forms.Application.StartupPath.LastIndexOf("\\"));
            rootpath = rootpath.Substring(0, rootpath.LastIndexOf("\\")) + "\\yuyintishi";
            simpleSound.SoundLocation = rootpath+ "\\01+Lost+Stars.wav";
            simpleSound.Load();
            simpleSound.Play();
        }

        private void timerHandler(object source, EventArgs e)
        {
            Console.WriteLine("current Time: " + time);
            if (time == 0)
            {
                MainWindow mw = new MainWindow();
                mw.Show();
                this.Visibility = System.Windows.Visibility.Hidden;
            }
            time--;
            String tStr = time.ToString();
            lblSecond.Text = tStr;
        }
    }
}




