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
		ObservableCollection<Board> boardlist = new ObservableCollection<Board>();
		Board? board = null;
		string email = "test@test.com";

		public BoardMenu()
		{
			InitializeComponent();

			listviewboard.ItemsSource = boardlist;

			Firebase.GetBoardList(boardlist);
		}

		private void buttonsearch_Click(object sender, RoutedEventArgs e)
		{
			Firebase.SearchBoardList(tbsearch.Text, boardlist);
		}

		private void listviewboard_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			board = listviewboard.SelectedItem as Board;
			if (board != null)
			{
				tbtitle.Text = board!.title;
				tbthumbup.Text = "👍" + board!.likes.ToString();
				tbtext.Text = board!.text;
			}

			foreach (string i in board!.imagelist!)
			{
				Image image = Firebase.GetImageFromUri(i);
				image.Height = 150;
				image.Width = 150;

				imglist.Items.Add(image);
			}
		}

		private void badd_Click(object sender, RoutedEventArgs e)
		{
			BoardAdd boardAdd = new BoardAdd(null, email);
			boardAdd.ShowDialog();
			Thread.Sleep(200);
			buttonsearch_Click(sender, e);
		}

		private void bNew_Click(object sender, RoutedEventArgs e)
		{
			BoardAdd boardAdd = new BoardAdd(board, email);
			boardAdd.ShowDialog();
			Thread.Sleep(200);
			buttonsearch_Click(sender, e);
		}

		private void bdelete_Click(object sender, RoutedEventArgs e)
		{
			Firebase.DeleteBoard(board!);
			Thread.Sleep(200);
			buttonsearch_Click(sender, e);
		}

		private void imglist_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if (imglist.SelectedIndex != -1)
			{
				Image img = (Image)imglist.SelectedItem;
				ImageViewer imageViewer = new ImageViewer(img);
				imageViewer.Show();
				imglist.SelectedIndex = -1;
			}
		}
	}
}
