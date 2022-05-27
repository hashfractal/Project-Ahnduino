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
	/// ImageExtendList.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class ImageExtendList : Window
	{
		public ImageExtendList(List<Image> images)
		{
			InitializeComponent();
			fullImageList.ItemsSource = images;
		}

		private void fullImageList_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			

			List<Image> temp = new List<Image>();
			foreach (Image i in fullImageList.Items.Cast<Image>().ToList())
			{
				Image image = new Image();
				image.Source = i.Source;
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			ImageViewer imageViewer = new ImageViewer(temp, fullImageList.SelectedIndex);

			imageViewer.Show();
		}
	}
}
