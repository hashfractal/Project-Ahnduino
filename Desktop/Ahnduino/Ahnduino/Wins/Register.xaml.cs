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
using Ahnduino.Lib;

namespace Ahnduino.Wins
{
	/// <summary>
	/// Register.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class Register : Window
	{
		/*Firebase firebase = new();*/
		SolidColorBrush blackbrush = new SolidColorBrush(Colors.Black);
		SolidColorBrush redbrush = new SolidColorBrush(Colors.Red);

		string password = "";
		string repassword = "";

		#region UserDefineFunc
		string ParsePhone(string Phone)
		{
			string res = Phone;
			res = res.Insert(3, "-");
			res = res.Insert(8, "-");

			return res;
		}
		#endregion

		

		public Register()
		{
			InitializeComponent();
		}

		private void RegBtn_Click(object sender, RoutedEventArgs e)
		{
			string[] vali = Firebase.FBValidation(emailtextbox.Text, password, repassword, nametextbox.Text, phonetextbox.Text);
			if(vali[0] != "" | vali[1] != "" | vali[2] != "" | vali[3] != "" | vali[4] != "")
			{
				if (vali[0] != "")
				{
					emailtextbox.Text = vali[0];
					emailtextbox.Foreground = redbrush;
				}

				if (vali[1] != "")
				{
					passwordtextbox.Text = vali[1];
					passwordtextbox.Foreground = redbrush;
				}

				if (vali[2] != "")
				{
					repasswordtextbox.Text = vali[2];
					repasswordtextbox.Foreground = redbrush;
				}

				if (vali[3] != "")
				{
					nametextbox.Text = vali[3];
					nametextbox.Foreground = redbrush;
				}

				if (vali[4] != "")
				{
					phonetextbox.Text = vali[4];
					phonetextbox.Foreground = redbrush;
				}

				return;
			}	

			Firebase.Register(emailtextbox.Text, password, repassword, nametextbox.Text, phonetextbox.Text);

			MessageBox.Show("회원가입이 완료되었습니다");

			Close();
		}

		private void phonetextbox_TextChanged(object sender, TextChangedEventArgs e)
		{
			if (phonetextbox.Text.Length == 11 && !phonetextbox.Text.Contains('-'))
				phonetextbox.Text = ParsePhone(phonetextbox.Text);

			phonetextbox.CaretIndex = phonetextbox.Text.Length;
		}

		private void emailtextbox_GotFocus(object sender, RoutedEventArgs e)
		{
			if(emailtextbox.Foreground == redbrush)
			{
				emailtextbox.Foreground = blackbrush;
				emailtextbox.Text = "";
			}
			
		}

		private void passwordtextbox_GotFocus(object sender, RoutedEventArgs e)
		{
			if (passwordtextbox.Foreground == redbrush)
			{
				passwordtextbox.Foreground = blackbrush;
				passwordtextbox.Text = "";
			}
			
		}

		private void repasswordtextbox_GotFocus(object sender, RoutedEventArgs e)
		{
			if (repasswordtextbox.Foreground == redbrush)
			{
				repasswordtextbox.Foreground = blackbrush;
				repasswordtextbox.Text = "";
			}
			
		}

		private void nametextbox_GotFocus(object sender, RoutedEventArgs e)
		{
			if (nametextbox.Foreground == redbrush)
			{
				nametextbox.Foreground = blackbrush;
				nametextbox.Text = "";
			}
			
		}

		private void phonetextbox_GotFocus(object sender, RoutedEventArgs e)
		{
			if (phonetextbox.Foreground == redbrush)
			{
				phonetextbox.Foreground = blackbrush;
				phonetextbox.Text = "";
			}
			
		}

		private void passwordtextbox_KeyDown(object sender, KeyEventArgs e)
		{
			if (passwordtextbox.Text.Length > 0 && passwordtextbox.Text[^1] != '*')
			{
				password += passwordtextbox.Text[^1];
				passwordtextbox.Text = passwordtextbox.Text.Remove(passwordtextbox.Text.Length - 1, 1);
				passwordtextbox.Text += "*";
				passwordtextbox.CaretIndex = passwordtextbox.Text.Length;
			}
			else if (passwordtextbox.Text.Length < password.Length)
			{
				password = password.Remove(passwordtextbox.Text.Length, password.Length - passwordtextbox.Text.Length);
			}
			Console.WriteLine("1" + password);
		}

		private void passwordtextbox_LostFocus(object sender, RoutedEventArgs e)
		{
			if (passwordtextbox.Text.Length > 0 && passwordtextbox.Text[^1] != '*')
			{
				password += passwordtextbox.Text[^1];
				passwordtextbox.Text = passwordtextbox.Text.Remove(passwordtextbox.Text.Length - 1, 1);
				passwordtextbox.Text += "*";
				passwordtextbox.CaretIndex = passwordtextbox.Text.Length;
			}
			Console.WriteLine("1" + password);
		}

		private void repasswordtextbox_KeyDown(object sender, KeyEventArgs e)
		{
			if (repasswordtextbox.Text.Length > 0 && repasswordtextbox.Text[^1] != '*')
			{
				repassword += repasswordtextbox.Text[^1];
				repasswordtextbox.Text = repasswordtextbox.Text.Remove(repasswordtextbox.Text.Length - 1, 1);
				repasswordtextbox.Text += "*";
				repasswordtextbox.CaretIndex = repasswordtextbox.Text.Length;
			}
			else if (repasswordtextbox.Text.Length < repassword.Length)
			{
				repassword = repassword.Remove(repasswordtextbox.Text.Length, repassword.Length - repasswordtextbox.Text.Length);
			}
			Console.WriteLine("2" + repassword);
		}

		private void repasswordtextbox_LostFocus(object sender, RoutedEventArgs e)
		{
			if (repasswordtextbox.Text.Length > 0 && repasswordtextbox.Text[^1] != '*')
			{
				repassword += repasswordtextbox.Text[^1];
				repasswordtextbox.Text = passwordtextbox.Text.Remove(repasswordtextbox.Text.Length - 1, 1);
				repasswordtextbox.Text += "*";
				repasswordtextbox.CaretIndex = repasswordtextbox.Text.Length;
			}
			Console.WriteLine("2" + repassword);
		}
	}
}
