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
using System.Net.Mail;
using Ahnduino.Lib;
using System.Net;

namespace Ahnduino.Wins
{
	/// <summary>
	/// Auth.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class Auth : Window
	{
		Firebase Firebase = new();
		public Auth()
		{
			InitializeComponent();
		}

		private void RegisterBtn_Click(object sender, RoutedEventArgs e)
		{
			Register register = new();
			register.ShowDialog();
		}

		private void LoginBtn_Click(object sender, RoutedEventArgs e)
		{
			if(Firebase.Login(IDTextbox.Text,PWTextbox.Text))
			{
				MessageBox.Show("성공");
			}
			else
			{
				MessageBox.Show("실패");
			}
		}

		private void ResetPwBtn_Click(object sender, RoutedEventArgs e)
		{
			SmtpClient smtp = new SmtpClient
			{
				Host = "smtp.gmail.com",
				EnableSsl = true,
				DeliveryMethod = SmtpDeliveryMethod.Network,
				Credentials = new NetworkCredential(),
				Timeout = 20000
			};

			MailMessage message = new MailMessage("hsj", "hsj3925@naver.com")
			{
				Body = "test"
			};
			smtp.Send(message);
		}
	}
}
