// © 2007 Michele Leroux Bustamante. All rights reserved 
// Book: Learning WCF, O'Reilly
// Book Blog: www.thatindigogirl.com
// Michele's Blog: www.dasblonde.net
// IDesign: www.idesign.net

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using System.Diagnostics;

namespace Client
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
         
        }

        private void button1_Click(object sender, EventArgs e)
        {
            localhost.HelloIndigoServiceClient proxy = new Client.localhost.HelloIndigoServiceClient("NetTcpBinding_IHelloIndigoService");
            string s = proxy.HelloIndigo("Hello over TCP protocol with NetTcpBinding!");
            MessageBox.Show(s);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            localhost.HelloIndigoServiceClient proxy = new Client.localhost.HelloIndigoServiceClient("BasicHttpBinding_IHelloIndigoService");
            string s = proxy.HelloIndigo("Hello over HTTP protocol with BasicHttpBinding!");
            MessageBox.Show(s);


            proxy = new Client.localhost.HelloIndigoServiceClient("WSHttpBinding_IHelloIndigoService");
            s = proxy.HelloIndigo("Hello over HTTP protocol with WSHttpBinding!");
            MessageBox.Show(s);

        }

        private void button3_Click(object sender, EventArgs e)
        {
            localhost.HelloIndigoServiceClient proxy = new Client.localhost.HelloIndigoServiceClient("NetNamedPipeBinding_IHelloIndigoService");
            string s = proxy.HelloIndigo("Hello over named pipes protocol with NetNamedPipeBinding!");
            MessageBox.Show(s);

        }
    }
}