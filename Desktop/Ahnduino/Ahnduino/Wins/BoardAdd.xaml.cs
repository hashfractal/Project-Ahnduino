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
using Google.Cloud.Firestore;
using Ahnduino.Lib;
using Ahnduino.Lib.Object;
using Microsoft.Win32;

namespace Ahnduino.Wins
{
	/// <summary>
	/// BoardAdd.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class BoardAdd : Window
	{
		Board? board;
		string email;
		public BoardAdd(Board? board, string email)
		{
			InitializeComponent();

			this.board = board;
			this.email = email;

			if (board != null)
			{
				bcreate.Content = "게시글 수정";
				tbtitle.Text = board.title;
				tbtext.Text = board.text;

				foreach (string i in board!.imagelist!)
				{
					Image image = Fbad.GetImageFromUri(i);
					image.Height = 150;
					image.Width = 150;

					imglist.Items.Add(image);
				}
			}
				
			else
				bcreate.Content = "게시글 추가";

		}

		private void bcreate_Click(object sender, RoutedEventArgs e)
		{
			Board board = new Board();
			if (this.board != null)
			{
				board = this.board;
			}
			else
				board.likes = 0;

			board!.title = tbtitle.Text;
			board.text = tbtext.Text;
			board.name = "관리자";
			board.user = email;
			board.time = Timestamp.FromDateTime(DateTime.UtcNow);
			board.Date = string.Format("{0:yyyy/MM/dd}", DateTime.Now);

			if(this.board != null  && this.board.imagelist != null)
			{
				board.imagelist = this.board.imagelist;
			}
			

			Fbad.CreateBoard(board);

			Close();
		}

		private void baddimage_Click(object sender, RoutedEventArgs e)
		{
			Board board = new Board();
			if (this.board != null)
			{
				board = this.board;
			}
			else
				board.likes = 0;

			board!.title = tbtitle.Text;
			board.text = tbtext.Text;
			board.name = "관리자";
			board.user = email;
			board.time = Timestamp.FromDateTime(DateTime.UtcNow);
			board.Date = string.Format("{0:yyyy/MM/dd}", DateTime.Now);

			OpenFileDialog openFileDialog = new OpenFileDialog();
			openFileDialog.Multiselect = true;

			if (openFileDialog.ShowDialog() == true)
			{
				Fbad.BoardAddimage(board, openFileDialog.FileNames , Fbad.CreateBoard(board));
			}

			foreach (string i in board!.imagelist!)
			{
				Image image = Fbad.GetImageFromUri(i);
				image.Height = 150;
				image.Width = 150;

				imglist.Items.Add(image);
			}
			this.board = board;
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

		private void tbtitle_GotFocus(object sender, RoutedEventArgs e)
		{
			tbtitle.Text = "";
		}

		private void tbtext_GotFocus(object sender, RoutedEventArgs e)
		{
			tbtext.Text = "";
		}
	}
}
