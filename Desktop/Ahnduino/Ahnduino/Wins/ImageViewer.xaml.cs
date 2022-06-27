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

namespace Ahnduino.Wins
{
	/// <summary>
	/// ImageViewer.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class ImageViewer : Window
	{
		public ImageViewer(List<Image> images, int idx)
		{
			Image img = new Image();

			

			InitializeComponent();
			imglist.ItemsSource = images;
			imglist.SelectedIndex = idx;
		}

		private void imageviewer_MouseDown(object sender, MouseButtonEventArgs e)
		{
			Close();
		}

		private void fullImageList_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			imageviewer.Children.Clear();
			Image img = new Image();
			img.Source = ((Image)imglist.SelectedItem).Source;
			imageviewer.Children.Add(img);
		}

		private void bleft_Click(object sender, RoutedEventArgs e)
		{
			if (imglist.SelectedIndex == 0)
				imglist.SelectedIndex = imglist.Items.Count - 1;
			else
				imglist.SelectedIndex = --imglist.SelectedIndex;

			
		}

		private void bright_Click(object sender, RoutedEventArgs e)
		{
			if (imglist.SelectedIndex == imglist.Items.Count - 1)
				imglist.SelectedIndex = 0;
			else
				imglist.SelectedIndex = ++imglist.SelectedIndex;
		}
	}
}
