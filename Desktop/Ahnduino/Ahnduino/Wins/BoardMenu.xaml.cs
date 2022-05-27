using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading;
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
	/// BoardMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class BoardMenu : Window
	{
		string uid;

		ObservableCollection<Board> boardlist = new ObservableCollection<Board>();
		Board? board = null;

		public BoardMenu(string uid)
		{
			this.uid = uid;

			InitializeComponent();

			listviewboard.ItemsSource = boardlist;

			Fbad.GetBoardList(boardlist);
		}

		private void buttonsearch_Click(object sender, RoutedEventArgs e)
		{
			Fbad.SearchBoardList(tbsearch.Text, boardlist);
		}

		private void listviewboard_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			ImageList.Items.Clear();

			board = listviewboard.SelectedItem as Board;
			if (board != null)
			{
				tbtitle.Text = board!.title;
				tbthumbup.Text = "👍" + board!.likes.ToString();
				tbtext.Text = board!.text;

				foreach (string i in board!.imagelist!)
				{
					Image image = Fbad.GetImageFromUri(i);
					image.Height = 150;
					image.Width = 150;

					ImageList.Items.Add(image);
				}

			}
			
		}

		private void badd_Click(object sender, RoutedEventArgs e)
		{
			BoardAdd boardAdd = new BoardAdd(null, uid);
			boardAdd.ShowDialog();
			Thread.Sleep(200);
			Fbad.GetBoardList(boardlist);
		}

		private void bNew_Click(object sender, RoutedEventArgs e)
		{
			BoardAdd boardAdd = new BoardAdd(board, uid);
			boardAdd.ShowDialog();
			Thread.Sleep(200);
			Fbad.GetBoardList(boardlist);
		}

		private void bdelete_Click(object sender, RoutedEventArgs e)
		{
			Fbad.DeleteBoard(board!);
			Thread.Sleep(200);
			Fbad.GetBoardList(boardlist);
		}

		private void imglist_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			/*
			if (imglist.SelectedIndex != -1)
			{
				Image img = (Image)imglist.SelectedItem;
				ImageViewer imageViewer = new ImageViewer(img);
				imageViewer.Show();
				imglist.SelectedIndex = -1;
			}
			*/
		}

		private void Button_Click(object sender, RoutedEventArgs e)
		{
			RequestMenu menu = new(uid);
			menu.Show();
			Close();
		}

		private void gotochat_Click(object sender, RoutedEventArgs e)
		{
			ChatMenu menu = new(uid);
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

		private void Build_Click(object sender, RoutedEventArgs e)
		{
			BuildMenu build = new();
			build.Show();
		}

		private void bimgex_Click(object sender, RoutedEventArgs e)
		{
			List<Image> temp = new List<Image>();
			foreach (Image i in ImageList.Items.Cast<Image>().ToList())
			{
				Image image = new Image();
				image.Source = i.Source;
				image.Height = 150;
				image.Width = 150;
				temp.Add(image);
			}
			ImageExtendList imageExtendList = new ImageExtendList(temp);
			imageExtendList.Show();
		}
	}
}
