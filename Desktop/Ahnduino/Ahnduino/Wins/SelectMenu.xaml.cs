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
	/// SelectMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class SelectMenu : Window
	{
		Build? build;

		public SelectMenu()
		{
			InitializeComponent();
		}

		private void bsearchbuild_Click(object sender, RoutedEventArgs e)
		{
			try
			{
				if (textboxemail.Text.EndsWith(")"))
				{
					build = Fbad.GetBuildFormFullAddress(textboxemail.Text);
				}
				else if (cbtype.Text == "주소")
				{
					LVUserlist.ItemsSource = Fbad.GetBuildListFormAddress(textboxemail.Text);
				}
				else
				{
					build = Fbad.GetBuildFormID(textboxemail.Text);
					LVUserlist.ItemsSource = Fbad.GetBuildListFormAddress(build.주소!);
				}
			}
			catch (Exception)
			{
			}

		}

		private void LVUserlist_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			build = LVUserlist.SelectedItem as Build;
			Fbad.searchresult = build!.주소 + "(" + build.건물명 + ")";
			Close();
		}
	}
}
