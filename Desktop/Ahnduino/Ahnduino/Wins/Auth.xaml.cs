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
using Google.Cloud.Firestore;
using Ahnduino.Lib;

namespace Ahnduino.Wins
{
	/// <summary>
	/// Auth.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class Auth : Window
	{
		string password = "";

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
			if (Firebase.Login(IDTextbox.Text, password))
			{
				MainWindow mainWindow = new MainWindow(IDTextbox.Text);
				mainWindow.Show();
				Close();
			}
			else
			{
				MessageBox.Show("실패");
			}
		}

		private void ResetPwBtn_Click(object sender, RoutedEventArgs e)
		{
			ResetPW resetPW = new ResetPW();
			resetPW.ShowDialog();
		}

		private void PWTextbox_KeyDown(object sender, KeyEventArgs e)
		{
			if (PWTextbox.Text.Length > 0 && PWTextbox.Text[^1] != '*')
			{
				password += PWTextbox.Text[^1];
				PWTextbox.Text = PWTextbox.Text.Remove(PWTextbox.Text.Length - 1, 1);
				PWTextbox.Text += "*";
				PWTextbox.CaretIndex = PWTextbox.Text.Length;
			}
			else if (PWTextbox.Text.Length < password.Length)
			{
				password = password.Remove(PWTextbox.Text.Length, password.Length - PWTextbox.Text.Length);
			}
		}

		private void PWTextbox_LostFocus(object sender, RoutedEventArgs e)
		{
			if (PWTextbox.Text.Length > 0 && PWTextbox.Text[^1] != '*')
			{
				password += PWTextbox.Text[^1];
				PWTextbox.Text = PWTextbox.Text.Remove(PWTextbox.Text.Length - 1, 1);
				PWTextbox.Text += "*";
				PWTextbox.CaretIndex = PWTextbox.Text.Length;
			}
		}
	}
}
