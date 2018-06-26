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
using System.Windows.Threading;
using System.IO;
using System.Windows.Forms;

namespace MasterFreezer.views
{
    /// <summary>
    /// ScreenWindow.xaml 的交互逻辑
    /// </summary>
    public partial class ScreenWindow : Window
    {
        public ScreenWindow()
        {
            InitializeComponent();
            timer = new DispatcherTimer();
            timer.Interval = new TimeSpan(0, 0, 3);
            //timer.Interval = TimeSpan.FromSeconds(0.1);
            timer.Tick += timer1_Tick;
            //timer.Start();  
        }

        private void Window_Load(object sender, RoutedEventArgs e)
        {
            string rootpath = System.Windows.Forms.Application.StartupPath.Substring(0, System.Windows.Forms.Application.StartupPath.LastIndexOf("\\"));
            rootpath = rootpath.Substring(0, rootpath.LastIndexOf("\\")) + "\\image";
            string[] s = SearchFolder(rootpath);
            BitmapImage_Source = new BitmapImage[s.Length];
            int i = 0;
            foreach (string item in s)
            {
                BitmapImage_Source[i] = new BitmapImage(new Uri(@"" + item, UriKind.RelativeOrAbsolute));
                i++;
                //TextBox cc = new TextBox();
                //cc.Text = item;
                //list.Children.Add(cc);
            }
            timer.Start();
        }

        private DispatcherTimer timer;

        /// <summary>  
        /// 测试timer用  
        /// </summary>  
        /// <param name="sender"></param>  
        /// <param name="e"></param>  
        void timer_Tick(object sender, EventArgs e)
        {
            this.Title = string.Concat("TimerWindow  ", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
        }
        /// <summary>  
        /// 改变图片  
        /// </summary>  
        /// <param name="sender"></param>  
        /// <param name="e"></param>  
        private void timer1_Tick(object sender, EventArgs e)
        {
            //（你的定时处理）  
            this.Dispatcher.Invoke(new Action(() =>
            {
                image.Source = BitmapImage_Source[pic_now];
                pic_now++;
                if (pic_now > BitmapImage_Source.Length - 1) { pic_now = 0; }
            }));
        }
        BitmapImage[] BitmapImage_Source;
        int pic_now = 0;
        /// <summary>  
        /// 搜出路径下 文件路径  
        /// </summary>  
        /// <param name="dir"></param>  
        /// <returns></returns>  
        public static string[] SearchFolder(string dir)
        {
            string[] images = null;
            if (System.IO.Directory.Exists(dir))    //如果存在这个文件夹删除之     
            {
                int image_sum = 0;
                foreach (string files in System.IO.Directory.GetFiles(dir))
                {
                    if (files.Contains(".JPG") || files.Contains(".jpg") || files.Contains(".JPEG") || files.Contains(".jpeg") || files.Contains(".bmp") || files.Contains(".BMP") || files.Contains(".GIF") || files.Contains(".gif") || files.Contains(".PNG") || files.Contains(".png"))
                    {
                        image_sum++;
                    }
                }
                images = new string[image_sum];
                image_sum = 0;
                foreach (string files in System.IO.Directory.GetFiles(dir))
                {
                    if (files.Contains(".JPG") || files.Contains(".jpg") || files.Contains(".JPEG") || files.Contains(".jpeg") || files.Contains(".bmp") || files.Contains(".BMP") || files.Contains(".GIF") || files.Contains(".gif") || files.Contains(".PNG") || files.Contains(".png"))
                    {
                        images[image_sum] = files;
                        image_sum++;
                    }
                }
            }

            return images;
        }



        private void MouseDown_Click(object sender, MouseButtonEventArgs e)
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
