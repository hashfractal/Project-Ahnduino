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
using System.Threading;

namespace Ahnduino.Wins
{
	/// <summary>
	/// RequestMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class RequestMenu : Window
	{
		string uid;

		Request? request = null;

		ObservableCollection<Request> userlist = new ObservableCollection<Request>();
		ObservableCollection<Request> roomoutlist = new ObservableCollection<Request>();
		//ObservableCollection<string> datelist = new ObservableCollection<string>();
		//ObservableCollection<string> requestlist = new ObservableCollection<string>();

		//string? selectedEmail = null;
		//string? selectedDate = null;

		string[] mlist28 = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
										"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
										"21", "22", "23", "24", "25", "26", "27", "28"};

		string[] mlist29 = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
										"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
										"21", "22", "23", "24", "25", "26", "27", "28", "29"};

		string[] mlist30 = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
										"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
										"21", "22", "23", "24", "25", "26", "27", "28", "29", "30"};

		string[] mlist31 = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
										"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
										"21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"};

		void ResetUI()
		{
			RequestUserListView.SelectedIndex = 0;
			labeltitle.Text = "좌측 리스트에서 항목을 불러와 주십시오";
			labeltext.Content = "문의 내용";
			labelinfo.Text = "희망시각 1:";
			labelinfo.Text = "희망시각 2:";
			labelinfo.Text = "희망시각 3:";
			TextBoxYear.Text = "";
			TextBoxMonth.Text = "";
			TextBoxDay.Text = "";
			tbhour.Text = "";
			tbminute.Text = "";
			cbregion.Text = "";
			cbgu.Text = "";
			cbdong.Text = "";
			cbworker.Text = "";
			ImageList.Items.Clear();
			Fbad.GetRequestList(userlist);
		}

		public RequestMenu(string uid)
		{
			this.uid = uid;
			InitializeComponent();

			RequestUserListView.ItemsSource = userlist;

			DateTime dateTime = DateTime.Now;

			TextBoxYear.Items.Add(string.Format("{0:yyyy}", dateTime));
			TextBoxYear.Items.Add(string.Format("{0:yyyy}", dateTime.AddYears(1)));

			Fbad.GetRequestList(userlist);


			Fbad.SetWorkerComboBox(cbregion, cbgu, cbdong);

			//RequestUserListView.ItemsSource = userlist;
			//RequestDateListView.ItemsSource = datelist;
			//RequestListView.ItemsSource = requestlist;
			//Fbad.GetRequestUserList(userlist);
		}

		private void RequestUserListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			ImageList.Items.Clear();
			request = RequestUserListView.SelectedItem as Request;
			if(request != null)
			{
				labeltitle.Text = request!.Title;
				labelinfo.Text = string.Format("희망시각 1: {0}", request.hopeTime0);
				labelinfo1.Text = string.Format("희망시각 2: {0}", request.hopeTime1);
				labelinfo2.Text = string.Format("희망시각 3: {0}", request.hopeTime2);
				labeltext.Content = request.Text;

				if (request!.Images != null)
				{
					foreach (string i in request!.Images!)
					{
						Image image = Fbad.GetImageFromUri(i);
						image.Height = 150;
						image.Width = 150;

						ImageList.Items.Add(image);
					}
				}

				DateTime dateTime = DateTime.Now;

				TextBoxYear.Text = dateTime.Year.ToString();
				TextBoxMonth.Text = dateTime.Month.ToString();
				TextBoxDay.Text = dateTime.Day.ToString();
			}
			
		}

		private void LoginBtn_Click(object sender, RoutedEventArgs e)
		{
			if (request != null)
			{
				DateTime dt = new DateTime(int.Parse(TextBoxYear.Text), int.Parse(TextBoxMonth.Text), int.Parse(TextBoxDay.Text), int.Parse(tbhour.Text), int.Parse(tbminute.Text), 0);
				request.Reserve = string.Format("{0:yy}/{0:MM}/{0:ddtt hh 시 mm 분}", dt);
				request.Isreserve = true;
				Fbad.UpdateRequest(request.UID, request.Date, request.DocID, request!, cbworker.Text, dt);
			}

			MessageBox.Show("예약완료되었습니다");
			ResetUI();
		}

		private void bcancle_Click(object sender, RoutedEventArgs e)
		{
			Fbad.RemoveRequest(request!.UID, request.Date, request!.DocID, request!, uid);
			ResetUI();
		}

		private void imglist_SelectionChanged(object sender, SelectionChangedEventArgs e)
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

		private void bimgex_Click(object sender, RoutedEventArgs e)
		{
			List<Image> temp = new List<Image>();
			foreach(Image i in ImageList.Items.Cast<Image>().ToList())
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

		private void TextBoxMonth_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if(TextBoxMonth.SelectedItem != null)
			{
				string s = TextBoxMonth!.SelectedItem!.ToString()!;
				string[] sl = s.Split(' ');
				DateTime dateTime = new DateTime(2000, int.Parse(sl[1]), 1);
				if (DateTime.DaysInMonth(int.Parse(TextBoxYear.Text), dateTime.Month) == 28)
					TextBoxDay.ItemsSource = mlist28;
				else if (DateTime.DaysInMonth(int.Parse(TextBoxYear.Text), dateTime.Month) == 29)
					TextBoxDay.ItemsSource = mlist29;
				else if (DateTime.DaysInMonth(int.Parse(TextBoxYear.Text), dateTime.Month) == 30)
					TextBoxDay.ItemsSource = mlist30;
				else if (DateTime.DaysInMonth(int.Parse(TextBoxYear.Text), dateTime.Month) == 31)
					TextBoxDay.ItemsSource = mlist31;
			}
		}

		private void ImageList_GotMouseCapture(object sender, MouseEventArgs e)
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

		private void cbdong_SelectionChanged(object sender, SelectionChangedEventArgs e)
		{
			if(cbregion.Text != "" && cbgu.Text != "")
			{
				cbworker.ItemsSource = Fbad.SetWorker(cbregion.Text, cbgu.Text, cbdong.SelectedItem.ToString()!);
			}
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

