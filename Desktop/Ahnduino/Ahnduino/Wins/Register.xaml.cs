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

		#region UserDefineFunc
		string ParsePhone(string Phone)
		{
			string res = Phone;
			res = res.Insert(3, "-");
			res = res.Insert(8, "-");

			return res;
		}
		#endregion

		Firebase firebase = new();
		SolidColorBrush blackbrush = new SolidColorBrush(Colors.Black);
		SolidColorBrush redbrush = new SolidColorBrush(Colors.Red);

		public Register()
		{
			InitializeComponent();
		}

		private void RegBtn_Click(object sender, RoutedEventArgs e)
		{
			string[] vali = Firebase.FBValidation(emailtextbox.Text, passwordtextbox.Text, repasswordtextbox.Text, nametextbox.Text, phonetextbox.Text);
			if(vali[0] != "" | vali[1] != "" | vali[2] != "" | vali[3] != "" | vali[4] != "")
			{
				emailtextbox.Text = vali[0];
				emailtextbox.Foreground = redbrush;
				passwordtextbox.Text = vali[1];
				passwordtextbox.Foreground = redbrush;
				repasswordtextbox.Text = vali[2];
				repasswordtextbox.Foreground = redbrush;
				nametextbox.Text = vali[3];
				nametextbox.Foreground = redbrush;
				phonetextbox.Text = vali[4];
				phonetextbox.Foreground = redbrush;
				return;
			}	

			firebase.Register(emailtextbox.Text, passwordtextbox.Text, repasswordtextbox.Text, nametextbox.Text, phonetextbox.Text);

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
	}
}
