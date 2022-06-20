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

		private void lbin_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			List<Image> images = new List<Image>();

			for (int i = 0; i < lbin.Items.Count; i++)
			{
				Image img = new Image();

				Room? room = lbin.Items[i] as Room;
				img.Source = new BitmapImage(new Uri(room!.image!));
				images.Add(img);
			}

			ImageViewer imageViewer = new ImageViewer(images, lbin.SelectedIndex);
			imageViewer.Show();
		}

		private void lbout_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			List<Image> images = new List<Image>();

			for (int i = 0; i < lbin.Items.Count; i++)
			{
				Image img = new Image();

				Room? room = lbout.Items[i] as Room;
				img.Source = new BitmapImage(new Uri(room!.image!));
				images.Add(img);
			}

			ImageViewer imageViewer = new ImageViewer(images, lbin.SelectedIndex);
			imageViewer.Show();
		}

		private void lbrequest_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			List<Image> temp = new List<Image>();

			
			if (((Request)lbrequest!.SelectedItem!).image0 != null)
			{
				Image image = new Image();
				image.Source = new BitmapImage(new Uri(((Request)lbrequest!.SelectedItem!).image0!));
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			if (((Request)lbrequest!.SelectedItem!).image1 != null)
			{
				Image image = new Image();
				image.Source = new BitmapImage(new Uri(((Request)lbrequest!.SelectedItem!).image1!));
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			if (((Request)lbrequest!.SelectedItem!).image2 != null)
			{
				Image image = new Image();
				image.Source = new BitmapImage(new Uri(((Request)lbrequest!.SelectedItem!).image2!));
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			if (((Request)lbrequest!.SelectedItem!).image3 != null)
			{
				Image image = new Image();
				image.Source = new BitmapImage(new Uri(((Request)lbrequest!.SelectedItem!).image3!));
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			if (((Request)lbrequest!.SelectedItem!).image4 != null)
			{
				Image image = new Image();
				image.Source = new BitmapImage(new Uri(((Request)lbrequest!.SelectedItem!).image4!));
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			ImageExtendList imageExtendList = new ImageExtendList(temp);
			imageExtendList.Show();
		}
	}
}
