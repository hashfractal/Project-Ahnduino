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
	/// InfoMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class InfoMenu : Window
	{
		string uid;
		public InfoMenu(string uid)
		{
			this.uid = uid;

			InitializeComponent();
		}

		private void Button_Click(object sender, RoutedEventArgs e)
		{
			Fbad.GetCheckInList(Fbad.getEmail(textboxemail.Text), lbin, lbout);
			Fbad.GetInfoRepairList(Fbad.getEmail(textboxemail.Text), lbrequest);
		}

		#region Sidemenu
		private void Build_Click(object sender, RoutedEventArgs e)
		{
			BuildMenu build = new();
			build.Show();
		}
		private void gotochat_Click(object sender, RoutedEventArgs e)
		{
			ChatMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotoboard_Click(object sender, RoutedEventArgs e)
		{
			BoardMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotobill_Click(object sender, RoutedEventArgs e)
		{
			BillMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotogallery_Click(object sender, RoutedEventArgs e)
		{
			InfoMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void Fixhold_Click(object sender, RoutedEventArgs e)
		{
			FixHoldMenu menu = new(uid);
			menu.Show();
			Close();
		}
		#endregion
	}
}
