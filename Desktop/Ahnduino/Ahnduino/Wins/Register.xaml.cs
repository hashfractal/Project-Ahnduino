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
		public Register()
		{
			InitializeComponent();
		}

		private void RegBtn_Click(object sender, RoutedEventArgs e)
		{
			string vali = Firebase.FBValidation(emailtextbox.Text, passwordtextbox.Text, repasswordtextbox.Text, nametextbox.Text, phonetextbox.Text);
			if(vali != null)
			{
				MessageBox.Show(vali);
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
	}
}
