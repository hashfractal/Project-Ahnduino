using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
namespace Ahnduino.Wins
{
	/// <summary>
	/// RequestMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class RequestMenu : Window
	{
		string uid;

		Request? request = null;

		ObservableCollection<string> userlist = new ObservableCollection<string>();
		ObservableCollection<string> datelist = new ObservableCollection<string>();
		ObservableCollection<string> requestlist = new ObservableCollection<string>();

		string? selectedEmail = null;
		string? selectedDate = null;

		public RequestMenu(string uid)
		{
			this.uid = uid;
			InitializeComponent();

			this.FontFamily = new FontFamily("Default");

			RequestUserListView.ItemsSource = userlist;
			RequestDateListView.ItemsSource = datelist;
			RequestListView.ItemsSource = requestlist;
			Fbad.GetRequestUserList(userlist);
		}

		private void RequestUserListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			selectedEmail = (string)RequestUserListView.SelectedItem;
			Fbad.GetDateList(null, datelist);
			Fbad.GetDateList(selectedEmail, datelist);
		}

		private void RequestDateListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			selectedDate = (string)RequestDateListView.SelectedItem;
			Fbad.GetRequestList(null, null, requestlist);
			Fbad.GetRequestList(selectedEmail, selectedDate, requestlist);
		}

		private void RequestListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{

			ImageList.Items.Clear();
			request = Fbad.GetRequest(selectedEmail, selectedDate, (string)RequestListView.SelectedItem);

			

			labeltitle.Text = request!.Title;
			labelinfo.Text = string.Format("희망시각 1: {0}", request.hopeTime0);
			labelinfo1.Text = string.Format("희망시각 2: {0}", request.hopeTime1);
			labelinfo2.Text = string.Format("희망시각 3: {0}", request.hopeTime2);
			labeltext.Content = request.Text;

			foreach (string i in request!.Images!)
			{
				Image image = Fbad.GetImageFromUri(i);
				image.Height = 150;
				image.Width = 150;

				ImageList.Items.Add(image);
			}
		}

		private void LoginBtn_Click(object sender, RoutedEventArgs e)
		{
			if (request != null)
			{
				DateTime dt = new DateTime(int.Parse(TextBoxYear.Text), int.Parse(TextBoxMonth.Text), int.Parse(TextBoxDay.Text), int.Parse(tbhour.Text), int.Parse(tbminute.Text), 0);
				request.Reserve = string.Format("{0:yy}/{0:MM}/{0:ddtt hh 시 mm 분}", dt);
				request.Isreserve = true;
				Fbad.UpdateRequest(selectedEmail, selectedDate, (string)RequestListView.SelectedItem, request!, tbworker.Text, dt);
			}

			MessageBox.Show("예약완료되었습니다");
		}

		private void tbworker_GotFocus(object sender, RoutedEventArgs e)
		{
			if (tbworker.Text == "현장직 Email")
				tbworker.Text = "";
		}

		private void ImageList_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if(ImageList.SelectedIndex != -1)
			{
				Image img = (Image)ImageList.SelectedItem;
				ImageViewer imageViewer = new ImageViewer(img);
				imageViewer.Show();
				ImageList.SelectedIndex = -1;
			}
			
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

		private void bcancle_Click(object sender, RoutedEventArgs e)
		{
			Fbad.RemoveRequest(selectedEmail, selectedDate, (string)RequestListView.SelectedItem, request!, uid);
		}
	}
}

