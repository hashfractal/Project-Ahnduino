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
using Ahnduino.Lib.Object;

namespace Ahnduino.Wins
{
	/// <summary>
	/// BuildMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class BuildMenu : Window
	{
		Build? build;

		void SetBuild()
		{
			try
			{
				tbaddress.Text = build!.주소;
				tbname.Text = build.건물명;
				tbid.Text = build.인증번호;
				tbused.Text = (bool)build.Used! ? "아니오" : "예";
				tbpay.Text = build.관리비.ToString();
				tbunpaid.Text = (bool)build.미납! ? "미납" : "완납";
				tbrepair.Text = (bool)build.수리비! ? "있음" : "없음";
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.ToString());
				throw;
			}
			
		}

		public BuildMenu()
		{
			InitializeComponent();
		}

		private void bsearchbuild_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				if (cbtype.Text.EndsWith(")"))
				{
					build = Fbad.GetBuildFormFullAddress(textboxemail.Text);
					SetBuild();
				}
				else if (cbtype.Text == "주소")
				{
					LVUserlist.ItemsSource = Fbad.GetBuildListFormAddress(textboxemail.Text);
				}
				else
				{
					build = Fbad.GetBuildFormID(textboxemail.Text);
					SetBuild();
				}
			}
			catch (Exception)
			{
			}
			
		}

		private void bbuildid_Click(object sender, RoutedEventArgs e)
		{
		}

		private void LVUserlist_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			build = LVUserlist.SelectedItem as Build;
			SetBuild();
		}

		private void Button_Click(object sender, RoutedEventArgs e)
		{
			AddBuild addBuild = new AddBuild();
			addBuild.ShowDialog();
		}

		private void Button_Click_1(object sender, RoutedEventArgs e)
		{
			Fbad.DeleteBuild(tbaddress.Text + "(" + tbname.Text + ")");
			textboxemail.Text = "";
			tbaddress.Text = "";
			tbname.Text = "";
			tbid.Text = "";
			tbused.Text = "";
			tbpay.Text = "";
			tbunpaid.Text = "";
			tbrepair.Text = "";
		}
	}
}
